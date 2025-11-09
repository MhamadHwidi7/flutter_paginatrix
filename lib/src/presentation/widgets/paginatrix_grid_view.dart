import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/entities/pagination_error.dart';
import '../../core/entities/pagination_state.dart';
import '../controllers/paginated_cubit.dart';
import 'pagination_skeletonizer.dart';
import 'paginatrix_state_builder_mixin.dart';

/// GridView adapter for Paginatrix using BlocBuilder
///
/// This widget uses [PaginatedCubit] with [BlocBuilder] for reactive UI updates.
///
/// ## Scroll Direction & Reverse
///
/// When using [reverse] with [scrollDirection]:
/// - **Vertical + reverse**: Grid scrolls from bottom to top
/// - **Horizontal + reverse**: Grid scrolls from right to left
/// - Both combinations are valid but have different UX implications
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
class PaginatrixGridView<T> extends StatelessWidget
    with PaginatrixStateBuilderMixin<T> {
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
    this.skeletonizerBuilder,
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
  }) : assert(
          scrollDirection == Axis.vertical || scrollDirection == Axis.horizontal,
          'scrollDirection must be either Axis.vertical or Axis.horizontal',
        );

  // Required by mixin
  @override
  final PaginatedCubit<T> cubit;

  // Widget-specific fields
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String Function(T item, int index)? keyBuilder;
  final SliverGridDelegate gridDelegate;
  final int? prefetchThreshold;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final Widget Function(BuildContext context, int index)? skeletonizerBuilder;

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

  // GridView performance options
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
    if (skeletonizerBuilder != null) {
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
              skeletonizerBuilder!,
              childCount: 10, // Default skeletonizer count
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
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < itemCount) {
                  return buildItem(context, items[index], index, itemBuilder, keyBuilder);
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
