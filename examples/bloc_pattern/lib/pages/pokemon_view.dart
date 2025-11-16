import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import 'package:shared/bloc/pagination_state.dart';

import '../bloc/extensions/pagination_extensions.dart';
import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';

/// Pokemon view widget
class PokemonView extends StatelessWidget {
  const PokemonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Gallery'),
        elevation: 0,
        actions: [
          // Refresh button - only shows loading when refreshing, not when appending
          BlocBuilder<PaginationBloc<Pokemon>, PaginationBlocState<Pokemon>>(
            builder: (context, state) {
              final isRefreshing = state.isRefreshing;
              return IconButton(
                icon: isRefreshing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                onPressed: isRefreshing
                    ? null
                    : () {
                        context.read<PaginationBloc<Pokemon>>().add(
                              const RefreshPage(),
                            );
                      },
                tooltip: 'Refresh',
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PaginationBloc<Pokemon>, PaginationBlocState<Pokemon>>(
        builder: (context, blocState) {
          final state = blocState.paginationState;

          // Handle initial/loading state using extension
          if (state.shouldShowLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state using extension
          if (state.shouldShowError) {
            return _buildErrorView(context);
          }

          // Handle empty state using extension
          if (state.shouldShowEmpty) {
            return _buildEmptyView(context);
          }

          // Show grid with data using extension
          if (state.shouldShowContent) {
            return _buildGridView(context);
          }

          // Fallback (should never reach here)
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Builds the error view with retry button
  Widget _buildErrorView(BuildContext context) {
    final bloc = context.read<PaginationBloc<Pokemon>>();
    final error = bloc.state.error;

    if (error == null) {
      return const SizedBox.shrink();
    }

    return PaginatrixErrorView(
      error: error,
      onRetry: () => bloc.add(const RetryPagination()),
    );
  }

  /// Builds the empty state view
  Widget _buildEmptyView(BuildContext context) {
    return PaginatrixEmptyView(
      title: 'No Pokemon found',
      description: 'Try refreshing to load Pokemon',
      action: ElevatedButton(
        onPressed: () {
          context.read<PaginationBloc<Pokemon>>().add(const LoadFirstPage());
        },
        child: const Text('Retry'),
      ),
    );
  }

  /// Builds the grid view with Pokemon data
  Widget _buildGridView(BuildContext context) {
    final controller = context.read<PaginationBloc<Pokemon>>().controller;

    return PaginatrixGridView<Pokemon>(
      cubit: controller,
      padding: const EdgeInsets.all(8),
      cacheExtent: 250,
      prefetchThreshold: 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, pokemon, index) => PokemonCard(pokemon: pokemon),
      endOfListMessage: 'No more Pokemon to load',
      appendLoaderBuilder: (context) => AppendLoader(
        loaderType: LoaderType.pulse,
        message: 'Loading more Pokemon...',
        color: Theme.of(context).colorScheme.primary,
        size: 28,
        padding: const EdgeInsets.all(20),
      ),
      onPullToRefresh: () {
        context.read<PaginationBloc<Pokemon>>().add(const RefreshPage());
      },
      onRetryInitial: () {
        context.read<PaginationBloc<Pokemon>>().add(const RetryPagination());
      },
      onRetryAppend: () {
        context.read<PaginationBloc<Pokemon>>().add(const LoadNextPage());
      },
    );
  }
}
