import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/contracts/meta_parser.dart';
import '../../core/entities/page_meta.dart';
import '../../core/entities/pagination_error.dart';

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

  @override
  PageMeta parseMeta(Map<String, dynamic> data) {
    try {
      final page = _extractValue(data, _config.pagePath) as int?;
      final perPage = _extractValue(data, _config.perPagePath) as int?;
      final total = _extractValue(data, _config.totalPath) as int?;
      final lastPage = _extractValue(data, _config.lastPagePath) as int?;
      final hasMore = _extractValue(data, _config.hasMorePath) as bool?;
      final nextCursor = _extractValue(data, _config.nextCursorPath) as String?;
      final previousCursor =
          _extractValue(data, _config.previousCursorPath) as String?;
      final offset = _extractValue(data, _config.offsetPath) as int?;
      final limit = _extractValue(data, _config.limitPath) as int?;

      // Determine pagination type and create appropriate PageMeta
      if (page != null && perPage != null) {
        return PageMeta.pageBased(
          page: page,
          perPage: perPage,
          total: total,
          lastPage: lastPage,
          hasMore: hasMore ?? (lastPage != null ? page < lastPage : null),
        );
      } else if (nextCursor != null || hasMore != null) {
        return PageMeta.cursorBased(
          nextCursor: nextCursor,
          previousCursor: previousCursor,
          hasMore: hasMore,
        );
      } else if (offset != null && limit != null) {
        return PageMeta.offsetBased(
          offset: offset,
          limit: limit,
          total: total,
          hasMore: hasMore ?? (total != null ? offset + limit < total : null),
        );
      } else {
        // Fallback to basic meta
        return PageMeta(
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
    } catch (e) {
      throw PaginationError.parse(
        message: 'Failed to parse pagination metadata: $e',
        expectedFormat: 'Expected paths: ${_config.toString()}',
        actualData: data.toString(),
      );
    }
  }

  @override
  List<Map<String, dynamic>> extractItems(Map<String, dynamic> data) {
    try {
      final items = _extractValue(data, _config.itemsPath);

      if (items is List) {
        return items.cast<Map<String, dynamic>>();
      } else {
        throw PaginationError.parse(
          message: 'Items path "${_config.itemsPath}" does not contain a list',
          expectedFormat: 'Expected a list of items',
          actualData: items.toString(),
        );
      }
    } catch (e) {
      if (e is PaginationError) rethrow;
      throw PaginationError.parse(
        message: 'Failed to extract items: $e',
        expectedFormat: 'Expected items at path: ${_config.itemsPath}',
        actualData: data.toString(),
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

  /// Extracts a value from nested data using dot notation
  dynamic _extractValue(Map<String, dynamic> data, String? path) {
    if (path == null || path.isEmpty) return null;

    final parts = path.split('.');
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
