library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../cubit/view_controls_cubit.dart';
import '../cubit/view_controls_state.dart';
import '../models/pokemon.dart';
import '../utils/pokemon_type_colors.dart';
import 'package:shared/utils/string_extensions.dart';

/// Active filters widget
///
/// Displays active filters as chips with clear functionality
class ActiveFilters extends StatelessWidget {
  const ActiveFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ViewControlsCubit, ViewControlsState>(
      builder: (context, viewControlsState) {
        if (!viewControlsState.hasActiveFilters) {
          return const SizedBox.shrink();
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Filters',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (viewControlsState.hasSearch)
                    Chip(
                      avatar: const Icon(Icons.search, size: 16),
                      label: Text('Search: "${viewControlsState.searchTerm}"'),
                      onDeleted: () {
                        context.read<PaginationBloc<Pokemon>>().add(
                              UpdateSearch(''),
                            );
                      },
                      deleteIcon: const Icon(Icons.close, size: 18),
                      backgroundColor: colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 12,
                      ),
                    ),
                  if (viewControlsState.hasTypeFilter) ...[
                    Builder(
                      builder: (context) {
                        final selectedType = viewControlsState.selectedType;
                        if (selectedType == null) {
                          return const SizedBox.shrink();
                        }
                        return Chip(
                          avatar: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color:
                                  PokemonTypeColors.getTypeColor(selectedType),
                              shape: BoxShape.circle,
                            ),
                          ),
                          label: Text(
                            selectedType.capitalizeFirst(),
                          ),
                          onDeleted: () {
                            context.read<PaginationBloc<Pokemon>>().add(
                                  UpdateTypeFilter(null),
                                );
                          },
                          deleteIcon: const Icon(Icons.close, size: 18),
                          backgroundColor: colorScheme.secondaryContainer,
                          labelStyle: TextStyle(
                            color: colorScheme.onSecondaryContainer,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ],
                  if (viewControlsState.hasSorting)
                    Chip(
                      avatar: Icon(
                        viewControlsState.sortDesc
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        size: 16,
                      ),
                      label: Text('Sort: ${viewControlsState.sortBy}'),
                      onDeleted: () {
                        context.read<PaginationBloc<Pokemon>>().add(
                              UpdateSorting(sortBy: null),
                            );
                      },
                      deleteIcon: const Icon(Icons.close, size: 18),
                      backgroundColor: colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<PaginationBloc<Pokemon>>().add(
                          ClearAllFilters(),
                        );
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All Filters'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
