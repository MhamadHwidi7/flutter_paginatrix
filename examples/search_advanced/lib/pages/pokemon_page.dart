import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../cubit/view_controls_cubit.dart';
import '../models/pokemon.dart';
import '../repository/pokemon_repository.dart';
import 'pokemon_view.dart';

/// Example: Advanced Search, Filtering, and Sorting with Paginatrix using BLoC Pattern
///
/// This example demonstrates:
/// - Using BLoC pattern with PaginatrixCubit
/// - UI Cubit for managing UI state (search, filters, sort, grid columns)
/// - Repository pattern for data access
/// - Search via TextField
/// - Type filters via horizontally scrollable FilterChips
/// - Sorting via DropdownButtonFormField + direction toggle
/// - Clear-all functionality
/// - All query criteria included in API calls via repository
/// - CachedNetworkImage for optimized image loading
class PokemonPage extends StatelessWidget {
  const PokemonPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create repository
    final repository = PokemonRepository();

    // Create view controls cubit
    final viewControlsCubit = ViewControlsCubit();

    // Create the PaginationBloc with repository, view controls cubit, and item decoder
    final paginationBloc = PaginationBloc<Pokemon>(
      repository: repository,
      uiCubit: viewControlsCubit,
      itemDecoder: Pokemon.fromJson,
    );

    // Provide both BLoCs to the widget tree
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: viewControlsCubit),
        BlocProvider.value(value: paginationBloc),
      ],
      child: PokemonView(
        paginationBloc: paginationBloc,
      ),
    );
  }
}


