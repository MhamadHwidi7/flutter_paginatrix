import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/entities/pagination_error.dart';
import '../../core/entities/pagination_state.dart';
import '../controllers/paginated_cubit.dart';
import 'append_loader.dart';
import 'pagination_empty_view.dart';
import 'pagination_error_view.dart';
import 'pagination_skeletonizer.dart';

/// GridView adapter for Paginatrix using BlocBuilder
///
/// This widget uses [PaginatedCubit] with [BlocBuilder] for reactive UI updates.
///
/// ## Example
///
/// ```dart
/// final cubit = PaginatedCubit<Pokemon>(
///   loader: repository.loadPokemon,
///   itemDecoder: Pokemon.fromJson,
///   metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
/// );
///
/// PaginatrixGridView<Pokemon>(
///   cubit: cubit,
///   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
///     crossAxisCount: 2,
///     crossAxisSpacing: 8,
///     mainAxisSpacing: 8,
///   ),
///   itemBuilder: (context, pokemon, index) {
///     return PokemonCard(pokemon: pokemon);
///   },
/// )
/// ```
class PaginatrixGridView<T> extends StatelessWidget {
  const PaginatrixGridView({
    super.key,
    required this.cubit,
    required this.itemBuilder,
    required this.gridDelegate,
    this.keyBuilder,
    this.prefetchThreshold,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
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

  final PaginatedCubit<T> cubit;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String Function(T item, int index)? keyBuilder;
  final SliverGridDelegate gridDelegate;
  final int? prefetchThreshold;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
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
    return BlocBuilder<PaginatedCubit<T>, PaginationState<T>>(
      bloc: cubit,
      builder: _buildContent,
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
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              shimmerBuilder!,
              childCount: 10, // Default shimmer count
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
            ),
            gridDelegate: gridDelegate,
          ),
        ],
      );
    }

    return PaginationGridSkeletonizer(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      reverse: reverse,
      gridDelegate: gridDelegate,
    );
  }

  Widget _buildSuccessState(BuildContext context, PaginationState<T> state) {
    return _buildRefreshableContent(context, state);
  }

  Widget _buildRefreshingState(BuildContext context, PaginationState<T> state) {
    return _buildRefreshableContent(context, state);
  }

  Widget _buildAppendingState(BuildContext context, PaginationState<T> state) {
    return _buildRefreshableContent(context, state);
  }

  Widget _buildRefreshableContent(BuildContext context, PaginationState<T> state) {
    return RefreshIndicator(
      onRefresh: () async {
        cubit.refresh();
        if (onPullToRefresh != null) {
          onPullToRefresh!();
        }
      },
      child: _buildGridWithItems(context, state),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    if (emptyBuilder != null) {
      return emptyBuilder!(context);
    }

    return GenericEmptyView(
      onRefresh: onRetryInitial ?? cubit.loadFirstPage,
    );
  }

  Widget _buildErrorState(BuildContext context, PaginationState<T> state) {
    if (errorBuilder != null) {
      return errorBuilder!(context, state.error!);
    }

    return PaginationErrorView(
      error: state.error!,
      onRetry: onRetryInitial ?? cubit.loadFirstPage,
    );
  }

  Widget _buildAppendErrorState(
      BuildContext context, PaginationState<T> state) {
    return _buildGridWithItems(context, state);
  }

  Widget _buildGridWithItems(BuildContext context, PaginationState<T> state) {
    final items = state.items;
    final itemCount = items.length;
    final hasMore = state.canLoadMore;
    final isAppending = state.status.maybeWhen(
      appending: () => true,
      orElse: () => false,
    );
    final hasAppendError = state.hasAppendError;

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
      child: CustomScrollView(
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: scrollDirection,
        reverse: reverse,
        cacheExtent: cacheExtent,
        slivers: [
          if (padding != null) SliverPadding(padding: padding!),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < itemCount) {
                  final item = items[index];
                  final key =
                      keyBuilder != null ? keyBuilder!(item, index) : null;

                  return RepaintBoundary(
                    child: KeyedSubtree(
                      key: key != null ? ValueKey(key) : null,
                      child: itemBuilder(context, item, index),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
              childCount: itemCount,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
            ),
            gridDelegate: gridDelegate,
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
}
