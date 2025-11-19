import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';

/// Products page widget
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
    final config = BuildConfig.current;

    _cubit = PaginatrixCubit<Product>(
      loader: _loadProducts,
      itemDecoder: Product.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      options: PaginationOptions(
        enableDebugLogging: true, // Enable debug logging for examples
        defaultPageSize: config.defaultPaginationOptions.defaultPageSize,
        searchDebounceDuration:
            config.defaultPaginationOptions.searchDebounceDuration,
        refreshDebounceDuration:
            config.defaultPaginationOptions.refreshDebounceDuration,
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
    final itemsPerPage =
        perPage ?? 12; // Reduced to ensure scrollable content in grid

    // Debug: Print API call parameters
    debugPrint('🔵 [ProductsPage] Loader Call (Mock Data):');
    debugPrint('   📄 Page: $currentPage');
    debugPrint('   📊 Items per page: $itemsPerPage');
    debugPrint('   ⏱️  Simulating API delay...');
    final stopwatch = Stopwatch()..start();
    // Simulate API delay to see loading state
    await Future.delayed(const Duration(seconds: 2));
    stopwatch.stop();
    debugPrint(
        '   ✅ Simulated delay completed in ${stopwatch.elapsedMilliseconds}ms');

    // Generate mock products
    debugPrint('   🔄 Generating ${itemsPerPage} mock products...');
    final products = List.generate(
      itemsPerPage,
      (index) {
        final id = (currentPage - 1) * itemsPerPage + index + 1;
        return {
          'id': id,
          'name': 'Product $id',
          'price': (99.99 + (id % 100)).toStringAsFixed(2),
          'image': 'https://picsum.photos/300/300?random=$id',
          'rating': 4.0 + (id % 10) / 10,
        };
      },
    );

    final totalPages = 5;
    final hasMore = currentPage < totalPages;
    debugPrint(
        '   📊 Pagination: Page $currentPage/$totalPages, Has more: $hasMore');
    debugPrint('   ✅ Returning ${products.length} products');

    return {
      'data': products,
      'meta': {
        'current_page': currentPage,
        'per_page': itemsPerPage,
        'total': 100,
        'last_page': totalPages,
        'has_more': hasMore,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        elevation: 0,
      ),
      body: PaginatrixGridView<Product>(
        cubit: _cubit,
        padding: const EdgeInsets.all(8),
        cacheExtent: 250,
        prefetchThreshold:
            1, // More aggressive threshold for grid (load when 100px from end)
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, product, index) {
          return ProductCard(product: product);
        },
        // Custom loading indicator - choose any LoaderType
        appendLoaderBuilder: (context) => AppendLoader(
          loaderType: LoaderType
              .pulse, // Options: bouncingDots, wave, rotatingSquares, pulse, skeleton, traditional
          message: 'Loading more products...',
          color: Theme.of(context).colorScheme.primary,
          size: 28,
          padding: const EdgeInsets.all(20),
        ),
        onPullToRefresh: () {
          // Optional: Add custom refresh logic
        },
      ),
    );
  }
}
