import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Paginatrix - Scroll Pagination',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProductsPage(),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final PaginatrixCubit<Product> _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PaginatrixCubit<Product>(
      loader: _loadProducts,
      itemDecoder: Product.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      options: const PaginationOptions(
        enableDebugLogging: true, // Enable debug logging for examples
      ),
    );
    _cubit.loadFirstPage();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadProducts({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
    QueryCriteria? query,
  }) async {
    final currentPage = page ?? 1;
    final itemsPerPage = perPage ?? 20;

    // Debug: Print API call parameters
    debugPrint('🔵 [ProductsPage] Loader Call (Mock Data):');
    debugPrint('   📄 Page: $currentPage');
    debugPrint('   📊 Items per page: $itemsPerPage');
    debugPrint('   ⏱️  Simulating API delay...');
    final stopwatch = Stopwatch()..start();
    await Future.delayed(const Duration(milliseconds: 500));
    stopwatch.stop();
    debugPrint(
        '   ✅ Simulated delay completed in ${stopwatch.elapsedMilliseconds}ms');

    debugPrint('   🔄 Generating ${itemsPerPage} mock products...');
    final products = List.generate(
      itemsPerPage,
      (index) {
        final id = (currentPage - 1) * itemsPerPage + index + 1;
        return {
          'id': id,
          'name': 'Product $id',
          'description': 'This is a description for product $id',
          'price': (id * 10.99).toStringAsFixed(2),
          'image': 'https://picsum.photos/400/400?random=$id',
          'category': _getCategory(id),
        };
      },
    );

    final totalPages = 10;
    final hasMore = currentPage < totalPages;
    debugPrint(
        '   📊 Pagination: Page $currentPage/$totalPages, Has more: $hasMore');
    debugPrint('   ✅ Returning ${products.length} products');

    return {
      'data': products,
      'meta': {
        'current_page': currentPage,
        'per_page': itemsPerPage,
        'total': 200,
        'last_page': totalPages,
        'has_more': hasMore,
      },
    };
  }

  String _getCategory(int id) {
    final categories = ['Electronics', 'Clothing', 'Books', 'Home', 'Sports'];
    return categories[id % categories.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll Demo'),
        elevation: 0,
        actions: [
          BlocBuilder<PaginatrixCubit<Product>, PaginationState<Product>>(
            bloc: _cubit,
            builder: (context, state) {
              final isRefreshing = state.status.maybeWhen(
                refreshing: () => true,
                orElse: () => false,
              );
              return IconButton(
                icon: isRefreshing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                onPressed: isRefreshing
                    ? null
                    : () {
                        _cubit.refresh();
                      },
                tooltip: 'Refresh',
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 1200
              ? 4
              : constraints.maxWidth > 800
                  ? 3
                  : constraints.maxWidth > 600
                      ? 2
                      : 1;

          return PaginatrixGridView<Product>(
            cubit: _cubit,
            padding: const EdgeInsets.all(16),
            cacheExtent: 500,
            prefetchThreshold: 1, // Load next page when 1 item away from end
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, product, index) {
              return _ProductCard(product: product);
            },
            appendLoaderBuilder: (context) => AppendLoader(
              loaderType: LoaderType.pulse,
              message: 'Loading more products...',
              color: Theme.of(context).colorScheme.primary,
              size: 28,
              padding: const EdgeInsets.all(20),
            ),
            onPullToRefresh: () {
              _cubit.refresh();
            },
            onRetryInitial: () {
              _cubit.retry();
            },
            onRetryAppend: () {
              _cubit.loadNextPage();
            },
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Product product;

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
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.cover,
                  memCacheWidth: 300,
                  memCacheHeight: 400,
                  maxWidthDiskCache: 600,
                  maxHeightDiskCache: 800,
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
                      product.category,
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final String image;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      image: json['image'] as String,
      category: json['category'] as String,
    );
  }
}
