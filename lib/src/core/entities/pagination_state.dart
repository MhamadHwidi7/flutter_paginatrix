import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_paginatrix/src/core/entities/page_meta.dart';
import 'package:flutter_paginatrix/src/core/entities/pagination_error.dart';
import 'package:flutter_paginatrix/src/core/entities/pagination_status.dart';
import 'package:flutter_paginatrix/src/core/entities/request_context.dart';

part 'pagination_state.freezed.dart';

/// Represents the complete state of pagination
@freezed
class PaginationState<T> with _$PaginationState<T> {
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
  }) = _PaginationState<T>;

  /// Creates initial state
  factory PaginationState.initial() {
    return const PaginationState(
      status: PaginationStatus.initial(),
    );
  }

  /// Creates loading state
  factory PaginationState.loading({
    required RequestContext requestContext,
    List<T>? previousItems,
    PageMeta? previousMeta,
  }) {
    return PaginationState(
      status: const PaginationStatus.loading(),
      items: previousItems ?? [],
      meta: previousMeta,
      requestContext: requestContext,
    );
  }

  /// Creates success state
  factory PaginationState.success({
    required List<T> items,
    required PageMeta meta,
    required RequestContext requestContext,
  }) {
    return PaginationState(
      status: const PaginationStatus.success(),
      items: items,
      meta: meta,
      requestContext: requestContext,
      lastLoadedAt: DateTime.now(),
    );
  }

  /// Creates empty state
  factory PaginationState.empty({
    required RequestContext requestContext,
  }) {
    return PaginationState(
      status: const PaginationStatus.empty(),
      items: [],
      requestContext: requestContext,
      lastLoadedAt: DateTime.now(),
    );
  }

  /// Creates error state
  factory PaginationState.error({
    required PaginationError error,
    required RequestContext requestContext,
    List<T>? previousItems,
    PageMeta? previousMeta,
  }) {
    return PaginationState(
      status: const PaginationStatus.error(),
      items: previousItems ?? [],
      meta: previousMeta,
      error: error,
      requestContext: requestContext,
    );
  }

  /// Creates refreshing state
  factory PaginationState.refreshing({
    required RequestContext requestContext,
    required List<T> currentItems,
    required PageMeta currentMeta,
  }) {
    return PaginationState(
      status: const PaginationStatus.refreshing(),
      items: currentItems,
      meta: currentMeta,
      requestContext: requestContext,
    );
  }

  /// Creates appending state
  factory PaginationState.appending({
    required RequestContext requestContext,
    required List<T> currentItems,
    required PageMeta currentMeta,
  }) {
    return PaginationState(
      status: const PaginationStatus.appending(),
      items: currentItems,
      meta: currentMeta,
      requestContext: requestContext,
    );
  }

  /// Creates append error state
  factory PaginationState.appendError({
    required PaginationError appendError,
    required RequestContext requestContext,
    required List<T> currentItems,
    required PageMeta currentMeta,
  }) {
    return PaginationState(
      status: const PaginationStatus.appendError(),
      items: currentItems,
      meta: currentMeta,
      appendError: appendError,
      requestContext: requestContext,
    );
  }
}
