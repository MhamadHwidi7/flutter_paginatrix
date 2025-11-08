import 'package:freezed_annotation/freezed_annotation.dart';

import 'page_meta.dart';
import 'pagination_error.dart';
import 'pagination_status.dart';
import 'request_context.dart';

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

extension PaginationStateExtension<T> on PaginationState<T> {
  /// Whether the state has data
  bool get hasData => items.isNotEmpty;

  /// Whether the state is loading
  bool get isLoading => status.maybeWhen(
        loading: () => true,
        refreshing: () => true,
        appending: () => true,
        orElse: () => false,
      );

  /// Whether the state has an error
  bool get hasError => error != null;

  /// Whether the state has an append error
  bool get hasAppendError => appendError != null;

  /// Whether more data can be loaded
  bool get canLoadMore {
    if (meta == null) return false;
    return meta!.hasMore ?? false;
  }

  /// Whether the state is in a stable state (not loading)
  bool get isStable => !isLoading;

  /// Whether the state is in an error state
  bool get isError => status.maybeWhen(
        error: () => true,
        orElse: () => false,
      );

  /// Whether the state is empty
  bool get isEmpty => status.maybeWhen(
        empty: () => true,
        orElse: () => false,
      );

  /// Whether the state is successful
  bool get isSuccess => status.maybeWhen(
        success: () => true,
        orElse: () => false,
      );
}
