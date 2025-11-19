import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_meta.freezed.dart';
part 'page_meta.g.dart';

/// Represents pagination metadata
@freezed
abstract class PageMeta with _$PageMeta {
  const factory PageMeta({
    /// Current page number (1-based)
    int? page,

    /// Number of items per page
    int? perPage,

    /// Total number of items
    int? total,

    /// Total number of pages
    int? lastPage,

    /// Whether there are more pages
    bool? hasMore,

    /// Next cursor for cursor-based pagination
    String? nextCursor,

    /// Previous cursor for cursor-based pagination
    String? previousCursor,

    /// Offset for offset/limit pagination
    int? offset,

    /// Limit for offset/limit pagination
    int? limit,
  }) = _PageMeta;

  factory PageMeta.fromJson(Map<String, dynamic> json) =>
      _$PageMetaFromJson(json);

  /// Creates a PageMeta for page-based pagination
  factory PageMeta.pageBased({
    required int page,
    required int perPage,
    int? total,
    int? lastPage,
    bool? hasMore,
  }) {
    return PageMeta(
      page: page,
      perPage: perPage,
      total: total,
      lastPage: lastPage,
      hasMore: hasMore,
    );
  }

  /// Creates a PageMeta for cursor-based pagination
  factory PageMeta.cursorBased({
    String? nextCursor,
    String? previousCursor,
    bool? hasMore,
  }) {
    return PageMeta(
      nextCursor: nextCursor,
      previousCursor: previousCursor,
      hasMore: hasMore,
    );
  }

  /// Creates a PageMeta for offset/limit pagination
  factory PageMeta.offsetBased({
    required int offset,
    required int limit,
    int? total,
    bool? hasMore,
  }) {
    return PageMeta(
      offset: offset,
      limit: limit,
      total: total,
      hasMore: hasMore,
    );
  }
}
