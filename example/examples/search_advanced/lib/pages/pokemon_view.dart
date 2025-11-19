import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import 'package:shared/bloc/pagination_state.dart';

import '../bloc/extensions/pagination_extensions.dart';
import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../cubit/view_controls_cubit.dart';
import '../models/pokemon.dart';
import '../widgets/active_filters.dart';
import '../widgets/filter_controls.dart';
import '../widgets/grid_columns_control.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/search_controls.dart';
import '../widgets/sort_controls.dart';

/// Pokemon view widget
class PokemonView extends StatefulWidget {
  const PokemonView({
    required this.paginationBloc,
    super.key,
  });

  final PaginationBloc<Pokemon> paginationBloc;

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  @override
  void initState() {
    super.initState();
    // Load first page on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.paginationBloc.add(const LoadFirstPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final paginationBloc = widget.paginationBloc;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Pokemon Search'),
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // --- Top controls (search + filters + sort + columns) ---
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: const [
                    SearchControls(),
                    FilterControls(),
                    SortControls(),
                    GridColumnsControl(),
                    ActiveFilters(),
                  ],
                ),
              ),
            ),
          ),

          // --- Pokemon grid ---
          Expanded(
            child: BlocBuilder<PaginationBloc<Pokemon>,
                PaginationBlocState<Pokemon>>(
              bloc: paginationBloc,
              builder: (context, blocState) {
                final state = blocState.paginationState;

                // Handle initial/loading state using extension
                if (state.shouldShowLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Handle error state using extension
                if (state.shouldShowError) {
                  final error = blocState.error;
                  if (error != null) {
                    return _buildErrorView(context, paginationBloc, error);
                  }
                }

                // Handle empty state using extension
                if (state.shouldShowEmpty) {
                  return _buildEmptyView(context);
                }

                // Show grid with data using extension
                if (state.shouldShowContent) {
                  return _buildGridView(context, paginationBloc);
                }

                // Fallback (should never reach here)
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the error view with retry button
  Widget _buildErrorView(
    BuildContext context,
    PaginationBloc<Pokemon> paginationBloc,
    PaginationError error,
  ) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Failed to load Pokemon',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error.message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                paginationBloc.add(const RetryPagination());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the empty state view
  Widget _buildEmptyView(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'No Pokemon found. Try adjusting your search or filters.',
        ),
      ),
    );
  }

  /// Builds the grid view with Pokemon data
  Widget _buildGridView(
    BuildContext context,
    PaginationBloc<Pokemon> paginationBloc,
  ) {
    final controller = paginationBloc.controller;
    final viewControlsState = context.read<ViewControlsCubit>().state;

    return PaginatrixGridView<Pokemon>(
      cubit: controller,
      onPullToRefresh: () {
        paginationBloc.add(const RefreshPage());
      },
      endOfListMessage: 'No more Pokemon to load',
      appendLoaderBuilder: (context) => const AppendLoader(
        loaderType: LoaderType.pulse,
        message: 'Loading more Pokemon...',
      ),
      appendErrorBuilder: (context, error) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load more Pokemon',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  paginationBloc.add(const LoadNextPage());
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      errorBuilder: (context, error) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load Pokemon',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  paginationBloc.add(const RetryPagination());
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      emptyBuilder: (context) => const Center(
        child: Text(
          'No Pokemon found. Try adjusting your search or filters.',
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: viewControlsState.gridColumns.round(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext context, Pokemon pokemon, int index) {
        return PokemonCard(pokemon: pokemon);
      },
    );
  }
}
