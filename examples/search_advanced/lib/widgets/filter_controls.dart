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

/// Filter controls widget
///
/// Provides horizontally scrollable filter chips for Pokemon types
class FilterControls extends StatelessWidget {
  const FilterControls({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ViewControlsCubit, ViewControlsState>(
      builder: (context, viewControlsState) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Type',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 0,
                  children: PokemonTypeColors.pokemonTypes.map((type) {
                    final isSelected = viewControlsState.selectedType == type;
                    return FilterChip(
                      avatar: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: PokemonTypeColors.getTypeColor(type),
                          shape: BoxShape.circle,
                        ),
                      ),
                      label: Text(type.capitalizeFirst()),
                      selected: isSelected,
                      onSelected: (selected) {
                        context.read<PaginationBloc<Pokemon>>().add(
                              UpdateTypeFilter(selected ? type : null),
                            );
                      },
                      selectedColor: colorScheme.secondaryContainer,
                      checkmarkColor: colorScheme.onSecondaryContainer,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? colorScheme.onSecondaryContainer
                            : colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

