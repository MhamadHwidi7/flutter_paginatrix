import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

/// Mixin that provides shared pagination state building logic
/// for PaginatrixListView and PaginatrixGridView.
///
/// This mixin eliminates code duplication by extracting common
/// UI logic for handling different pagination states.
///
/// ## Design Pattern
///
/// Uses the **Mixin Pattern** which is Flutter's preferred way
/// to share behavior between widgets without inheritance complexity.
///
/// ## Usage
///
/// ```dart
/// class PaginatrixListView<T> extends StatelessWidget
///     with PaginatrixStateBuilderMixin<T> {
///   // Implementation
/// }
/// ```
mixin PaginatrixStateBuilderMixin<T> on StatelessWidget {
  // Abstract getters that must be implemented by the widget
  PaginatrixCubit<T> get cubit;

  // Common callbacks
  Widget Function(BuildContext context)? get emptyBuilder;
  Widget Function(BuildContext context, PaginationError error)?
      get errorBuilder;
  Widget Function(BuildContext context, PaginationError error)?
      get appendErrorBuilder;
  Widget Function(BuildContext context)? get appendLoaderBuilder;
  VoidCallback? get onPullToRefresh;
  VoidCallback? get onRetryInitial;
  VoidCallback? get onRetryAppend;

  // Abstract method that must be implemented by each widget
  // (ListView and GridView have different implementations)
  Widget buildScrollableContent(BuildContext context, PaginationState<T> state);

  /// Routes state to appropriate builder method
  Widget buildContent(BuildContext context, PaginationState<T> state) {
    return state.status.when(
      initial: () => buildInitialState(context),
      loading: () => buildLoadingState(context),
      success: () => buildSuccessState(context, state),
      empty: () => buildEmptyState(context),
      refreshing: () => buildRefreshingState(context, state),
      appending: () => buildAppendingState(context, state),
      error: () => buildErrorState(context, state),
      appendError: () => buildAppendErrorState(context, state),
    );
  }

  /// Builds initial state - delegates to loading state
  @protected
  Widget buildInitialState(BuildContext context) {
    return buildLoadingState(context);
  }

  /// Builds loading state - must be implemented by subclass
  /// (ListView and GridView have different shimmer implementations)
  @protected
  Widget buildLoadingState(BuildContext context);

  /// Builds success state - shows data with refresh capability
  @protected
  Widget buildSuccessState(BuildContext context, PaginationState<T> state) {
    return buildRefreshableContent(context, state);
  }

  /// Builds refreshing state - shows data while refreshing
  @protected
  Widget buildRefreshingState(BuildContext context, PaginationState<T> state) {
    return buildRefreshableContent(context, state);
  }

  /// Builds appending state - shows data while loading more
  @protected
  Widget buildAppendingState(BuildContext context, PaginationState<T> state) {
    return buildRefreshableContent(context, state);
  }

  /// Builds content with pull-to-refresh capability
  @protected
  Widget buildRefreshableContent(
    BuildContext context,
    PaginationState<T> state,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        cubit.refresh();
        if (onPullToRefresh != null) {
          onPullToRefresh!();
        }
      },
      child: buildScrollableContent(context, state),
    );
  }

  /// Builds empty state when no items exist
  @protected
  Widget buildEmptyState(BuildContext context) {
    if (emptyBuilder != null) {
      return emptyBuilder!(context);
    }

    return GenericEmptyView(
      onRefresh: onRetryInitial ?? cubit.loadFirstPage,
    );
  }

  /// Builds error state for initial load failure
  @protected
  Widget buildErrorState(BuildContext context, PaginationState<T> state) {
    if (errorBuilder != null) {
      return errorBuilder!(context, state.error!);
    }

    return PaginationErrorView(
      error: state.error!,
      onRetry: onRetryInitial ?? cubit.loadFirstPage,
    );
  }

  /// Builds append error state - shows existing data with error footer
  @protected
  Widget buildAppendErrorState(
    BuildContext context,
    PaginationState<T> state,
  ) {
    return buildScrollableContent(context, state);
  }

  /// Builds footer item (append loader or error)
  @protected
  Widget buildFooterItem(
    BuildContext context, {
    required bool hasMore,
    required bool isAppending,
    required bool hasAppendError,
    required PaginationState<T> state,
  }) {
    if (hasAppendError) {
      if (appendErrorBuilder != null) {
        return appendErrorBuilder!(context, state.appendError!);
      }

      return AppendErrorView(
        error: state.appendError!,
        onRetry: onRetryAppend ?? cubit.loadNextPage,
      );
    } else if (isAppending) {
      if (appendLoaderBuilder != null) {
        return appendLoaderBuilder!(context);
      }

      return const AppendLoader();
    }

    return const SizedBox.shrink();
  }

  /// Builds a single item with key and repaint boundary
  @protected
  Widget buildItem(
    BuildContext context,
    T item,
    int index,
    Widget Function(BuildContext context, T item, int index) itemBuilder,
    String Function(T item, int index)? keyBuilder,
  ) {
    final key = keyBuilder != null ? keyBuilder(item, index) : null;

    return RepaintBoundary(
      child: KeyedSubtree(
        key: key != null ? ValueKey(key) : null,
        child: itemBuilder(context, item, index),
      ),
    );
  }

  /// Creates scroll notification listener for pagination
  @protected
  NotificationListener<ScrollNotification> createScrollListener({
    required Widget child,
    required int? prefetchThreshold,
    required bool reverse,
  }) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification ||
            notification is ScrollEndNotification) {
          cubit.checkAndLoadIfNearEnd(
            metrics: notification.metrics,
            prefetchThreshold: prefetchThreshold,
            reverse: reverse,
          );
        }
        return false;
      },
      child: child,
    );
  }
}
