import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/entities/pagination_error.dart';
import '../../core/entities/pagination_state.dart';
import '../controllers/paginated_cubit.dart';
import 'pagination_skeletonizer.dart';
import 'paginatrix_state_builder_mixin.dart';

/// ListView adapter for Paginatrix using BlocBuilder
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
/// PaginatrixListView<Pokemon>(
///   cubit: cubit,
///   itemBuilder: (context, pokemon, index) {
///     return PokemonCard(pokemon: pokemon);
///   },
/// )
/// ```
class PaginatrixListView<T> extends StatelessWidget
    with PaginatrixStateBuilderMixin<T> {
  const PaginatrixListView({
    super.key,
    required this.cubit,
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

  // Required by mixin
  @override
  final PaginatedCubit<T> cubit;

  // Widget-specific fields
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

  // Mixin-required callbacks
  @override
  final Widget Function(BuildContext context)? emptyBuilder;
  @override
  final Widget Function(BuildContext context, PaginationError error)?
      errorBuilder;
  @override
  final Widget Function(BuildContext context, PaginationError error)?
      appendErrorBuilder;
  @override
  final Widget Function(BuildContext context)? appendLoaderBuilder;
  @override
  final VoidCallback? onPullToRefresh;
  @override
  final VoidCallback? onRetryInitial;
  @override
  final VoidCallback? onRetryAppend;

  // ListView performance options
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginatedCubit<T>, PaginationState<T>>(
      bloc: cubit,
      builder: buildContent,
    );
  }

  @override
  Widget buildLoadingState(BuildContext context) {
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

    // Use PaginationSkeletonizer which handles its own CustomScrollView
    return PaginationSkeletonizer(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      reverse: reverse,
    );
  }

  @override
  Widget buildScrollableContent(BuildContext context, PaginationState<T> state) {
    final items = state.items;
    final itemCount = items.length;
    final hasMore = state.canLoadMore;
    final isAppending = state.status.maybeWhen(
      appending: () => true,
      orElse: () => false,
    );
    final hasAppendError = state.hasAppendError;
    final hasSeparator = separatorBuilder != null;

    return createScrollListener(
      prefetchThreshold: prefetchThreshold,
      reverse: reverse,
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
                      buildItem(context, items[index], index, itemBuilder, keyBuilder),
                    ],
                  );
                }
                return buildItem(context, items[index], index, itemBuilder, keyBuilder);
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
}
