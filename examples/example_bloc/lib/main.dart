import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import 'bloc/pagination_bloc.dart';
import 'bloc/pagination_event.dart';
import 'bloc/pagination_state.dart';
import 'models/pokemon.dart';
import 'repository/pokemon_repository.dart';

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
          // Get the controller from the BLoC
          final bloc = context.read<PaginationBloc<Pokemon>>();
          final controller = bloc.controller;

          // Handle initial/loading state
          if (blocState.paginationState.status.maybeWhen(
                initial: () => true,
                orElse: () => false,
              ) ||
              (blocState.isLoading && !blocState.hasData)) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Handle error state
          if (blocState.hasError && !blocState.hasData) {
            return PaginationErrorView(
              error: blocState.error!,
              onRetry: () {
                context.read<PaginationBloc<Pokemon>>().add(
                      const RetryPagination(),
                    );
              },
            );
          }

          // Handle empty state
          if (blocState.paginationState.status.maybeWhen(
                empty: () => true,
                orElse: () => false,
              )) {
            return PaginationEmptyView(
              title: 'No Pokemon found',
              description: 'Try refreshing to load Pokemon',
              action: ElevatedButton(
                onPressed: () {
                  context.read<PaginationBloc<Pokemon>>().add(
                        const LoadFirstPage(),
                      );
                },
                child: const Text('Retry'),
              ),
            );
          }

          // Show grid with data
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
            itemBuilder: (context, pokemon, index) {
              return _PokemonCard(pokemon: pokemon);
            },
            appendLoaderBuilder: (context) => AppendLoader(
              loaderType: LoaderType.pulse,
              message: 'Loading more Pokemon...',
              color: Theme.of(context).colorScheme.primary,
              size: 28,
              padding: const EdgeInsets.all(20),
            ),
            onPullToRefresh: () {
              context.read<PaginationBloc<Pokemon>>().add(
                    const RefreshPage(),
                  );
            },
            onRetryInitial: () {
              context.read<PaginationBloc<Pokemon>>().add(
                    const RetryPagination(),
                  );
            },
            onRetryAppend: () {
              context.read<PaginationBloc<Pokemon>>().add(
                    const LoadNextPage(),
                  );
            },
          );
        },
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  const _PokemonCard({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pokemon Image
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  fit: BoxFit.cover,
                  // Optimized cache sizes for 2-column grid to prevent jank frames
                  // Display size: ~180-200px width, ~240-267px height
                  // Memory cache: Actual display size (1x)
                  memCacheWidth: 200,
                  memCacheHeight: 267,
                  // Disk cache: 2x for retina displays
                  maxWidthDiskCache: 400,
                  maxHeightDiskCache: 534,
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return ColoredBox(
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: downloadProgress.progress,
                          color: colorScheme.primary,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => ColoredBox(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported,
                      color: colorScheme.onSurfaceVariant,
                      size: 48,
                    ),
                  ),
                  fadeInDuration: const Duration(milliseconds: 300),
                ),
                // Pokemon ID badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#${pokemon.id.toString().padLeft(3, '0')}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Pokemon Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pokemon Name
                Text(
                  _capitalizeFirst(pokemon.name),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Pokemon Types
                if (pokemon.types.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: pokemon.types.take(2).map((type) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getTypeColor(type).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getTypeColor(type),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _capitalizeFirst(type),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _getTypeColor(type),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Color _getTypeColor(String type) {
    const typeColors = {
      'normal': Colors.brown,
      'fire': Colors.orange,
      'water': Colors.blue,
      'electric': Colors.yellow,
      'grass': Colors.green,
      'ice': Colors.lightBlue,
      'fighting': Colors.red,
      'poison': Colors.purple,
      'ground': Colors.brown,
      'flying': Colors.lightBlue,
      'psychic': Colors.pink,
      'bug': Colors.green,
      'rock': Colors.brown,
      'ghost': Colors.purple,
      'dragon': Colors.indigo,
      'dark': Colors.brown,
      'steel': Colors.grey,
      'fairy': Colors.pink,
    };
    return typeColors[type.toLowerCase()] ?? Colors.grey;
  }
}
