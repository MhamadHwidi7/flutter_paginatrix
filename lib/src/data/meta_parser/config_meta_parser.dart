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

class ConfigMetaParser implements MetaParser {
  ConfigMetaParser(this._config);
  final MetaConfig _config;

  // Cache for parsed path segments to avoid repeated splitting
  final Map<String, List<String>> _pathCache = {};

  // Cache for parsed metadata to avoid re-parsing same data structures
  // Uses a simple hash of the data structure as key
  // Maintains insertion order for FIFO eviction
  final Map<int, PageMeta> _metaCache = {};

  @override
  PageMeta parseMeta(Map<String, dynamic> data) {
    try {
      // Try to get from cache first (simple hash-based caching)
      // Only cache if data structure is reasonably small to avoid memory issues
      final dataHash = _computeSimpleHash(data);
      if (_metaCache.containsKey(dataHash) &&
          data.length < PaginatrixCacheConstants.maxDataSizeForCaching) {
        return _metaCache[dataHash]!;
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

      // Determine pagination type and create appropriate PageMeta
      final PageMeta result;
      if (page != null && perPage != null) {
        result = PageMeta.pageBased(
          page: page,
          perPage: perPage,
          total: total,
          lastPage: lastPage,
          hasMore: hasMore ?? (lastPage != null ? page < lastPage : null),
        );
      } else if (nextCursor != null || hasMore != null) {
        result = PageMeta.cursorBased(
          nextCursor: nextCursor,
          previousCursor: previousCursor,
          hasMore: hasMore,
        );
      } else if (offset != null && limit != null) {
        result = PageMeta.offsetBased(
          offset: offset,
          limit: limit,
          total: total,
          hasMore: hasMore ?? (total != null ? offset + limit < total : null),
        );
      } else {
        // Fallback to basic meta
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

      // Cache the parsed metadata if data structure is reasonably small
      if (data.length < PaginatrixCacheConstants.maxDataSizeForCaching) {
        _evictCacheIfNeeded();
        _metaCache[dataHash] = result;
      }

      return result;
    } catch (e) {
      throw ErrorUtils.createParseError(
        message: 'Failed to parse pagination metadata: $e',
        expectedFormat: 'Expected paths: ${_config.toString()}',
        actualData: data,
      );
    }
  }

  /// Evicts the oldest cache entry if cache is at maximum size.
  ///
  /// Implements FIFO (First In First Out) eviction strategy to prevent
  /// unbounded memory growth. When the cache reaches the maximum size,
  /// the oldest entry (first inserted) is removed before adding a new one.
  ///
  /// This ensures the cache never exceeds [PaginatrixCacheConstants.maxMetaCacheSize] entries while
  /// maintaining reasonable performance for frequently accessed data.
  void _evictCacheIfNeeded() {
    if (_metaCache.length >= PaginatrixCacheConstants.maxMetaCacheSize) {
      // Remove the oldest entry (first key in insertion order)
      // Dart's Map maintains insertion order, so we can safely remove the first key
      final firstKey = _metaCache.keys.first;
      _metaCache.remove(firstKey);
    }
  }

  /// Computes a simple hash for caching purposes
  /// Uses a combination of relevant pagination fields
  int _computeSimpleHash(Map<String, dynamic> data) {
    final buffer = StringBuffer();

    // Include relevant pagination fields in hash
    final pageValue = _extractValue(data, _config.pagePath);
    final perPageValue = _extractValue(data, _config.perPagePath);
    final totalValue = _extractValue(data, _config.totalPath);
    final hasMoreValue = _extractValue(data, _config.hasMorePath);

    buffer.write('${pageValue ?? ''}_');
    buffer.write('${perPageValue ?? ''}_');
    buffer.write('${totalValue ?? ''}_');
    buffer.write('${hasMoreValue ?? ''}');

    return buffer.toString().hashCode;
  }

  /// Clears the metadata cache
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

  /// Extracts a value from nested data using dot notation
  /// Uses caching to avoid repeated path parsing
  dynamic _extractValue(Map<String, dynamic> data, String? path) {
    if (path == null || path.isEmpty) return null;

    // Validate path format
    if (!_isValidPath(path)) {
      return null;
    }

    // Get or cache path segments
    List<String> parts;
    if (_pathCache.containsKey(path)) {
      parts = _pathCache[path]!;
    } else {
      parts = path.split('.');
      _pathCache[path] = parts;
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
