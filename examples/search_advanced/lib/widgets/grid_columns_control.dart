library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/view_controls_cubit.dart';
import '../cubit/view_controls_state.dart';

/// Grid columns control widget
///
/// Provides a slider to control the number of grid columns (1-2)
class GridColumnsControl extends StatelessWidget {
  const GridColumnsControl({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<ViewControlsCubit, ViewControlsState>(
      builder: (context, viewControlsState) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.grid_view,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                'Columns',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: viewControlsState.gridColumns,
                  min: 1,
                  max: 2,
                  divisions: 1,
                  label: viewControlsState.gridColumns.round().toString(),
                  onChanged: (value) {
                    context.read<ViewControlsCubit>().updateGridColumns(value);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  viewControlsState.gridColumns.round().toString(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
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

