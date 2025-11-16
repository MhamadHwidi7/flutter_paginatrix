library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../cubit/view_controls_cubit.dart';
import '../cubit/view_controls_state.dart';
import '../models/pokemon.dart';

/// Search controls widget
///
/// Provides a search text field with clear functionality
class SearchControls extends StatefulWidget {
  const SearchControls({super.key});

  @override
  State<SearchControls> createState() => _SearchControlsState();
}

class _SearchControlsState extends State<SearchControls> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<ViewControlsCubit, ViewControlsState>(
      listener: (context, viewControlsState) {
        // Sync controller with view controls state
        if (_controller.text != viewControlsState.searchTerm) {
          _controller.text = viewControlsState.searchTerm;
        }
      },
      child: BlocBuilder<ViewControlsCubit, ViewControlsState>(
        builder: (context, viewControlsState) {
          return SizedBox(
            width: 320,
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                context.read<PaginationBloc<Pokemon>>().add(UpdateSearch(value));
              },
              decoration: InputDecoration(
                hintText: 'Search Pokemon by name or ID...',
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: viewControlsState.hasSearch
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          context.read<PaginationBloc<Pokemon>>().add(
                                UpdateSearch(''),
                              );
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
            ),
          );
        },
      ),
    );
  }
}

