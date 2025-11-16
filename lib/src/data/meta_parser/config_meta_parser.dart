import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_cache_constants.dart';
import 'package:flutter_paginatrix/src/core/contracts/meta_parser.dart';
import 'package:flutter_paginatrix/src/core/entities/page_meta.dart';
import 'package:flutter_paginatrix/src/core/entities/pagination_error.dart';
import 'package:flutter_paginatrix/src/core/utils/error_utils.dart';

part 'config_meta_parser.freezed.dart';
part 'config_meta_parser.g.dart';

/// Configuration for meta parsing
@freezed
class MetaConfig with _$MetaConfig {
  const factory MetaConfig({
    /// Path to items array (e.g., 'data.items', 'results')
    required String itemsPath,

    /// Path to current page (e.g., 'meta.current_page', 'page')
    String? pagePath,

    /// Path to per page count (e.g., 'meta.per_page', 'limit')
    String? perPagePath,

    /// Path to total count (e.g., 'meta.total', 'total')
    String? totalPath,

    /// Path to last page (e.g., 'meta.last_page', 'total_pages')
    String? lastPagePath,

    /// Path to has more flag (e.g., 'meta.has_more', 'has_next')
    String? hasMorePath,

    /// Path to next cursor (e.g., 'meta.next_cursor', 'next')
    String? nextCursorPath,

    /// Path to previous cursor (e.g., 'meta.previous_cursor', 'prev')
    String? previousCursorPath,

    /// Path to offset (e.g., 'meta.offset', 'skip')
    String? offsetPath,

    /// Path to limit (e.g., 'meta.limit', 'take')
    String? limitPath,
  }) = _MetaConfig;

  factory MetaConfig.fromJson(Map<String, dynamic> json) =>
      _$MetaConfigFromJson(json);

  /// Nested meta format: {data: [], meta: {current_page, per_page, ...}}
  static const MetaConfig nestedMeta = MetaConfig(
    itemsPath: 'data',
    pagePath: 'meta.current_page',
    perPagePath: 'meta.per_page',
    totalPath: 'meta.total',
    lastPagePath: 'meta.last_page',
    hasMorePath: 'meta.has_more',
  );

  /// Results format: {results: [], count, page, per_page, ...}
  static const MetaConfig resultsFormat = MetaConfig(
    itemsPath: 'results',
    pagePath: 'page',
    perPagePath: 'per_page',
    totalPath: 'count',
    lastPagePath: 'total_pages',
    hasMorePath: 'has_next',
  );

  /// Simple page-based config
  static const MetaConfig pageBased = MetaConfig(
    itemsPath: 'data',
    pagePath: 'page',
    perPagePath: 'per_page',
    totalPath: 'total',
    lastPagePath: 'last_page',
    hasMorePath: 'has_more',
  );

  /// Cursor-based config
  static const MetaConfig cursorBased = MetaConfig(
    itemsPath: 'data',
    nextCursorPath: 'meta.next_cursor',
    previousCursorPath: 'meta.previous_cursor',
    hasMorePath: 'meta.has_more',
  );

  /// Offset/limit config
  static const MetaConfig offsetBased = MetaConfig(
    itemsPath: 'data',
    offsetPath: 'meta.offset',
    limitPath: 'meta.limit',
    totalPath: 'meta.total',
    hasMorePath: 'meta.has_more',
  );
}

/// Meta parser that uses configuration-based path extraction

/// Simple LRU (Least Recently Used) cache implementation
///
/// Uses Dart's Map insertion order to implement LRU eviction.
/// When items are accessed, they're moved to the end (most recently used).
/// When cache is full, items are evicted from the beginning (least recently used).
class _LRUCache<K, V> {
  _LRUCache(this.maxSize) : _cache = {};

  final Map<K, V> _cache;
  final int maxSize;

  /// Gets a value from the cache, moving it to the end (most recently used)
  V? get(K key) {
    final value = _cache.remove(key);
    if (value != null) {
      _cache[key] = value; // Re-add to move to end (LRU behavior)
    }
    return value;
  }

  /// Checks if the cache contains a key
  bool containsKey(K key) => _cache.containsKey(key);

  /// Puts a value in the cache, evicting least recently used if needed
  void put(K key, V value) {
    // Remove existing entry if present (will be re-added at end)
    _cache.remove(key);

    // Evict least recently used if at capacity
    if (_cache.length >= maxSize) {
      final firstKey = _cache.keys.first;
      _cache.remove(firstKey);
    }

    // Add new entry at end (most recently used)
    _cache[key] = value;
  }

  /// Clears the cache
  void clear() => _cache.clear();

  /// Gets the current cache size
  int get length => _cache.length;
}

class ConfigMetaParser implements MetaParser {
  ConfigMetaParser(this._config);
  final MetaConfig _config;

  // LRU cache for parsed path segments to avoid repeated splitting
  // Limited size prevents unbounded memory growth
  static const int _maxPathCacheSize = 200;
  final _LRUCache<String, List<String>> _pathCache =
      _LRUCache(_maxPathCacheSize);

  // LRU cache for parsed metadata to avoid re-parsing same data structures
  // Uses a simple hash of the data structure as key
  // Limited size prevents unbounded memory growth
  final _LRUCache<int, PageMeta> _metaCache =
      _LRUCache(PaginatrixCacheConstants.maxMetaCacheSize);

  /// Checks if this parser is configured for offset-based pagination
  bool get isOffsetBased {
    return _config.offsetPath != null &&
        _config.offsetPath!.isNotEmpty &&
        _config.limitPath != null &&
        _config.limitPath!.isNotEmpty &&
        _config.pagePath == null;
  }

  /// Checks if at least one pagination path is configured
  ///
  /// This helper method eliminates code duplication by centralizing
  /// the logic for checking if any pagination paths are configured.
  bool _hasConfiguredPaginationPath() {
    return (_config.pagePath != null && _config.pagePath!.isNotEmpty) ||
        (_config.perPagePath != null && _config.perPagePath!.isNotEmpty) ||
        (_config.nextCursorPath != null &&
            _config.nextCursorPath!.isNotEmpty) ||
        (_config.offsetPath != null && _config.offsetPath!.isNotEmpty) ||
        (_config.limitPath != null && _config.limitPath!.isNotEmpty) ||
        (_config.hasMorePath != null && _config.hasMorePath!.isNotEmpty);
  }

  @override
  PageMeta parseMeta(Map<String, dynamic> data) {
    try {
      // Validate data structure before parsing to provide specific error messages
      // Only validate if we have configured paths - skip validation for graceful handling
      // of null/empty/invalid paths (they'll be handled during parsing)
      if (_hasConfiguredPaginationPath()) {
        final validationError = _validateMetadataStructure(data);
        if (validationError != null) {
          throw ErrorUtils.createParseError(
            message: validationError,
            expectedFormat: _getExpectedFormatDescription(),
            actualData: data,
          );
        }
      }

      // Only compute hash if we're going to cache (optimization)
      // Only cache if data structure is reasonably small to avoid memory issues
      int? dataHash;
      if (data.length < PaginatrixCacheConstants.maxDataSizeForCaching) {
        dataHash = _computeSimpleHash(data);
        final cachedMeta = _metaCache.get(dataHash);
        if (cachedMeta != null) {
          // Validate hash collision: verify cached meta matches current data structure
          // This prevents returning incorrect metadata due to hash collisions
          if (_validateCachedMeta(cachedMeta, data)) {
            return cachedMeta;
          } else {
            // Hash collision detected - remove from cache and continue parsing
            _metaCache.put(
                dataHash, cachedMeta); // Re-add to maintain LRU order
            // Continue to parse fresh metadata below
          }
        }
      }

      // Safe type extraction with runtime checks
      final pageValue = _extractValue(data, _config.pagePath);
      final page = pageValue is int ? pageValue : null;

      final perPageValue = _extractValue(data, _config.perPagePath);
      final perPage = perPageValue is int ? perPageValue : null;

      final totalValue = _extractValue(data, _config.totalPath);
      final total = totalValue is int ? totalValue : null;

      final lastPageValue = _extractValue(data, _config.lastPagePath);
      final lastPage = lastPageValue is int ? lastPageValue : null;

      final hasMoreValue = _extractValue(data, _config.hasMorePath);
      final hasMore = hasMoreValue is bool ? hasMoreValue : null;

      final nextCursorValue = _extractValue(data, _config.nextCursorPath);
      final nextCursor = nextCursorValue is String ? nextCursorValue : null;

      final previousCursorValue =
          _extractValue(data, _config.previousCursorPath);
      final previousCursor =
          previousCursorValue is String ? previousCursorValue : null;

      final offsetValue = _extractValue(data, _config.offsetPath);
      final offset = offsetValue is int ? offsetValue : null;

      final limitValue = _extractValue(data, _config.limitPath);
      final limit = limitValue is int ? limitValue : null;

      // Check which pagination type we have (if any)
      // If none found, we'll fallback to basic meta (all nulls), which is valid
      final hasPageBased = page != null && perPage != null;
      final hasCursorBased = nextCursor != null || hasMore != null;
      final hasOffsetBased = offset != null && limit != null;

      // Determine pagination type and create appropriate PageMeta
      final PageMeta result;
      if (hasPageBased) {
        // Use explicit non-nullable variables to satisfy type system
        final pageValue = page;
        final perPageValue = perPage;
        result = PageMeta.pageBased(
          page: pageValue,
          perPage: perPageValue,
          total: total,
          lastPage: lastPage,
          hasMore: hasMore ?? (lastPage != null ? pageValue < lastPage : null),
        );
      } else if (hasCursorBased) {
        result = PageMeta.cursorBased(
          nextCursor: nextCursor,
          previousCursor: previousCursor,
          hasMore: hasMore,
        );
      } else if (hasOffsetBased) {
        // Use explicit non-nullable variables to satisfy type system
        final offsetValue = offset;
        final limitValue = limit;
        result = PageMeta.offsetBased(
          offset: offsetValue,
          limit: limitValue,
          total: total,
          hasMore: hasMore ??
              (total != null ? offsetValue + limitValue < total : null),
        );
      } else {
        // Fallback to basic meta (should not reach here due to validation above)
        result = PageMeta(
          page: page,
          perPage: perPage,
          total: total,
          lastPage: lastPage,
          hasMore: hasMore,
          nextCursor: nextCursor,
          previousCursor: previousCursor,
          offset: offset,
          limit: limit,
        );
      }

      // Cache only if we computed hash
      if (dataHash != null) {
        _metaCache.put(dataHash, result);
      }

      return result;
    } on PaginationError {
      // Re-throw PaginationError as-is (already properly formatted)
      rethrow;
    } catch (e) {
      // Catch any unexpected errors and provide detailed error message
      throw ErrorUtils.createParseError(
        message: 'Unexpected error while parsing pagination metadata: $e',
        expectedFormat: _getExpectedFormatDescription(),
        actualData: data,
      );
    }
  }

  /// Validates the metadata structure and returns a specific error message if invalid.
  ///
  /// Performs comprehensive validation to provide specific error messages about
  /// what's wrong with the data structure before attempting to parse it.
  ///
  /// **Returns:**
  /// - `null` if structure is valid
  /// - Specific error message string if structure is invalid
  String? _validateMetadataStructure(Map<String, dynamic> data) {
    // Check if data is actually a Map
    if (data.isEmpty) {
      return 'Data structure is empty. Expected a non-empty map with pagination metadata.';
    }

    // Note: Invalid path configurations are handled gracefully during parsing
    // (_extractValue returns null for invalid paths), so we don't validate them here
    // This allows graceful degradation when paths are misconfigured

    // Note: We don't require pagination paths - if none are configured, we allow fallback to basic meta
    // This check is only for validation purposes, not a hard requirement

    // Note: Type checking is handled during parsing (using `is` checks)
    // We don't validate types here to allow graceful handling of wrong types
    // (they'll just be ignored and return null, which is the expected behavior)

    // Note: Pagination type determination is handled during parsing
    // Missing paths are OK - they'll just be null, allowing fallback to basic meta
    // The parsing logic will create a basic PageMeta with all nulls, which is valid

    // Structure is valid
    return null;
  }

  /// Generates a human-readable description of the expected data format.
  ///
  /// This is used in error messages to help users understand what structure
  /// is expected based on the current configuration.
  String _getExpectedFormatDescription() {
    final parts = <String>[];

    if (_config.itemsPath.isNotEmpty) {
      parts.add('items at "${_config.itemsPath}"');
    }

    if (_config.pagePath != null) {
      parts.add('page (int) at "${_config.pagePath}"');
    }
    if (_config.perPagePath != null) {
      parts.add('perPage (int) at "${_config.perPagePath}"');
    }
    if (_config.nextCursorPath != null) {
      parts.add('nextCursor (String) at "${_config.nextCursorPath}"');
    }
    if (_config.offsetPath != null) {
      parts.add('offset (int) at "${_config.offsetPath}"');
    }
    if (_config.limitPath != null) {
      parts.add('limit (int) at "${_config.limitPath}"');
    }
    if (_config.hasMorePath != null) {
      parts.add('hasMore (bool) at "${_config.hasMorePath}"');
    }

    if (parts.isEmpty) {
      return 'Expected pagination metadata structure';
    }

    return 'Expected: ${parts.join(", ")}';
  }

  /// Evicts the oldest cache entry if cache is at maximum size.
  ///
  /// Implements FIFO (First In First Out) eviction strategy to prevent
  /// unbounded memory growth. When the cache reaches the maximum size,
  /// the oldest entry (first inserted) is removed before adding a new one.
  // Note: Cache eviction is now handled automatically by _LRUCache
  // The LRU cache evicts least recently used items when at capacity

  /// Computes a robust hash for caching purposes
  ///
  /// Uses `Object.hash()` to create a more robust hash that includes the structure
  /// of relevant pagination fields. This reduces the likelihood of hash collisions
  /// compared to simple string concatenation.
  ///
  /// **Benefits:**
  /// - More robust than string concatenation hashing
  /// - Better collision resistance
  /// - Includes structure information in hash calculation
  /// - Uses Dart's built-in hash function which is well-optimized
  /// - Includes multiple pagination fields to reduce collision probability
  ///
  /// **Note:** While hash collisions are still theoretically possible, using
  /// `Object.hash()` with multiple fields significantly reduces the risk compared
  /// to string-based hashing or fewer fields.
  int _computeSimpleHash(Map<String, dynamic> data) {
    // Extract relevant pagination fields
    final pageValue = _extractValue(data, _config.pagePath);
    final perPageValue = _extractValue(data, _config.perPagePath);
    final totalValue = _extractValue(data, _config.totalPath);
    final hasMoreValue = _extractValue(data, _config.hasMorePath);
    final nextCursorValue = _extractValue(data, _config.nextCursorPath);
    final offsetValue = _extractValue(data, _config.offsetPath);
    final limitValue = _extractValue(data, _config.limitPath);

    // Use Object.hashAll() for more robust hashing
    // This combines multiple values into a single hash with better collision resistance
    // Including more fields and data length reduces the probability of hash collisions
    return Object.hashAll([
      pageValue,
      perPageValue,
      totalValue,
      hasMoreValue,
      nextCursorValue,
      offsetValue,
      limitValue,
      data.length, // Include structure size in hash
    ]);
  }

  /// Validates that cached metadata matches the current data structure
  ///
  /// This method performs a hash collision check by comparing the cached metadata
  /// with the actual values extracted from the current data structure.
  /// If they don't match, it indicates a hash collision and the cache entry is invalid.
  ///
  /// **Parameters:**
  /// - [cachedMeta] - The cached metadata to validate
  /// - [data] - The current data structure to compare against
  ///
  /// **Returns:**
  /// - `true` if cached metadata matches current data (no collision)
  /// - `false` if there's a mismatch (possible hash collision)
  bool _validateCachedMeta(PageMeta cachedMeta, Map<String, dynamic> data) {
    // Skip validation for small data structures (fast to re-parse)
    if (data.length < 10) return true; // Small structures are fast to re-parse

    // Only validate critical fields, not all fields
    if (cachedMeta.page != null) {
      final currentPage = _extractValue(data, _config.pagePath) as int?;
      if (currentPage != null && cachedMeta.page != currentPage) return false;
    }

    // Check hasMore as it's critical for pagination logic
    if (cachedMeta.hasMore != null) {
      final currentHasMore = _extractValue(data, _config.hasMorePath) as bool?;
      if (currentHasMore != null && cachedMeta.hasMore != currentHasMore) {
        return false;
      }
    }

    // Assume valid if critical fields match
    return true;
  }

  /// Clears the metadata and path caches
  /// Useful for memory management or when data structures change significantly
  void clearCache() {
    _metaCache.clear();
    _pathCache.clear();
  }

  @override
  List<Map<String, dynamic>> extractItems(Map<String, dynamic> data) {
    try {
      final items = _extractValue(data, _config.itemsPath);

      if (items is List) {
        // Validate that all items are Maps before casting
        if (items.every((item) => item is Map<String, dynamic>)) {
          return items.cast<Map<String, dynamic>>();
        } else {
          throw ErrorUtils.createParseError(
            message: 'Items path "${_config.itemsPath}" contains non-map items',
            expectedFormat: 'Expected a list of map objects',
            actualData: items,
          );
        }
      } else {
        throw ErrorUtils.createParseError(
          message: 'Items path "${_config.itemsPath}" does not contain a list',
          expectedFormat: 'Expected a list of items',
          actualData: items,
        );
      }
    } catch (e) {
      if (e is PaginationError) rethrow;
      throw ErrorUtils.createParseError(
        message: 'Failed to extract items: $e',
        expectedFormat: 'Expected items at path: ${_config.itemsPath}',
        actualData: data,
      );
    }
  }

  @override
  bool validateStructure(Map<String, dynamic> data) {
    try {
      // Check if items path exists
      final items = _extractValue(data, _config.itemsPath);
      if (items == null || items is! List) {
        return false;
      }

      // Check if at least one pagination field exists
      final hasPagination = _config.pagePath != null ||
          _config.nextCursorPath != null ||
          _config.offsetPath != null ||
          _config.hasMorePath != null;

      if (!hasPagination) return true; // Items-only is valid

      // Check if at least one pagination field has a value
      return _extractValue(data, _config.pagePath) != null ||
          _extractValue(data, _config.nextCursorPath) != null ||
          _extractValue(data, _config.offsetPath) != null ||
          _extractValue(data, _config.hasMorePath) != null;
    } catch (e) {
      return false;
    }
  }

  /// Validates that a path is well-formed
  bool _isValidPath(String? path) {
    if (path == null || path.isEmpty) return false;

    // Check for empty segments (e.g., "a..b" or ".a" or "a.")
    final segments = path.split('.');
    if (segments.any((segment) => segment.isEmpty)) {
      return false;
    }

    // Check for valid characters (alphanumeric, underscore, hyphen)
    for (final segment in segments) {
      if (segment.isEmpty || !RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(segment)) {
        return false;
      }
    }

    return true;
  }

  /// Extracts a value from nested data using dot notation.
  ///
  /// This method navigates through nested JSON structures using dot-separated paths
  /// (e.g., "meta.current_page", "data.items", "pagination.total").
  ///
  /// **Why `dynamic` return type?**
  ///
  /// The return type is `dynamic` because JSON parsing inherently produces dynamic values,
  /// and this method must handle multiple possible types:
  /// - `int?` - For numeric values (page numbers, counts, offsets, limits)
  /// - `String?` - For text values (cursors, identifiers)
  /// - `bool?` - For boolean flags (hasMore, hasNext)
  /// - `List?` - For arrays (items arrays)
  /// - `Map?` - For nested objects
  /// - `null` - When path doesn't exist or is invalid
  ///
  /// **Type Safety:**
  ///
  /// Callers are responsible for type checking after extraction. The parseMeta() method
  /// performs runtime type checks using `is` operators:
  ///
  /// ```dart
  /// final pageValue = _extractValue(data, _config.pagePath);
  /// final page = pageValue is int ? pageValue : null;  // Type-safe extraction
  /// ```
  ///
  /// **Performance:**
  ///
  /// Uses path segment caching to avoid repeated string splitting operations,
  /// improving performance for frequently accessed paths.
  ///
  /// **Parameters:**
  /// - [data] - The JSON data map to extract from
  /// - [path] - Dot-separated path (e.g., "meta.current_page") or null/empty to return null
  ///
  /// **Returns:**
  /// - The extracted value (type: `int?`, `String?`, `bool?`, `List?`, `Map?`, or `null`)
  /// - Returns `null` if:
  ///   - Path is null or empty
  ///   - Path format is invalid (contains empty segments or invalid characters)
  ///   - Path doesn't exist in the data structure
  ///   - Intermediate value in path is not a Map
  ///
  /// **Examples:**
  /// ```dart
  /// // Extract page number
  /// final page = _extractValue(data, 'meta.current_page');  // Returns int? or null
  ///
  /// // Extract cursor
  /// final cursor = _extractValue(data, 'meta.next_cursor');  // Returns String? or null
  ///
  /// // Extract items array
  /// final items = _extractValue(data, 'data.items');  // Returns List? or null
  /// ```
  ///
  /// **See also:**
  /// - [parseMeta] - Uses this method with type checking
  /// - [extractItems] - Uses this method to extract items arrays
  dynamic _extractValue(Map<String, dynamic> data, String? path) {
    if (path == null || path.isEmpty) return null;

    // Validate path format
    if (!_isValidPath(path)) {
      return null;
    }

    // Get or cache path segments (LRU cache automatically handles eviction)
    List<String> parts;
    final cachedParts = _pathCache.get(path);
    if (cachedParts != null) {
      parts = cachedParts;
    } else {
      parts = path.split('.');
      _pathCache.put(path, parts);
    }

    dynamic current = data;

    for (final part in parts) {
      if (current is Map<String, dynamic>) {
        current = current[part];
      } else {
        return null;
      }
    }

    return current;
  }
}
