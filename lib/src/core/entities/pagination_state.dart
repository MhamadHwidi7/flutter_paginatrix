import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_paginatrix/src/core/entities/page_meta.dart';
import 'package:flutter_paginatrix/src/core/entities/pagination_error.dart';
import 'package:flutter_paginatrix/src/core/entities/pagination_status.dart';
import 'package:flutter_paginatrix/src/core/entities/request_context.dart';
import 'package:flutter_paginatrix/src/core/entities/query_criteria.dart';

part 'pagination_state.freezed.dart';

/// Represents the complete state of pagination
@freezed
abstract class PaginationState<T> with _$PaginationState<T> {
  const factory PaginationState({
    /// Current pagination status
    required PaginationStatus status,

    /// List of loaded items
    @Default([]) List<T> items,

    /// Current pagination metadata
    PageMeta? meta,

    /// Current error (if any)
    PaginationError? error,

    /// Append error (non-blocking)
    PaginationError? appendError,

    /// Current request context
    RequestContext? requestContext,

    /// Whether data is stale and needs refresh
    @Default(false) bool isStale,

    /// Last successful load timestamp
    DateTime? lastLoadedAt,

    /// Current search and filter criteria
    /// Defaults to empty criteria (no search, filters, or sorting)
    QueryCriteria? query,
  }) = _PaginationState<T>;

  /// Creates initial state
  factory PaginationState.initial() {
    return const PaginationState(
      status: PaginationStatus.initial(),
      query: QueryCriteria(),
    );
  }

  /// Creates loading state
  factory PaginationState.loading({
    required RequestContext requestContext,
    List<T>? previousItems,
    PageMeta? previousMeta,
    QueryCriteria? query,
  }) {
    return PaginationState(
      status: const PaginationStatus.loading(),
      items: previousItems ?? const [],
      meta: previousMeta,
      requestContext: requestContext,
      query: query ?? const QueryCriteria(),
    );
  }

  /// Creates success state
  factory PaginationState.success({
    required List<T> items,
    required PageMeta meta,
    required RequestContext requestContext,
    QueryCriteria? query,
  }) {
    return PaginationState(
      status: const PaginationStatus.success(),
      items: items,
      meta: meta,
      requestContext: requestContext,
      lastLoadedAt: DateTime.now(),
      query: query ?? const QueryCriteria(),
    );
  }

  /// Creates empty state
  factory PaginationState.empty({
    required RequestContext requestContext,
    QueryCriteria? query,
  }) {
    return PaginationState(
      status: const PaginationStatus.empty(),
      requestContext: requestContext,
      lastLoadedAt: DateTime.now(),
      query: query ?? const QueryCriteria(),
    );
  }

  /// Creates error state
  factory PaginationState.error({
    required PaginationError error,
    required RequestContext requestContext,
    List<T>? previousItems,
    PageMeta? previousMeta,
    QueryCriteria? query,
  }) {
    return PaginationState(
      status: const PaginationStatus.error(),
      items: previousItems ?? const [],
      meta: previousMeta,
      error: error,
      requestContext: requestContext,
      query: query ?? const QueryCriteria(),
    );
  }

  /// Creates refreshing state
  factory PaginationState.refreshing({
    required RequestContext requestContext,
    required List<T> currentItems,
    required PageMeta currentMeta,
    QueryCriteria? query,
  }) {
    return PaginationState(
      status: const PaginationStatus.refreshing(),
      items: currentItems,
      meta: currentMeta,
      requestContext: requestContext,
      query: query ?? const QueryCriteria(),
    );
  }

  /// Creates appending state
  factory PaginationState.appending({
    required RequestContext requestContext,
    required List<T> currentItems,
    required PageMeta currentMeta,
    QueryCriteria? query,
  }) {
    return PaginationState(
      status: const PaginationStatus.appending(),
      items: currentItems,
      meta: currentMeta,
      requestContext: requestContext,
      query: query ?? const QueryCriteria(),
    );
  }

  /// Creates append error state
  factory PaginationState.appendError({
    required PaginationError appendError,
    required RequestContext requestContext,
    required List<T> currentItems,
    required PageMeta currentMeta,
    QueryCriteria? query,
  }) {
    return PaginationState(
      status: const PaginationStatus.appendError(),
      items: currentItems,
      meta: currentMeta,
      appendError: appendError,
      requestContext: requestContext,
      query: query ?? const QueryCriteria(),
    );
  }
}
