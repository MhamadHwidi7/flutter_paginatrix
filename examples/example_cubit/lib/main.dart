import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubit Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PokemonPage(),
    );
  }
}

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  late final PaginatedCubit<Pokemon> _cubit;

  @override
  void initState() {
    super.initState();
    
    // Create the Cubit
    _cubit = PaginatedCubit<Pokemon>(
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
              final offset = int.parse(match.group(1)!);
              currentPage = (offset ~/ 20) + 2;
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
            'meta': meta,
          };
        },
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
  }) async {
    final dio = Dio();
    final actualOffset = ((page ?? 1) - 1) * (perPage ?? 20);
    
    final response = await dio.get(
      'https://pokeapi.co/api/v2/pokemon',
      queryParameters: {
        'offset': actualOffset,
        'limit': perPage ?? 20,
      },
      cancelToken: cancelToken,
    );
    
    return response.data as Map<String, dynamic>;
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
        title: const Text('Pokemon (Cubit + BlocBuilder)'),
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
          return _PokemonCard(pokemon: pokemon);
        },
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
                  memCacheWidth: 200,
                  memCacheHeight: 267,
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
                      '#${pokemon.id}',
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
                Text(
                  _capitalizeFirst(pokemon.name),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
}

// Simple Pokemon model
class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = int.parse(url.split('/')[url.split('/').length - 2]);
    
    return Pokemon(
      id: id,
      name: json['name'] as String,
      url: url,
    );
  }

  final int id;
  final String name;
  final String url;

  String get imageUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }
}

