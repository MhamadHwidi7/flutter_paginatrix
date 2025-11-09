import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import 'bloc/extensions/pagination_extensions.dart';
import 'bloc/pagination_bloc.dart';
import 'bloc/pagination_event.dart';
import 'bloc/pagination_state.dart';
import 'models/pokemon.dart';
import 'repository/pokemon_repository.dart';
import 'widgets/pokemon_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon BLoC Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const PokemonPage(),
    );
  }
}

class PokemonPage extends StatelessWidget {
  const PokemonPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create repository
    final repository = PokemonRepository();

    // Create the PaginatedController with repository
    // The loader function will be called for both initial load and pagination
    final controller = PaginatedController<Pokemon>(
      loader: repository.loadPokemonPage,
      itemDecoder: Pokemon.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );

    // Create and provide the BLoC
    return BlocProvider(
      create: (context) => PaginationBloc<Pokemon>(controller: controller)
        ..add(const LoadFirstPage()),
      child: const _PokemonView(),
    );
  }
}

class _PokemonView extends StatelessWidget {
  const _PokemonView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon (BLoC + Repository)'),
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

    return PaginationErrorView(
      error: error!,
      onRetry: () => bloc.add(const RetryPagination()),
    );
  }

  /// Builds the empty state view
  Widget _buildEmptyView(BuildContext context) {
    return PaginationEmptyView(
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
      controller: controller,
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
