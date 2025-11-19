library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../cubit/view_controls_cubit.dart';
import '../cubit/view_controls_state.dart';
import '../models/pokemon.dart';

/// Sort controls widget
///
/// Provides dropdown for sort field and toggle for sort direction
class SortControls extends StatelessWidget {
  const SortControls({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ViewControlsCubit, ViewControlsState>(
      builder: (context, viewControlsState) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sort,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String?>(
                  value: viewControlsState.sortBy,
                  decoration: InputDecoration(
                    labelText: 'Sort by',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                  ),
                  items: const [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text('None'),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'id',
                      child: Text('ID'),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'name',
                      child: Text('Name'),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'height',
                      child: Text('Height'),
                    ),
                    DropdownMenuItem<String?>(
                      value: 'weight',
                      child: Text('Weight'),
                    ),
                  ],
                  onChanged: (value) {
                    final bloc = context.read<PaginationBloc<Pokemon>>();
                    if (value != null) {
                      final isSame = viewControlsState.sortBy == value;
                      bloc.add(
                        UpdateSorting(
                          sortBy: value,
                          sortDesc:
                              isSame ? !viewControlsState.sortDesc : false,
                        ),
                      );
                    } else {
                      bloc.add(UpdateSorting(sortBy: null));
                    }
                  },
                ),
              ),
              if (viewControlsState.sortBy != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    viewControlsState.sortDesc
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: colorScheme.primary,
                  ),
                  tooltip: viewControlsState.sortDesc
                      ? 'Sort descending'
                      : 'Sort ascending',
                  onPressed: () {
                    context.read<PaginationBloc<Pokemon>>().add(
                          UpdateSorting(
                            sortBy: viewControlsState.sortBy,
                            sortDesc: !viewControlsState.sortDesc,
                          ),
                        );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
