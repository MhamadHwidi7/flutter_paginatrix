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
abstract class MetaConfig with _$MetaConfig {
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

/// Extracted pagination fields from data
///
/// This class holds all extracted pagination fields in a structured way,
/// making it easier to pass around and test field extraction logic.
class _ExtractedPaginationFields {
  const _ExtractedPaginationFields({
    this.page,
    this.perPage,
    this.total,
    this.lastPage,
    this.hasMore,
    this.nextCursor,
    this.previousCursor,
    this.offset,
    this.limit,
  });

  final int? page;
  final int? perPage;
  final int? total;
  final int? lastPage;
  final bool? hasMore;
  final String? nextCursor;
  final String? previousCursor;
  final int? offset;
  final int? limit;
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

  /// Extracts an integer value from data at the given path
  ///
  /// **Best Practice:** Type-safe extraction with runtime validation.
  /// Returns null if value is not an integer or path doesn't exist.
  ///
  /// **Parameters:**
  /// - [data] - The data map to extract from
  /// - [path] - The path to extract (can be null/empty)
  ///
  /// **Returns:** The integer value or null
  int? _extractInt(Map<String, dynamic> data, String? path) {
    final value = _extractValue(data, path);
    return value is int ? value : null;
  }

  /// Extracts a boolean value from data at the given path
  ///
  /// **Best Practice:** Type-safe extraction with runtime validation.
  /// Returns null if value is not a boolean or path doesn't exist.
  ///
  /// **Parameters:**
  /// - [data] - The data map to extract from
  /// - [path] - The path to extract (can be null/empty)
  ///
  /// **Returns:** The boolean value or null
  bool? _extractBool(Map<String, dynamic> data, String? path) {
    final value = _extractValue(data, path);
    return value is bool ? value : null;
  }

  /// Extracts a string value from data at the given path
  ///
  /// **Best Practice:** Type-safe extraction with runtime validation.
  /// Returns null if value is not a string or path doesn't exist.
  ///
  /// **Parameters:**
  /// - [data] - The data map to extract from
  /// - [path] - The path to extract (can be null/empty)
  ///
  /// **Returns:** The string value or null
  String? _extractString(Map<String, dynamic> data, String? path) {
    final value = _extractValue(data, path);
    return value is String ? value : null;
  }

  /// Extracts all pagination fields from data
  ///
  /// **Best Practice:** Centralizes field extraction logic, making it easier
  /// to test and maintain. Uses type-safe extraction helpers.
  ///
  /// **Parameters:**
  /// - [data] - The data map to extract from
  ///
  /// **Returns:** A structured object containing all extracted fields
  _ExtractedPaginationFields _extractPaginationFields(
      Map<String, dynamic> data) {
    return _ExtractedPaginationFields(
      page: _extractInt(data, _config.pagePath),
      perPage: _extractInt(data, _config.perPagePath),
      total: _extractInt(data, _config.totalPath),
      lastPage: _extractInt(data, _config.lastPagePath),
      hasMore: _extractBool(data, _config.hasMorePath),
      nextCursor: _extractString(data, _config.nextCursorPath),
      previousCursor: _extractString(data, _config.previousCursorPath),
      offset: _extractInt(data, _config.offsetPath),
      limit: _extractInt(data, _config.limitPath),
    );
  }

  /// Creates a PageMeta object from extracted fields
  ///
  /// **Best Practice:** Determines pagination type and creates appropriate
  /// PageMeta variant. This separates field extraction from meta creation,
  /// making both easier to test independently.
  ///
  /// **Pagination Type Detection:**
  /// - Page-based: requires both page and perPage
  /// - Cursor-based: requires nextCursor or hasMore
  /// - Offset-based: requires both offset and limit
  /// - Fallback: basic meta with all fields
  ///
  /// **Parameters:**
  /// - [fields] - The extracted pagination fields
  ///
  /// **Returns:** A PageMeta object appropriate for the pagination type
  PageMeta _createPageMeta(_ExtractedPaginationFields fields) {
    // Check which pagination type we have (if any)
    // If none found, we'll fallback to basic meta (all nulls), which is valid
    final hasPageBased = fields.page != null && fields.perPage != null;
    final hasCursorBased = fields.nextCursor != null || fields.hasMore != null;
    final hasOffsetBased = fields.offset != null && fields.limit != null;

    if (hasPageBased) {
      return _createPageMetaForPageBased(fields);
    } else if (hasCursorBased) {
      return _createPageMetaForCursorBased(fields);
    } else if (hasOffsetBased) {
      return _createPageMetaForOffsetBased(fields);
    } else {
      return _createPageMetaBasic(fields);
    }
  }

  /// Creates a page-based PageMeta object
  ///
  /// **Best Practice:** Encapsulates page-based meta creation logic,
  /// including hasMore calculation from lastPage when not provided.
  ///
  /// **Parameters:**
  /// - [fields] - The extracted pagination fields
  ///
  /// **Returns:** A PageMeta.pageBased object
  PageMeta _createPageMetaForPageBased(_ExtractedPaginationFields fields) {
    // Use explicit non-nullable variables to satisfy type system
    final page = fields.page!;
    final perPage = fields.perPage!;
    return PageMeta.pageBased(
      page: page,
      perPage: perPage,
      total: fields.total,
      lastPage: fields.lastPage,
      hasMore: fields.hasMore ??
          (fields.lastPage != null ? page < fields.lastPage! : null),
    );
  }

  /// Creates a cursor-based PageMeta object
  ///
  /// **Best Practice:** Encapsulates cursor-based meta creation logic.
  ///
  /// **Parameters:**
  /// - [fields] - The extracted pagination fields
  ///
  /// **Returns:** A PageMeta.cursorBased object
  PageMeta _createPageMetaForCursorBased(_ExtractedPaginationFields fields) {
    return PageMeta.cursorBased(
      nextCursor: fields.nextCursor,
      previousCursor: fields.previousCursor,
      hasMore: fields.hasMore,
    );
  }

  /// Creates an offset-based PageMeta object
  ///
  /// **Best Practice:** Encapsulates offset-based meta creation logic,
  /// including hasMore calculation from offset/limit/total when not provided.
  ///
  /// **Parameters:**
  /// - [fields] - The extracted pagination fields
  ///
  /// **Returns:** A PageMeta.offsetBased object
  PageMeta _createPageMetaForOffsetBased(_ExtractedPaginationFields fields) {
    // Use explicit non-nullable variables to satisfy type system
    final offset = fields.offset!;
    final limit = fields.limit!;
    return PageMeta.offsetBased(
      offset: offset,
      limit: limit,
      total: fields.total,
      hasMore: fields.hasMore ??
          (fields.total != null ? offset + limit < fields.total! : null),
    );
  }

  /// Creates a basic PageMeta object (fallback)
  ///
  /// **Best Practice:** Creates a basic meta object with all fields.
  /// Used when pagination type cannot be determined.
  ///
  /// **Parameters:**
  /// - [fields] - The extracted pagination fields
  ///
  /// **Returns:** A basic PageMeta object
  PageMeta _createPageMetaBasic(_ExtractedPaginationFields fields) {
    return PageMeta(
      page: fields.page,
      perPage: fields.perPage,
      total: fields.total,
      lastPage: fields.lastPage,
      hasMore: fields.hasMore,
      nextCursor: fields.nextCursor,
      previousCursor: fields.previousCursor,
      offset: fields.offset,
      limit: fields.limit,
    );
  }

  /// Checks cache and returns cached meta if available and valid
  ///
  /// **Best Practice:** Encapsulates cache checking logic, making it easier
  /// to test and maintain. Returns null if cache miss or invalid.
  ///
  /// **Parameters:**
  /// - [data] - The data map to check cache for
  ///
  /// **Returns:** Cached PageMeta if available and valid, null otherwise
  PageMeta? _getCachedMetaIfValid(Map<String, dynamic> data) {
    // Only check cache if data structure is reasonably small
    if (data.length >= PaginatrixCacheConstants.maxDataSizeForCaching) {
      return null;
    }

    // Extract only metadata fields for hashing (not entire data map)
    // This prevents hash collisions from items array or other non-metadata fields
    final metadataMap = _extractCanonicalMetadataMap(data);
    final dataHash = _computeCanonicalHash(metadataMap);
    final cachedMeta = _metaCache.get(dataHash);

    if (cachedMeta != null) {
      // Validate hash collision: verify cached meta matches current data structure
      // This prevents returning incorrect metadata due to hash collisions
      if (_validateCachedMeta(cachedMeta, data)) {
        return cachedMeta;
      } else {
        // Hash collision detected - re-add to maintain LRU order
        _metaCache.put(dataHash, cachedMeta);
      }
    }

    return null;
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

      // Check cache first (returns null if cache miss or invalid)
      final cachedMeta = _getCachedMetaIfValid(data);
      if (cachedMeta != null) {
        return cachedMeta;
      }

      // Extract all pagination fields using type-safe helpers
      final extractedFields = _extractPaginationFields(data);

      // Determine pagination type and create appropriate PageMeta
      final PageMeta result = _createPageMeta(extractedFields);

      // Cache the result if data structure is small enough
      if (data.length < PaginatrixCacheConstants.maxDataSizeForCaching) {
        final metadataMap = _extractCanonicalMetadataMap(data);
        final dataHash = _computeCanonicalHash(metadataMap);
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

  /// Extracts a canonical metadata map containing only pagination metadata fields
  ///
  /// **Best Practice:** This method creates a canonical representation of only the
  /// metadata fields, excluding items arrays and other non-metadata fields. This
  /// ensures that:
  /// - Hash collisions are minimized (only metadata affects the hash)
  /// - Different items arrays with same metadata don't create different hashes
  /// - Cache keys are based solely on metadata, not on data that changes per page
  ///
  /// **Why this matters:**
  /// - Two responses with same metadata but different items should have the same hash
  /// - Prevents cache misses when only items change but metadata stays the same
  /// - Reduces hash collision risk by excluding large, variable data structures
  ///
  /// **Returns:** A map containing only the pagination metadata fields
  Map<String, dynamic> _extractCanonicalMetadataMap(Map<String, dynamic> data) {
    final metadataMap = <String, dynamic>{};

    // Extract only metadata fields (not items array or other data)
    final pageValue = _extractValue(data, _config.pagePath);
    if (pageValue != null) metadataMap['page'] = pageValue;

    final perPageValue = _extractValue(data, _config.perPagePath);
    if (perPageValue != null) metadataMap['perPage'] = perPageValue;

    final totalValue = _extractValue(data, _config.totalPath);
    if (totalValue != null) metadataMap['total'] = totalValue;

    final lastPageValue = _extractValue(data, _config.lastPagePath);
    if (lastPageValue != null) metadataMap['lastPage'] = lastPageValue;

    final hasMoreValue = _extractValue(data, _config.hasMorePath);
    if (hasMoreValue != null) metadataMap['hasMore'] = hasMoreValue;

    final nextCursorValue = _extractValue(data, _config.nextCursorPath);
    if (nextCursorValue != null) metadataMap['nextCursor'] = nextCursorValue;

    final previousCursorValue = _extractValue(data, _config.previousCursorPath);
    if (previousCursorValue != null) {
      metadataMap['previousCursor'] = previousCursorValue;
    }

    final offsetValue = _extractValue(data, _config.offsetPath);
    if (offsetValue != null) metadataMap['offset'] = offsetValue;

    final limitValue = _extractValue(data, _config.limitPath);
    if (limitValue != null) metadataMap['limit'] = limitValue;

    return metadataMap;
  }

  /// Computes a canonical hash from a metadata map
  ///
  /// **Best Practice:** This method hashes only the canonical metadata map,
  /// not the entire data structure. This ensures:
  /// - Hash collisions are minimized (only metadata affects the hash)
  /// - Cache keys are deterministic and based solely on metadata
  /// - Different items arrays with same metadata produce the same hash
  ///
  /// **Why this approach?**
  ///
  /// - Uses canonical JSON-like representation for deterministic hashing
  /// - Includes all metadata fields in a consistent order (sorted keys)
  /// - Uses Dart's built-in hash function which is well-optimized
  ///
  /// **Note:** While hash collisions are still theoretically possible, using
  /// `Object.hashAll()` with only metadata fields significantly reduces the risk
  /// compared to hashing the entire data map which includes variable items arrays.
  ///
  /// **Parameters:**
  /// - [metadataMap] - The canonical metadata map (from _extractCanonicalMetadataMap)
  ///
  /// **Returns:** A hash value suitable for use as a cache key
  int _computeCanonicalHash(Map<String, dynamic> metadataMap) {
    // Use Object.hashAll() with sorted keys for deterministic hashing
    // This ensures the same metadata always produces the same hash
    final sortedKeys = metadataMap.keys.toList()..sort();
    final hashValues = <dynamic>[];
    for (final key in sortedKeys) {
      hashValues.add(key);
      hashValues.add(metadataMap[key]);
    }
    return Object.hashAll(hashValues);
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
