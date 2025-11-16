import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';

/// Pokemon page widget
class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  late final PaginatrixCubit<Pokemon> _cubit;

  @override
  void initState() {
    super.initState();

    final config = BuildConfig.current;

    // Create the Cubit
    _cubit = PaginatrixCubit<Pokemon>(
      loader: _loadPokemonPage,
      itemDecoder: Pokemon.fromJson,
      metaParser: CustomMetaParser(
        (data) {
          // Extract items
          final results = data['results'] as List;
          final items = results.cast<Map<String, dynamic>>();

          // Extract meta
          final count = data['count'] as int;
          final next = data['next'] as String?;
          final previous = data['previous'] as String?;

          // Extract page number from URL
          int? currentPage;
          if (previous == null) {
            currentPage = 1;
          } else {
            final match = RegExp(r'offset=(\d+)').firstMatch(previous);
            if (match != null) {
              final group1 = match.group(1);
              if (group1 != null) {
                final offset = int.parse(group1);
                currentPage = (offset ~/ 20) + 2;
              }
            }
          }

          final meta = PageMeta(
            page: currentPage,
            perPage: 20,
            total: count,
            hasMore: next != null,
          );

          return {
            'items': items,
            'meta': meta.toJson(),
          };
        },
      ),
      options: PaginationOptions(
        enableDebugLogging: true, // Enable debug logging for examples
        defaultPageSize: config.defaultPaginationOptions.defaultPageSize,
        searchDebounceDuration: config.defaultPaginationOptions.searchDebounceDuration,
        refreshDebounceDuration: config.defaultPaginationOptions.refreshDebounceDuration,
      ),
    );

    // Load first page
    _cubit.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadPokemonPage({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
    QueryCriteria? query,
  }) async {
    final dio = Dio();
    final currentPage = page ?? 1;
    final itemsPerPage = perPage ?? 20;
    final actualOffset = (currentPage - 1) * itemsPerPage;

    // Debug: Print API call parameters
    debugPrint('🔵 [PokemonPage] API Call:');
    debugPrint('   📄 Page: $currentPage');
    debugPrint('   📊 Items per page: $itemsPerPage');
    debugPrint('   📍 Offset: $actualOffset, Limit: $itemsPerPage');
    debugPrint('   🌐 Making API request: GET https://pokeapi.co/api/v2/pokemon?offset=$actualOffset&limit=$itemsPerPage');
    final stopwatch = Stopwatch()..start();
    final response = await dio.get(
      'https://pokeapi.co/api/v2/pokemon',
      queryParameters: {
        'offset': actualOffset,
        'limit': itemsPerPage,
      },
      cancelToken: cancelToken,
    );
    stopwatch.stop();
    debugPrint('   ✅ API Response received in ${stopwatch.elapsedMilliseconds}ms');
    debugPrint('   📦 Status: ${response.statusCode}');

    final data = response.data as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? [];
    final count = data['count'] as int? ?? 0;
    debugPrint('   📋 Raw results from API: ${results.length} items');
    debugPrint('   📊 Total count: $count');

    return data;
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Explorer'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _cubit.refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: PaginatrixGridView<Pokemon>(
        cubit: _cubit,
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
          return PokemonCard(pokemon: pokemon);
        },
        endOfListMessage: 'No more Pokemon to load',
        appendLoaderBuilder: (context) => AppendLoader(
          loaderType: LoaderType.pulse,
          message: 'Loading more Pokemon...',
          color: Theme.of(context).colorScheme.primary,
          size: 28,
          padding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}

