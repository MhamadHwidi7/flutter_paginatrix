import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  // Common scroll properties
  ScrollPhysics? get physics;
  bool get shrinkWrap;
  Axis get scrollDirection;
  bool get reverse;
  EdgeInsetsGeometry? get padding;
  double? get cacheExtent;

  // Performance options
  bool get addAutomaticKeepAlives;
  bool get addRepaintBoundaries;
  bool get addSemanticIndexes;

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

  /// Callback when an error occurs during initial load
  ///
  /// This is called when the state transitions to error state.
  /// Use this to show toast notifications or handle errors.
  void Function(BuildContext context, PaginationError error)? get onError;

  /// Callback when an error occurs during append operation
  ///
  /// This is called when the state transitions to appendError state.
  /// Use this to show toast notifications or handle append errors.
  void Function(BuildContext context, PaginationError error)? get onAppendError;

  // Footer message
  String? get endOfListMessage;

  // Abstract getters/methods for specific implementations
  Widget Function(BuildContext context, int index)? get skeletonizerBuilder;
  int? get prefetchThreshold;

  /// Builds the main sliver for the content (SliverList or SliverGrid)
  Widget buildMainSliver(BuildContext context, PaginationState<T> state);

  /// Builds the loading sliver when using a custom skeletonizer builder
  Widget buildLoadingSliver(
      BuildContext context, Widget Function(BuildContext, int) builder);

  /// Builds the default skeletonizer when no custom builder is provided
  Widget buildDefaultSkeletonizer(BuildContext context);

  /// Build method that wraps content with BlocBuilder and BlocListener
  /// This eliminates duplication between ListView and GridView
  ///
  /// Uses `buildWhen` for fine-grained rebuild control, preventing unnecessary
  /// rebuilds when state changes don't affect the UI. Since PaginationState uses
  /// Freezed (which provides value equality), we can safely compare states.
  ///
  /// Uses BlocListener to detect error state changes and trigger callbacks (e.g., toast notifications).
  @override
  Widget build(BuildContext context) {
    return BlocListener<PaginatrixCubit<T>, PaginationState<T>>(
      bloc: cubit,
      listenWhen: (previous, current) {
        // Listen for error state changes to trigger callbacks
        final previousError = previous.error;
        final currentError = current.error;
        final previousAppendError = previous.appendError;
        final currentAppendError = current.appendError;

        // Trigger callback when error appears (was null, now has error)
        if (previousError == null && currentError != null) {
          return true;
        }

        // Trigger callback when append error appears (was null, now has error)
        if (previousAppendError == null && currentAppendError != null) {
          return true;
        }

        return false;
      },
      listener: (context, state) {
        // Handle initial load error
        final error = state.error;
        if (error != null) {
          final onErrorCallback = onError;
          if (onErrorCallback != null) {
            onErrorCallback(context, error);
          }
          // If no callback provided, errors are only shown via errorBuilder
          // This gives users full control over error notifications
        }

        // Handle append error
        final appendError = state.appendError;
        if (appendError != null) {
          final onAppendErrorCallback = onAppendError;
          if (onAppendErrorCallback != null) {
            onAppendErrorCallback(context, appendError);
          }
          // If no callback provided, errors are only shown via appendErrorBuilder
          // This gives users full control over error notifications
        }
      },
      child: BlocBuilder<PaginatrixCubit<T>, PaginationState<T>>(
        bloc: cubit,
        buildWhen: (previous, current) {
          // Only rebuild if status changed or items changed
          // This prevents unnecessary rebuilds when only query or other non-UI-affecting fields change
          if (previous.status != current.status) return true;
          if (previous.items.length != current.items.length) return true;
          if (previous.error != current.error) return true;
          if (previous.appendError != current.appendError) return true;
          // Don't rebuild for query changes if items haven't changed
          return false;
        },
        builder: buildContent,
      ),
    );
  }

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

  /// Builds loading state using abstract methods
  @protected
  Widget buildLoadingState(BuildContext context) {
    final builder = skeletonizerBuilder;
    if (builder != null) {
      return createCustomScrollView(
        slivers: [
          buildLoadingSliver(context, builder),
        ],
      );
    }

    return buildDefaultSkeletonizer(context);
  }

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
        onPullToRefresh?.call();
      },
      child: buildScrollableContent(context, state),
    );
  }

  /// Builds the main scrollable content
  @protected
  Widget buildScrollableContent(
      BuildContext context, PaginationState<T> state) {
    final hasMore = state.canLoadMore;
    final isAppending = state.isAppending;
    final hasAppendError = state.hasAppendError;

    return createScrollListener(
      prefetchThreshold: prefetchThreshold,
      reverse: reverse,
      child: createCustomScrollView(
        slivers: [
          buildMainSliver(context, state),
          // Use declarative state property instead of business logic
          // Footer display logic is now in PaginationStateExtension.shouldShowFooter
          if (state.shouldShowFooter)
            SliverToBoxAdapter(
              child: buildFooterItem(
                context,
                hasMore: hasMore,
                isAppending: isAppending,
                hasAppendError: hasAppendError,
                state: state,
              ),
            ),
        ],
      ),
    );
  }

  /// Builds empty state when no items exist
  @protected
  Widget buildEmptyState(BuildContext context) {
    final builder = emptyBuilder;
    if (builder != null) {
      return builder(context);
    }

    // Check if there's an active search query
    final query = cubit.state.query;
    final hasSearch = query?.hasSearchTerm ?? false;
    final searchTerm = query?.searchTerm ?? '';

    // Show search-specific empty view if there's a search term
    if (hasSearch && searchTerm.isNotEmpty) {
      return PaginatrixSearchEmptyView(
        query: searchTerm,
        onClearSearch: () {
          cubit.updateSearchTerm('');
        },
      );
    }

    return PaginatrixGenericEmptyView(
      onRefresh: onRetryInitial ?? cubit.loadFirstPage,
    );
  }

  /// Builds error state for initial load failure
  @protected
  Widget buildErrorState(BuildContext context, PaginationState<T> state) {
    final error = state.error;
    if (error == null) {
      // Fallback if error is null (shouldn't happen in error state, but safe guard)
      return PaginatrixGenericEmptyView(
        onRefresh: onRetryInitial ?? cubit.loadFirstPage,
      );
    }

    final builder = errorBuilder;
    if (builder != null) {
      return builder(context, error);
    }

    return PaginatrixErrorView(
      error: error,
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

  /// Builds footer item (append loader, error, or end of list message)
  @protected
  Widget buildFooterItem(
    BuildContext context, {
    required bool hasMore,
    required bool isAppending,
    required bool hasAppendError,
    required PaginationState<T> state,
  }) {
    // Don't show footer if there are no items and no more pages
    // This prevents showing loading indicator when search returns empty results
    if (!state.hasData && !hasMore) {
      return const SizedBox.shrink();
    }

    if (hasAppendError) {
      final appendError = state.appendError;
      if (appendError == null) {
        return const SizedBox.shrink();
      }

      final builder = appendErrorBuilder;
      if (builder != null) {
        return builder(context, appendError);
      }

      return PaginatrixAppendErrorView(
        error: appendError,
        onRetry: onRetryAppend ?? cubit.loadNextPage,
      );
    } else if (isAppending) {
      // Only show loading if there are items or more pages available
      if (!state.hasData && !hasMore) {
        return const SizedBox.shrink();
      }

      final builder = appendLoaderBuilder;
      if (builder != null) {
        return builder(context);
      }

      return const AppendLoader();
    } else if (!hasMore && state.hasData) {
      // Show "end of list" message when there's no more data but we have items
      final message = endOfListMessage ?? 'No more items to load';
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      );
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

  /// Creates a CustomScrollView with common properties
  /// This reduces duplication in buildLoadingState and buildScrollableContent
  ///
  /// **Padding Behavior:**
  /// When padding is provided, the entire scroll view is wrapped in a Padding widget.
  /// This ensures consistent padding around all slivers together, rather than
  /// applying padding to each sliver individually (which would create gaps between slivers).
  @protected
  Widget createCustomScrollView({
    required List<Widget> slivers,
  }) {
    final paddingValue = padding; // Store once to avoid redundant null check

    final scrollView = CustomScrollView(
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      reverse: reverse,
      cacheExtent: cacheExtent,
      slivers: slivers,
    );

    // Wrap the entire scroll view in padding if provided
    // This ensures padding is applied around all content, not between slivers
    if (paddingValue != null) {
      return Padding(
        padding: paddingValue,
        child: scrollView,
      );
    }

    return scrollView;
  }

  /// Creates a SliverChildBuilderDelegate with common performance options
  @protected
  SliverChildBuilderDelegate createSliverDelegate({
    required Widget Function(BuildContext, int) builder,
    required int childCount,
  }) {
    return SliverChildBuilderDelegate(
      builder,
      childCount: childCount,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
    );
  }
}

/// Helper function to validate and initialize cubit/controller
/// This eliminates duplication in constructor assertions
PaginatrixCubit<T> validateAndInitializeCubit<T>({
  PaginatrixCubit<T>? cubit,
  PaginatrixController<T>? controller,
  Axis scrollDirection = Axis.vertical,
}) {
  assert(
    cubit != null || controller != null,
    'Either cubit or controller must be provided',
  );
  assert(
    scrollDirection == Axis.vertical || scrollDirection == Axis.horizontal,
    'scrollDirection must be either Axis.vertical or Axis.horizontal',
  );
  // At least one must be non-null due to assertion above
  return cubit ??
      (controller ??
          (throw StateError('Either cubit or controller must be provided')));
}
