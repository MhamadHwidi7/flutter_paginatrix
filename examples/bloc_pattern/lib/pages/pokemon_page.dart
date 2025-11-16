import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../models/pokemon.dart';
import '../repository/pokemon_repository.dart';
import 'pokemon_view.dart';

/// Pokemon page widget
class PokemonPage extends StatelessWidget {
  const PokemonPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create repository
    final repository = PokemonRepository();

    // Create the PaginatrixCubit with repository
    // The loader function will be called for both initial load and pagination
    final config = BuildConfig.current;
    final controller = PaginatrixCubit<Pokemon>(
      loader: repository.loadPokemonPage,
      itemDecoder: Pokemon.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      options: PaginationOptions(
        enableDebugLogging: true, // Enable debug logging for examples
        defaultPageSize: config.defaultPaginationOptions.defaultPageSize,
        searchDebounceDuration: config.defaultPaginationOptions.searchDebounceDuration,
        refreshDebounceDuration: config.defaultPaginationOptions.refreshDebounceDuration,
      ),
    );

    // Create and provide the BLoC
    return BlocProvider(
      create: (context) => PaginationBloc<Pokemon>(cubit: controller)
        ..add(const LoadFirstPage()),
      child: const PokemonView(),
    );
  }
}

