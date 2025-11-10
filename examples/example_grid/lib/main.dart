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
      title: 'Flutter Paginatrix Grid Example',
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
  late final PaginatedCubit<Product> _cubit;

  @override
  void initState() {
    super.initState();
    final config = BuildConfig.current;
    
    _cubit = PaginatedCubit<Product>(
      loader: _loadProducts,
      itemDecoder: Product.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      options: config.defaultPaginationOptions,
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
  }) async {
    // Simulate API delay to see loading state
    await Future.delayed(const Duration(seconds: 2));

    final currentPage = page ?? 1;
    final itemsPerPage = perPage ?? 12; // Reduced to ensure scrollable content in grid

    // Generate mock products
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

    return {
      'data': products,
      'meta': {
        'current_page': currentPage,
        'per_page': itemsPerPage,
        'total': 100,
        'last_page': 5,
        'has_more': currentPage < 5,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products Grid'),
        elevation: 0,
      ),
      body: PaginatrixGridView<Product>(
        cubit: _cubit,
        padding: const EdgeInsets.all(8),
        cacheExtent: 250,
        prefetchThreshold: 1, // More aggressive threshold for grid (load when 100px from end)
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, product, index) {
          return _ProductCard(product: product);
        },
        // Custom loading indicator - choose any LoaderType
        appendLoaderBuilder: (context) => AppendLoader(
          loaderType: LoaderType.pulse, // Options: bouncingDots, wave, rotatingSquares, pulse, skeleton, traditional
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  memCacheWidth: 400,
                  memCacheHeight: 533,
                  maxWidthDiskCache: 800,
                  maxHeightDiskCache: 1066,
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: downloadProgress.progress,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                    );
                  },
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
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
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
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }
  final int id;
  final String name;
  final String price;
  final String image;
  final double rating;
}
