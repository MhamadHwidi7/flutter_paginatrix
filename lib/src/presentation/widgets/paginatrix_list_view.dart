import 'package:flutter/material.dart';

import '../../core/entities/pagination_error.dart';
import '../../core/entities/pagination_state.dart';
import '../../presentation/controllers/paginated_controller.dart';
import 'append_loader.dart';
import 'pagination_empty_view.dart';
import 'pagination_error_view.dart';
import 'pagination_shimmer.dart';

/// ListView adapter for Paginatrix
class PaginatrixListView<T> extends StatelessWidget {
  const PaginatrixListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.keyBuilder,
    this.prefetchThreshold,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.separatorBuilder,
    this.shimmerBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.appendErrorBuilder,
    this.appendLoaderBuilder,
    this.onPullToRefresh,
    this.onRetryInitial,
    this.onRetryAppend,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
  });
  final PaginatedController<T> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String Function(T item, int index)? keyBuilder;
  final int? prefetchThreshold;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget Function(BuildContext context, int index)? shimmerBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context, PaginationError error)?
      errorBuilder;
  final Widget Function(BuildContext context, PaginationError error)?
      appendErrorBuilder;
  final Widget Function(BuildContext context)? appendLoaderBuilder;
  final VoidCallback? onPullToRefresh;
  final VoidCallback? onRetryInitial;
  final VoidCallback? onRetryAppend;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PaginationState<T>>(
      stream: controller.stream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? controller.state;

        return _buildContent(context, state);
      },
    );
  }

  Widget _buildContent(BuildContext context, PaginationState<T> state) {
    return state.status.when(
      initial: () => _buildInitialState(context),
      loading: () => _buildLoadingState(context),
      success: () => _buildSuccessState(context, state),
      empty: () => _buildEmptyState(context),
      refreshing: () => _buildRefreshingState(context, state),
      appending: () => _buildAppendingState(context, state),
      error: () => _buildErrorState(context, state),
      appendError: () => _buildAppendErrorState(context, state),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return _buildLoadingState(context);
  }

  Widget _buildLoadingState(BuildContext context) {
    if (shimmerBuilder != null) {
      return CustomScrollView(
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        reverse: reverse,
        cacheExtent: cacheExtent,
        slivers: [
          if (padding != null) SliverPadding(padding: padding!),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              shimmerBuilder!,
              childCount: 10,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
            ),
          ),
        ],
      );
    }

    // Use PaginationShimmer which handles its own CustomScrollView
    return PaginationShimmer(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      reverse: reverse,
    );
  }

  Widget _buildSuccessState(BuildContext context, PaginationState<T> state) {
    return _buildRefreshableContent(context, state);
  }

  Widget _buildRefreshingState(BuildContext context, PaginationState<T> state) {
    return _buildRefreshableContent(context, state);
  }

  Widget _buildRefreshableContent(BuildContext context, PaginationState<T> state) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.refresh();
        if (onPullToRefresh != null) {
          onPullToRefresh!();
        }
      },
      child: _buildListWithItems(context, state),
    );
  }

  Widget _buildAppendingState(BuildContext context, PaginationState<T> state) {
    return _buildRefreshableContent(context, state);
  }

  Widget _buildEmptyState(BuildContext context) {
    if (emptyBuilder != null) {
      return emptyBuilder!(context);
    }

    return GenericEmptyView(
      onRefresh: onRetryInitial ?? controller.loadFirstPage,
    );
  }

  Widget _buildErrorState(BuildContext context, PaginationState<T> state) {
    if (errorBuilder != null) {
      return errorBuilder!(context, state.error!);
    }

    return PaginationErrorView(
      error: state.error!,
      onRetry: onRetryInitial ?? controller.loadFirstPage,
    );
  }

  Widget _buildAppendErrorState(
      BuildContext context, PaginationState<T> state) {
    return _buildListWithItems(context, state);
  }

  Widget _buildListWithItems(BuildContext context, PaginationState<T> state) {
    final items = state.items;
    final itemCount = items.length;
    final hasMore = state.canLoadMore;
    final isAppending = state.status.maybeWhen(
      appending: () => true,
      orElse: () => false,
    );
    final hasAppendError = state.hasAppendError;
    final hasSeparator = separatorBuilder != null;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification ||
            notification is ScrollEndNotification) {
          _checkForLoadMore(notification);
        }
        return false;
      },
      child: CustomScrollView(
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        reverse: reverse,
        cacheExtent: cacheExtent,
        slivers: [
          if (padding != null) SliverPadding(padding: padding!),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (hasSeparator && index > 0) {
                  // Return separator before item (except first item)
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      separatorBuilder!(context, index - 1),
                      _buildItem(context, items[index], index),
                    ],
                  );
                }
                return _buildItem(context, items[index], index);
              },
              childCount: itemCount,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
            ),
          ),
          // Always show footer when appending or has error, even if no more items
          if (isAppending || hasAppendError)
            SliverToBoxAdapter(
              child: _buildFooterItem(
                  context, hasMore, isAppending, hasAppendError, state),
            ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, T item, int index) {
    final key = keyBuilder != null ? keyBuilder!(item, index) : null;

    return RepaintBoundary(
      child: KeyedSubtree(
        key: key != null ? ValueKey(key) : null,
        child: itemBuilder(context, item, index),
      ),
    );
  }

  Widget _buildFooterItem(
    BuildContext context,
    bool hasMore,
    bool isAppending,
    bool hasAppendError,
    PaginationState<T> state,
  ) {
    if (hasAppendError) {
      if (appendErrorBuilder != null) {
        return appendErrorBuilder!(context, state.appendError!);
      }

      return AppendErrorView(
        error: state.appendError!,
        onRetry: onRetryAppend ?? controller.loadNextPage,
      );
    } else if (isAppending) {
      if (appendLoaderBuilder != null) {
        return appendLoaderBuilder!(context);
      }

      return const AppendLoader();
    }

    return const SizedBox.shrink();
  }

  void _checkForLoadMore(ScrollNotification notification) {
    // Don't trigger if already loading or no more items available
    if (!controller.canLoadMore || controller.isLoading) return;

    final metrics = notification.metrics;
    
    // Only check if we have valid scroll dimensions
    if (!metrics.hasContentDimensions || metrics.maxScrollExtent == 0) return;
    
    final threshold = prefetchThreshold ?? 3;
    final thresholdPixels = threshold * 100.0;
    
    // Calculate remaining scroll distance
    final remainingScroll = metrics.maxScrollExtent - metrics.pixels;
    
    // Check if we're near the end (within threshold pixels from bottom)
    // For reverse scrolling, check distance from top
    final isNearEnd = reverse
        ? metrics.pixels <= metrics.minScrollExtent + thresholdPixels
        : remainingScroll <= thresholdPixels;

    if (isNearEnd) {
      controller.loadNextPage();
    }
  }
}
