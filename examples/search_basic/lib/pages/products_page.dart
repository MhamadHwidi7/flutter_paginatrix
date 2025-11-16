import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import '../models/product.dart';

/// Example: Basic Search with Paginatrix
///
/// This example demonstrates:
/// - Using standard TextField with PaginatrixController for search
/// - Automatic debouncing via controller.updateSearchTerm() (400ms default)
/// - Search term is automatically included in API calls via state.currentQuery
/// - Results update automatically as user types
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final PaginatrixController<Product> _controller;
  final _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  @override
  void initState() {
    super.initState();
    _controller = PaginatrixController<Product>(
      loader: _loadProducts,
      itemDecoder: Product.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      options: PaginationOptions(
        enableDebugLogging: true, // Enable debug logging for examples
        searchDebounceDuration: const Duration(milliseconds: 400),
        defaultPageSize: 20,
      ),
    );
    _controller.loadFirstPage();
  }

  /// Loader function that includes search term from query criteria
  Future<Map<String, dynamic>> _loadProducts({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
    QueryCriteria? query,
  }) async {
    // Use query from parameter if provided, otherwise use controller state
    final currentQuery = query ?? _controller.state.currentQuery;
    final currentPage = page ?? 1;
    final itemsPerPage = perPage ?? 20;

    // Debug: Print API call parameters
    debugPrint('🔵 [ProductsPage] API Call:');
    debugPrint('   📄 Page: $currentPage');
    debugPrint('   📊 Items per page: $itemsPerPage');
    if (currentQuery.searchTerm.isNotEmpty) {
      debugPrint('   🔍 Search: "${currentQuery.searchTerm}"');
    }

    // Build query parameters including search term
    final queryParams = <String, dynamic>{
      'limit': itemsPerPage,
      'skip': (currentPage - 1) * itemsPerPage,
      if (currentQuery.searchTerm.isNotEmpty) 'q': currentQuery.searchTerm,
    };

    debugPrint('   🌐 Making API request: GET /products/search?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}');
    final stopwatch = Stopwatch()..start();
    final response = await _dio.get(
      '/products/search',
      queryParameters: queryParams,
      cancelToken: cancelToken,
    );
    stopwatch.stop();
    debugPrint('   ✅ API Response received in ${stopwatch.elapsedMilliseconds}ms');
    debugPrint('   📦 Status: ${response.statusCode}');

    final responseData = response.data as Map<String, dynamic>;
    final products = responseData['products'] as List? ?? [];
    final total = responseData['total'] as int? ?? 0;
    debugPrint('   📋 Products returned: ${products.length} items');
    debugPrint('   📊 Total: $total');

    // Transform response to match expected format
    return {
      'data': products,
      'meta': {
        'current_page': currentPage,
        'per_page': itemsPerPage,
        'total': total,
        'last_page': (total / itemsPerPage).ceil(),
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Products'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search field - uses standard TextField with controller logic
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Controller handles debouncing automatically
                _controller.updateSearchTerm(value);
              },
            ),
          ),
          // Product list - automatically updates when search changes
          Expanded(
            child: PaginatrixListView<Product>(
              controller: _controller,
              itemBuilder: (context, product, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(product.thumbnail),
                    ),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                    trailing: Text(
                      '⭐ ${product.rating}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

