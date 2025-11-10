# 🚀 Flutter Paginatrix

[![pub package](https://img.shields.io/pub/v/flutter_paginatrix.svg)](https://pub.dev/packages/flutter_paginatrix)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.22+-blue.svg)](https://flutter.dev)
[![CI/CD](https://github.com/mhamadhwidi/flutter_paginatrix/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/mhamadhwidi/flutter_paginatrix/actions/workflows/ci-cd.yml)

**A simple, flexible, and backend-agnostic pagination package for Flutter applications.**

Flutter Paginatrix provides everything you need for pagination with clean architecture, comprehensive error handling, and beautiful UI components built with Slivers for optimal performance.

---

## ✨ Features

- ✅ **Backend Agnostic** - Works with any API structure (page/perPage, offset/limit, cursor-based)
- ✅ **Single Loader Function** - One function handles all pagination scenarios
- ✅ **Type-Safe** - Full generics support with immutable data structures
- ✅ **Reactive** - Stream-based state management with flutter_bloc
- ✅ **Performance Optimized** - Sliver-based architecture for smooth scrolling
- ✅ **Comprehensive Error Handling** - 6 error types with automatic recovery
- ✅ **Beautiful UI Components** - Pre-built widgets with modern loading animations
- ✅ **Request Cancellation** - Automatic cleanup of in-flight requests
- ✅ **Stale Response Prevention** - Generation-based guards prevent race conditions
- ✅ **Zero External Dependencies** - flutter_bloc is bundled, no need to add it to your pubspec.yaml
- ✅ **171+ Tests** - Comprehensive test coverage

---

## 📦 Installation

Add `flutter_paginatrix` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_paginatrix: ^1.0.0
  dio: ^5.4.0  # Optional - Only needed if using Dio for HTTP requests
```

> **Note:** `flutter_bloc` is included as a dependency of `flutter_paginatrix`, so you don't need to add it to your `pubspec.yaml`. The package uses it internally for state management, but you can use the API without importing `flutter_bloc` directly.

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start

### Simple Usage (Recommended - No flutter_bloc import required)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final PaginatrixController<User> _controller;
  final _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  @override
  void initState() {
    super.initState();
    _controller = PaginatrixController<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(
      '/users',
      queryParameters: {'page': page, 'per_page': perPage},
      cancelToken: cancelToken,
    );
    return response.data; // {data: [...], meta: {...}}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: PaginatrixListView<User>(
        controller: _controller,
        itemBuilder: (context, user, index) {
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
        appendLoaderBuilder: (context) => const AppendLoader(
          loaderType: LoaderType.pulse,
          message: 'Loading more users...',
        ),
        onPullToRefresh: () => _controller.refresh(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

// User model
class User {
  const User({required this.name, required this.email});

  final String name;
  final String email;

  static User fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
```

### Advanced Usage with flutter_bloc (Optional)

If you want to use `BlocProvider` and `BlocBuilder` directly for more control:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaginatrixCubit<User>(
        loader: _loadUsers,
        itemDecoder: User.fromJson,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      )..loadFirstPage(),
      child: const UsersView(),
    );
  }

  static Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    final response = await dio.get(
      '/users',
      queryParameters: {'page': page, 'per_page': perPage},
      cancelToken: cancelToken,
    );
    return response.data; // {data: [...], meta: {...}}
  }
}

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: BlocBuilder<PaginatrixCubit<User>, PaginationState<User>>(
        builder: (context, state) {
          return PaginatrixListView<User>(
            controller: context.read<PaginatrixCubit<User>>(),
            itemBuilder: (context, user, index) {
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
            appendLoaderBuilder: (context) => const AppendLoader(
              loaderType: LoaderType.pulse,
              message: 'Loading more users...',
            ),
            onPullToRefresh: () => context.read<PaginatrixCubit<User>>().refresh(),
          );
        },
      ),
    );
  }
}

// User model
class User {
  const User({required this.name, required this.email});

  final String name;
  final String email;

  static User fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
```

---

## 📚 Core Concepts

### Single Loader Function

The library uses a **single loader function** that handles both initial load and pagination:

```dart
Future<Map<String, dynamic>> Function({
  int? page,        // Page number (1-based)
  int? perPage,     // Items per page
  int? offset,      // Offset for offset/limit pagination
  int? limit,       // Limit for offset/limit pagination
  String? cursor,   // Cursor for cursor-based pagination
  CancelToken? cancelToken,  // For request cancellation
})
```

The controller automatically:
- Calls this function with `page: 1` for initial load
- Calls it with `page: 2, 3, ...` for pagination
- Manages the list (sets for first page, appends for next pages)

### RequestContext

`RequestContext` prevents stale responses and manages race conditions:

- **Generation numbers** - Ensures only the latest response updates the UI
- **Request cancellation** - Automatic cleanup of in-flight requests
- **Race condition prevention** - Multiple rapid requests handled correctly

### Meta Parsers

Meta parsers transform API responses into the expected format:

- **ConfigMetaParser** - Pre-configured parsers for common API formats
- **CustomMetaParser** - Flexible parser for custom API response structures

---

## 🎯 Usage Examples

### List View with Pagination

```dart
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final PaginatrixController<Product> _controller;
  final _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  @override
  void initState() {
    super.initState();
    _controller = PaginatrixController<Product>(
      loader: _loadProducts,
      itemDecoder: Product.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadProducts({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(
      '/products',
      queryParameters: {'page': page, 'per_page': perPage},
      cancelToken: cancelToken,
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: PaginatrixListView<Product>(
        controller: _controller,
        itemBuilder: (context, product, index) {
          return ProductCard(product: product);
        },
        appendLoaderBuilder: (context) => const AppendLoader(
          loaderType: LoaderType.pulse,
          message: 'Loading more products...',
        ),
        onPullToRefresh: () => _controller.refresh(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
```

### Grid View with Pagination

```dart
class ProductsGridPage extends StatefulWidget {
  const ProductsGridPage({super.key});

  @override
  State<ProductsGridPage> createState() => _ProductsGridPageState();
}

class _ProductsGridPageState extends State<ProductsGridPage> {
  late final PaginatrixController<Product> _controller;
  final _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  @override
  void initState() {
    super.initState();
    _controller = PaginatrixController<Product>(
      loader: _loadProducts,
      itemDecoder: Product.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadProducts({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(
      '/products',
      queryParameters: {'page': page, 'per_page': perPage},
      cancelToken: cancelToken,
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: PaginatrixGridView<Product>(
        controller: _controller,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, product, index) {
          return ProductCard(product: product);
        },
        appendLoaderBuilder: (context) => const AppendLoader(
          loaderType: LoaderType.wave,
          message: 'Loading more...',
        ),
        onPullToRefresh: () => _controller.refresh(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
```

### Page Selection (Web)

```dart
class ProductsPageWithSelector extends StatefulWidget {
  const ProductsPageWithSelector({super.key});

  @override
  State<ProductsPageWithSelector> createState() => _ProductsPageWithSelectorState();
}

class _ProductsPageWithSelectorState extends State<ProductsPageWithSelector> {
  late final PaginatrixController<Product> _controller;
  final _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  @override
  void initState() {
    super.initState();
    _controller = PaginatrixController<Product>(
      loader: _loadProducts,
      itemDecoder: Product.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadProducts({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(
      '/products',
      queryParameters: {'page': page, 'per_page': perPage},
      cancelToken: cancelToken,
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          // Page selector at the top
          BlocBuilder<PaginatrixCubit<Product>, PaginationState<Product>>(
            bloc: _controller,
            builder: (context, state) {
              return PageSelector(
                currentPage: state.meta?.page ?? 1,
                totalPages: state.meta?.lastPage ?? 1,
                onPageSelected: (page) {
                  // Navigate to specific page
                  _controller.loadFirstPage();
                },
                style: PageSelectorStyle.buttons,
                showFirstLast: true,
                showPreviousNext: true,
              );
            },
          ),
          // Product list
          Expanded(
            child: PaginatrixListView<Product>(
              controller: _controller,
              itemBuilder: (context, product, index) {
                return ProductCard(product: product);
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
```

### Error Handling

```dart
class UsersPageWithErrorHandling extends StatefulWidget {
  const UsersPageWithErrorHandling({super.key});

  @override
  State<UsersPageWithErrorHandling> createState() => _UsersPageWithErrorHandlingState();
}

class _UsersPageWithErrorHandlingState extends State<UsersPageWithErrorHandling> {
  late final PaginatrixController<User> _controller;
  final _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  @override
  void initState() {
    super.initState();
    _controller = PaginatrixController<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(
      '/users',
      queryParameters: {'page': page, 'per_page': perPage},
      cancelToken: cancelToken,
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: BlocBuilder<PaginatrixCubit<User>, PaginationState<User>>(
        bloc: _controller,
        builder: (context, state) {
          if (state.hasError) {
            return PaginationErrorView(
              error: state.error!,
              onRetry: () => _controller.retry(),
            );
          }
          
          if (state.isEmpty) {
            return PaginationEmptyView(
              title: 'No users found',
              description: 'Try refreshing to load users',
              action: ElevatedButton(
                onPressed: () => _controller.loadFirstPage(),
                child: const Text('Retry'),
              ),
            );
          }
          
          return PaginatrixListView<User>(
            controller: _controller,
            itemBuilder: (context, user, index) => UserTile(user: user),
            errorBuilder: (context, error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${error.message}'),
                  ElevatedButton(
                    onPressed: () => _controller.retry(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            appendErrorBuilder: (context, error) => Center(
              child: Column(
                children: [
                  Text('Failed to load more: ${error.message}'),
                  ElevatedButton(
                    onPressed: () => _controller.retry(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
```

---

## 📖 API Reference

### PaginatrixController<T>

The main controller for managing paginated data. This is the recommended public API.

**Constructor:**
```dart
PaginatrixController<T>({
  required LoaderFn<T> loader,
  required ItemDecoder<T> itemDecoder,
  required MetaParser metaParser,
  PaginationOptions? options,
})
```

**Properties:**
- `PaginationState<T> state` - Current pagination state
- `bool canLoadMore` - Whether more data can be loaded
- `bool isLoading` - Whether currently loading
- `bool hasData` - Whether has data
- `bool hasError` - Whether has error
- `bool hasAppendError` - Whether has append error

**Methods:**
- `Future<void> loadFirstPage()` - Loads the first page (resets list)
- `Future<void> loadNextPage()` - Loads the next page (appends to list)
- `Future<void> refresh()` - Refreshes current data (debounced)
- `Future<void> retry()` - Retries the last failed operation
- `void cancel()` - Cancels current request
- `void clear()` - Clears all data and resets to initial state
- `Future<void> close()` - Closes the controller (call in dispose)

### PaginatrixCubit<T>

The internal cubit implementation. Use `PaginatrixController` instead unless you need `BlocProvider`/`BlocBuilder`.

**Note:** `PaginatrixController` is a type alias for `PaginatrixCubit<T>`, so you can use either depending on your needs.

### PaginatrixListView<T>

A ListView widget with built-in pagination support using Slivers.

**Key Parameters:**
- `controller` or `cubit` - The pagination controller (required)
- `itemBuilder` - Function to build each item (required)
- `appendLoaderBuilder` - Custom loader widget for pagination
- `onPullToRefresh` - Callback for pull-to-refresh
- `onRetryInitial` - Callback for retrying initial load
- `onRetryAppend` - Callback for retrying append
- `errorBuilder` - Custom error widget for initial load errors
- `appendErrorBuilder` - Custom error widget for append errors
- `emptyBuilder` - Custom empty state widget
- `scrollDirection` - Scroll direction (default: Axis.vertical)
- `padding` - Padding around the list
- `physics` - Scroll physics
- `shrinkWrap` - Whether to shrink-wrap the list
- `reverse` - Whether to reverse the list
- `separatorBuilder` - Builder for separators between items
- `skeletonizerBuilder` - Custom skeleton loader

### PaginatrixGridView<T>

A GridView widget with built-in pagination support using Slivers.

**Key Parameters:**
- `controller` or `cubit` - The pagination controller (required)
- `gridDelegate` - Grid layout configuration (required)
- `itemBuilder` - Function to build each item (required)
- `appendLoaderBuilder` - Custom loader widget for pagination
- `onPullToRefresh` - Callback for pull-to-refresh
- `errorBuilder` - Custom error widget
- `appendErrorBuilder` - Custom error widget for append errors
- `emptyBuilder` - Custom empty state widget

### PageSelector

A reusable widget for page selection with multiple display styles.

**Styles:**
- `PageSelectorStyle.buttons` - Displays page numbers as buttons
- `PageSelectorStyle.dropdown` - Displays page numbers in a dropdown
- `PageSelectorStyle.compact` - Compact display with current/total pages

**Example:**
```dart
PageSelector(
  currentPage: 1,
  totalPages: 10,
  onPageSelected: (page) {
    // Handle page selection
  },
  style: PageSelectorStyle.buttons,
  showFirstLast: true,
  showPreviousNext: true,
)
```

### AppendLoader

A beautiful loading widget for pagination.

**Loader Types:**
- `LoaderType.circular` - Circular progress indicator
- `LoaderType.linear` - Linear progress indicator
- `LoaderType.pulse` - Pulsing animation
- `LoaderType.rotating` - Rotating animation
- `LoaderType.wave` - Wave animation
- `LoaderType.bouncingDots` - Bouncing dots animation
- `LoaderType.skeleton` - Skeleton loading effect
- `LoaderType.traditional` - Traditional spinner

**Example:**
```dart
AppendLoader(
  loaderType: LoaderType.pulse,
  message: 'Loading more...',
  color: Colors.blue,
  size: 24,
  padding: const EdgeInsets.all(16),
)
```

---

## 🔧 Configuration

### Meta Parsers

#### ConfigMetaParser

Pre-configured parsers for common API formats:

```dart
// Nested meta format: {data: [], meta: {current_page, per_page, ...}}
ConfigMetaParser(MetaConfig.nestedMeta)

// Results format: {results: [], count, page, per_page, ...}
ConfigMetaParser(MetaConfig.resultsFormat)

// Simple page-based: {data: [], page, per_page, ...}
ConfigMetaParser(MetaConfig.pageBased)

// Offset-based: {data: [], offset, limit, ...}
ConfigMetaParser(MetaConfig.offsetBased)
```

#### CustomMetaParser

For non-standard API formats:

```dart
CustomMetaParser(
  itemsExtractor: (data) => data['items'] as List,
  metaExtractor: (data) {
    return PageMeta(
      page: data['page'] as int,
      perPage: data['limit'] as int,
      total: data['total'] as int,
      lastPage: (data['total'] as int / data['limit'] as int).ceil(),
    );
  },
)
```

### PaginationOptions

```dart
PaginationOptions(
  defaultPageSize: 20,
  maxPageSize: 100,
  requestTimeout: Duration(seconds: 30),
  enableDebugLogging: false,
  refreshDebounceDuration: Duration(milliseconds: 300),
  defaultPrefetchThreshold: 3, // Load next page when 3 items from end
  initialBackoff: Duration(milliseconds: 500),
  maxRetries: 3,
  retryResetTimeout: Duration(minutes: 5),
)
```

### BuildConfig

Environment-specific configuration:

```dart
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

// Get environment-specific configuration
final config = BuildConfig.current;
final options = config.defaultPaginationOptions;

final controller = PaginatrixController<User>(
  loader: loadUsers,
  itemDecoder: User.fromJson,
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
  options: options, // Uses environment-specific options
);
```

---

## 🎨 UI Components

### PaginationErrorView

Displays pagination errors with retry functionality:

```dart
PaginationErrorView(
  error: state.error!,
  onRetry: () => controller.retry(),
)
```

### PaginationEmptyView

Displays empty states:

```dart
PaginationEmptyView(
  title: 'No items found',
  description: 'Try refreshing to load items',
  action: ElevatedButton(
    onPressed: () => controller.loadFirstPage(),
    child: const Text('Retry'),
  ),
)
```

### PaginationSkeletonizer

Skeleton loading effect for initial load:

```dart
PaginationSkeletonizer(
  padding: EdgeInsets.all(16),
  physics: AlwaysScrollableScrollPhysics(),
)
```

---

## 📱 Examples

The package includes comprehensive examples:

- **example_basic_controller** - Basic usage with `PaginatrixController` (no flutter_bloc import required)
- **example_list_view** - `PaginatrixListView` with performance monitoring
- **example_grid_view** - `PaginatrixGridView` pagination
- **example_bloc_pattern** - BLoC pattern integration with custom events (Pokemon API)
- **example_cubit_direct** - Direct `PaginatrixCubit` usage with BlocBuilder
- **example_web_infinite_scroll** - Web infinite scroll pagination
- **example_web_page_selector** - Web page selector pagination

Run any example:

```bash
cd examples/example_basic_controller
flutter run
```

---

## 🛡️ Error Handling

The library provides comprehensive error handling with 6 error types:

1. **Network Errors** - Connection issues, timeouts, HTTP errors
2. **Parse Errors** - Invalid response format, missing keys
3. **Cancelled Errors** - Request was cancelled
4. **Rate Limited Errors** - Too many requests
5. **Circuit Breaker Errors** - Service unavailable
6. **Unknown Errors** - Unexpected errors

All errors are retryable where appropriate and provide user-friendly messages.

---

## ⚡ Performance

- **Sliver-based architecture** - Optimal scrolling performance
- **Request cancellation** - Prevents unnecessary work
- **Generation guards** - Prevents stale responses
- **Efficient state management** - Minimal rebuilds with flutter_bloc
- **Memory-efficient** - Proper disposal and cleanup
- **Debounced refresh** - Prevents rapid successive refresh calls
- **Prefetch threshold** - Configurable distance from end to trigger load

---

## 🧪 Testing

The package includes comprehensive tests:

- **171+ tests** covering all scenarios
- **Unit tests** for entities and controllers
- **Integration tests** for complete flows
- **Widget tests** for UI components
- **Performance tests** for large datasets
- **Edge case coverage** - Empty responses, errors, cancellation, race conditions

Run tests:

```bash
flutter test
```

Run tests with coverage:

```bash
flutter test --coverage
```

---

## 🔄 CI/CD

The package includes a complete CI/CD pipeline:

- **Automated testing** on every push and pull request
- **Code formatting** and analysis checks
- **Code coverage** reporting
- **Automated publishing** to pub.dev on version tags
- **GitHub Releases** creation

The CI/CD pipeline is configured in `.github/workflows/ci-cd.yml`.

---

## 📄 Documentation

All documentation is included in this README. For changelog, see [CHANGELOG.md](CHANGELOG.md).

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🔗 Links

- **Package**: [pub.dev/packages/flutter_paginatrix](https://pub.dev/packages/flutter_paginatrix)
- **Repository**: [github.com/mhamadhwidi/flutter_paginatrix](https://github.com/mhamadhwidi/flutter_paginatrix)
- **Issues**: [github.com/mhamadhwidi/flutter_paginatrix/issues](https://github.com/mhamadhwidi/flutter_paginatrix/issues)

---

## ⭐ Show Your Support

If you find this package useful, please consider giving it a ⭐ on GitHub!

---

**Made with ❤️ for the Flutter community**
