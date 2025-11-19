# 🚀 Flutter Paginatrix

> **A backend-agnostic pagination engine for Flutter**

[![pub points](https://img.shields.io/pub/points/flutter_paginatrix)](https://pub.dev/packages/flutter_paginatrix/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CI/CD](https://github.com/MhamadHwidi7/flutter_paginatrix/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/MhamadHwidi7/flutter_paginatrix/actions/workflows/ci-cd.yml)

A production-ready, type-safe pagination library that works with any backend API. Built with clean architecture, comprehensive error handling, and beautiful UI components.

**📦 [View on pub.dev](https://pub.dev/packages/flutter_paginatrix)** • **📖 [Documentation](./doc/README.md)** • **🐛 [Report Bug](https://github.com/MhamadHwidi7/flutter_paginatrix/issues)** • **📝 [Changelog](./CHANGELOG.md)**

---

## 📑 Table of Contents

- [Features](#-features)
- [Why Flutter Paginatrix?](#-why-flutter-paginatrix)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Basic Usage](#-basic-usage)
- [Advanced Usage](#-advanced-usage)
- [API Overview](#-api-overview)
- [Example Projects](#-example-projects)
- [Common Pitfalls](#️-common-pitfalls)
- [Testing](#-testing)
- [Contributing](#-contributing)
- [License](#-license)
- [Support & Links](#-support--links)

---

## ✨ Features

### Core Capabilities

- 🎯 **Backend-Agnostic** - Works with any API format (REST, GraphQL, custom)
- 🔄 **Multiple Pagination Strategies** - Page-based, offset-based, and cursor-based
- 🎨 **UI Components** - Sliver-based ListView and GridView with skeleton loaders
- 🔒 **Type-Safe** - Full generics support with compile-time safety
- 🧩 **DI Flexible** - Use any DI solution (`get_it`, `provider`, `riverpod`) or create instances directly

### Performance & Reliability

- ⚡ **LRU Caching** - Metadata caching prevents redundant parsing
- 🛡️ **Race Condition Protection** - Generation guards prevent stale responses
- 🚫 **Request Cancellation** - Automatic cleanup of in-flight requests
- 🔁 **Automatic Retry** - Exponential backoff retry (1s → 2s → 4s → 8s)
- ⏱️ **Smart Debouncing** - Search (400ms) and refresh (300ms) debouncing

### Developer Experience

- 🔍 **Search & Filtering** - Built-in support with type-safe access
- 🎭 **6 Error Types** - Network, parse, cancelled, rate-limited, circuit breaker, unknown
- 📱 **Web Support** - Page selector widget with multiple styles
- 🎨 **Customizable UI** - Custom builders for empty states, errors, and loaders
- 🧪 **Well-Tested** - Comprehensive test suite covering unit, integration, and widget tests

---

## 🎯 Why Flutter Paginatrix?

- **Controller-Based API** - Clean state management using Cubit (flutter_bloc)
- **Zero Boilerplate** - Minimal configuration with sensible defaults
- **Production-Ready** - Comprehensive error handling and race condition protection
- **Flexible Meta Parsing** - Configurable parsers for any API response structure
- **Performance First** - LRU caching, debouncing, efficient Sliver rendering

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_paginatrix: ^latest_version  # Replace with actual version from pub.dev
```

> **Note:** Replace `^latest_version` with the actual version number from [pub.dev](https://pub.dev/packages/flutter_paginatrix).

Then run:

```bash
flutter pub get
```

### Requirements

- **Flutter:** >=3.22.0
- **Dart:** >=3.2.0 <4.0.0

---

## 🚀 Quick Start

### 1. Create a Controller

```dart
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

final controller = PaginatrixController<User>(
  loader: ({
    int? page,
    int? perPage,
    CancelToken? cancelToken,
    QueryCriteria? query,
  }) async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    final searchTerm = query?.searchTerm;
    final response = await dio.get('/users', queryParameters: {
      'page': page ?? 1,
      'per_page': perPage ?? 20,
      if (searchTerm != null && searchTerm.isNotEmpty) 'q': searchTerm,
    }, cancelToken: cancelToken);
    return response.data; // {data: [...], meta: {...}}
  },
  itemDecoder: (json) => User.fromJson(json),
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
);
```

### 2. Use the Widget

```dart
PaginatrixListView<User>(
  controller: controller,
  itemBuilder: (context, user, index) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  },
)
```

### 3. Load Data

```dart
@override
void initState() {
  super.initState();
  controller.loadFirstPage(); // Required
}

@override
void dispose() {
  controller.close();
  super.dispose();
}
```

The widget automatically handles loading states, errors, empty states, pagination on scroll, pull-to-refresh, and append loading indicators without additional configuration.

---

## 📖 Basic Usage

### Complete Example

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
      itemDecoder: (json) => User.fromJson(json),
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
    CancelToken? cancelToken,
    QueryCriteria? query,
  }) async {
    final searchTerm = query?.searchTerm;
    final response = await _dio.get(
      '/users',
      queryParameters: {
        'page': page ?? 1,
        'per_page': perPage ?? 20,
        if (searchTerm != null && searchTerm.isNotEmpty) 'q': searchTerm,
      },
      cancelToken: cancelToken,
    );
    return response.data;
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: PaginatrixListView<User>(
        controller: _controller,
        itemBuilder: (context, user, index) {
          return ListTile(
            leading: CircleAvatar(child: Text(user.name[0])),
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
      ),
    );
  }
}
```

---

## 🎨 Advanced Usage

### Search

```dart
// Update search term (automatically debounced, 400ms default)
_controller.updateSearchTerm('john');
```

### Filters

```dart
// Add a filter (triggers immediate reload)
_controller.updateFilter('status', 'active');

// Add multiple filters
_controller.updateFilters({
  'status': 'active',
  'role': 'admin',
});

// Clear all filters
_controller.clearFilters();
```

### Sorting

```dart
// Set sorting (triggers immediate reload)
_controller.updateSorting('name', sortDesc: false);

// Clear sorting
_controller.updateSorting(null);
```

### Custom Meta Parser

For APIs with non-standard response formats:

```dart
final controller = PaginatrixController<Product>(
  loader: _loadProducts,
  itemDecoder: (json) => Product.fromJson(json),
  metaParser: CustomMetaParser(
    (data) {
      return {
        'items': data['products'] as List,
        'meta': {
          'page': data['page'],
          'perPage': data['limit'],
          'total': data['total_count'],
          'hasMore': data['has_next'],
        },
      };
    },
  ),
);
```

### Pull-to-Refresh

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  onPullToRefresh: () async {
    await _controller.refresh();
  },
)
```

### Custom Error Handling

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  errorBuilder: (context, error, onRetry) {
    return PaginatrixErrorView(
      error: error,
      onRetry: onRetry,
    );
  },
)
```

### GridView

```dart
PaginatrixGridView<Product>(
  controller: _controller,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  ),
  itemBuilder: (context, product, index) {
    return ProductCard(product: product);
  },
)
```

### Web Page Selector

```dart
PageSelector(
  currentPage: _controller.state.meta?.page ?? 1,
  totalPages: _controller.state.meta?.lastPage ?? 1,
  onPageSelected: (page) {
    _controller.loadFirstPage(); // Reset and load page
  },
  style: PageSelectorStyle.buttons,
)
```

### Configuration Options

```dart
final controller = PaginatrixController<User>(
  loader: _loadUsers,
  itemDecoder: (json) => User.fromJson(json),
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
  options: const PaginationOptions(
    defaultPageSize: 20,
    maxPageSize: 100,
    maxRetries: 5,
    initialBackoff: Duration(milliseconds: 500),
    refreshDebounceDuration: Duration(milliseconds: 300),
    searchDebounceDuration: Duration(milliseconds: 400),
    enableDebugLogging: false,
  ),
);
```

### Dependency Injection

The core pagination classes do **NOT** require any specific DI solution. They accept dependencies through constructors, allowing you to use any DI approach.

#### Using `get_it`

```dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<Dio>(Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
  )));
}

// Use in controller
final controller = PaginatrixController<User>(
  loader: getIt<UsersRepository>().loadUsers,
  itemDecoder: (json) => User.fromJson(json),
  metaParser: getIt<MetaParser>(),
);
```

#### Using `provider`

```dart
MultiProvider(
  providers: [
    Provider(create: (_) => Dio(BaseOptions(baseUrl: 'https://api.example.com'))),
    Provider(create: (_) => ConfigMetaParser(MetaConfig.nestedMeta)),
  ],
  child: MyApp(),
)
```

---

## 📚 API Overview

### Core Classes

#### `PaginatrixController<T>`

Main controller for managing paginated data. Type alias for `PaginatrixCubit<T>`.

**Key Methods:**

- `loadFirstPage()` - Load the first page (resets list)
- `loadNextPage()` - Load the next page (appends to list)
- `refresh()` - Refresh current data (debounced)
- `updateSearchTerm(String term)` - Update search term (debounced)
- `updateFilter(String key, dynamic value)` - Add/update a filter
- `updateFilters(Map<String, dynamic> filters)` - Add/update multiple filters
- `clearFilters()` - Clear all filters
- `updateSorting(String? sortBy, {bool sortDesc})` - Set sorting
- `clearAllQuery()` - Clear all search, filters, and sorting
- `retry()` - Retry failed operation
- `cancel()` - Cancel in-flight requests
- `clear()` - Clear all data and reset
- `close()` - Dispose resources

**Key Properties:**

- `state: PaginationState<T>` - Current state
- `canLoadMore: bool` - Whether more data can be loaded
- `isLoading: bool` - Whether loading is in progress

#### `PaginationState<T>`

Immutable state object containing:

- `status: PaginationStatus` - Current status
- `items: List<T>` - Loaded items
- `meta: PageMeta?` - Pagination metadata
- `error: PaginationError?` - Current error (if any)
- `query: QueryCriteria` - Current search/filter criteria

**Extension Methods:**

- `hasData: bool` - Whether items exist
- `isLoading: bool` - Whether in loading state
- `canLoadMore: bool` - Whether more pages available
- `currentQuery: QueryCriteria` - Current query criteria

#### `PageMeta`

Pagination metadata:

- `page: int?` - Current page number
- `perPage: int?` - Items per page
- `total: int?` - Total items
- `lastPage: int?` - Last page number
- `hasMore: bool` - Whether more pages available
- `nextCursor: String?` - Cursor for cursor-based pagination
- `offset: int?` / `limit: int?` - For offset-based pagination

#### `QueryCriteria`

Immutable value object for search and filter criteria:

- `searchTerm: String` - Search term
- `filters: Map<String, dynamic>` - Filter key-value pairs
- `sortBy: String?` - Field to sort by
- `sortDesc: bool` - Sort direction

**Methods:**

- `withFilter(String key, dynamic value)` - Add/update filter
- `withFilters(Map<String, dynamic> filters)` - Add/update multiple filters
- `removeFilter(String key)` - Remove filter
- `clearSearch()` - Clear search
- `clearFilters()` - Clear filters
- `clearSorting()` - Clear sorting
- `clearAll()` - Clear everything

### Widgets

#### `PaginatrixListView<T>`

ListView widget with built-in pagination.

**Key Parameters:**

- `controller` or `cubit` - Pagination controller (required)
- `itemBuilder` - Function to build each item (required)
- `keyBuilder` - Optional key generator
- `prefetchThreshold` - Items from end to trigger load
- `emptyBuilder` - Custom empty state
- `errorBuilder` - Custom error state
- `appendErrorBuilder` - Custom append error state
- `appendLoaderBuilder` - Custom append loader
- `onPullToRefresh` - Pull-to-refresh callback
- `onRetryInitial` - Retry initial load callback
- `onRetryAppend` - Retry append callback

#### `PaginatrixGridView<T>`

GridView widget with built-in pagination. Same parameters as `PaginatrixListView` plus:

- `gridDelegate` - Grid layout configuration (required)

#### `AppendLoader`

Loading indicator with multiple animation types:

- `LoaderType.bouncingDots` - Bouncing dots
- `LoaderType.wave` - Wave animation
- `LoaderType.rotatingSquares` - Rotating squares
- `LoaderType.pulse` - Pulse animation
- `LoaderType.skeleton` - Skeleton effect
- `LoaderType.traditional` - Traditional spinner

#### `PaginatrixErrorView`

Error display widget with retry functionality.

#### `PaginatrixAppendErrorView`

Inline error view for append failures.

#### `PaginatrixEmptyView`

Base empty state widget. Variants:

- `PaginatrixGenericEmptyView` - Generic empty state
- `PaginatrixSearchEmptyView` - Search empty state
- `PaginatrixNetworkEmptyView` - Network empty state

#### `PaginatrixSkeletonizer`

Skeleton loading effect widget with customizable item builders.

#### `PageSelector`

Page selection widget for web with styles:

- `PageSelectorStyle.buttons` - Button-based pagination
- `PageSelectorStyle.dropdown` - Dropdown selector
- `PageSelectorStyle.compact` - Compact display

### Meta Parsers

#### `ConfigMetaParser`

Pre-configured parser for common API formats with automatic LRU caching.

**Pre-configured Configs:**

- `MetaConfig.nestedMeta` - `{data: [], meta: {current_page, per_page, ...}}`
- `MetaConfig.resultsFormat` - `{results: [], count, page, per_page, ...}`
- `MetaConfig.pageBased` - Simple page-based format
- `MetaConfig.cursorBased` - Cursor-based format
- `MetaConfig.offsetBased` - Offset/limit format

**Custom Config:**

```dart
final config = MetaConfig(
  itemsPath: 'data',
  pagePath: 'meta.current_page',
  perPagePath: 'meta.per_page',
  totalPath: 'meta.total',
  lastPagePath: 'meta.last_page',
  hasMorePath: 'meta.has_more',
);

final parser = ConfigMetaParser(config);
```

#### `CustomMetaParser`

Flexible parser for custom API structures:

```dart
CustomMetaParser(
  (data) {
    return {
      'items': data['products'] as List,
      'meta': {
        'page': data['page'],
        'perPage': data['limit'],
        'total': data['total_count'],
        'hasMore': data['has_next'],
      },
    };
  },
)
```

### Enums

#### `PaginationStatus`

Union type for pagination status:

- `initial()` - Initial state
- `loading()` - Loading data
- `success()` - Successfully loaded
- `empty()` - Empty state
- `error()` - Error occurred
- `refreshing()` - Refreshing data
- `appending()` - Loading next page
- `appendError()` - Error during append

#### `PaginationError`

Union type for error types:

- `network()` - Network errors
- `parse()` - Parse errors
- `cancelled()` - Cancellation errors
- `rateLimited()` - Rate limit errors
- `circuitBreaker()` - Circuit breaker errors
- `unknown()` - Unknown errors

**Properties:**

- `isRetryable: bool` - Whether error can be retried
- `isUserVisible: bool` - Whether to show to user
- `userMessage: String` - User-friendly message

#### `LoaderType`

Types of loaders for pagination UI:

- `bouncingDots` - Bouncing dots animation
- `wave` - Wave animation
- `rotatingSquares` - Rotating squares animation
- `pulse` - Pulse animation
- `skeleton` - Skeleton loading effect
- `traditional` - Traditional spinner

---

## 📁 Example Projects

The package includes a main example and additional examples demonstrating various use cases:

### Main Example

The main example is located at `example/` and demonstrates basic ListView pagination:

```bash
cd example
flutter pub get
flutter run
```

### Additional Examples

Additional examples are located in `example/examples/`:

| Example | Description | Path |
|---------|-------------|------|
| **`grid_view`** | GridView pagination | `example/examples/grid_view` |
| **`bloc_pattern`** | BLoC pattern integration | `example/examples/bloc_pattern` |
| **`cubit_direct`** | Direct `PaginatrixCubit` usage | `example/examples/cubit_direct` |
| **`search_basic`** | Basic search with debouncing | `example/examples/search_basic` |
| **`search_advanced`** | Advanced search with filters and sorting | `example/examples/search_advanced` |
| **`web_infinite_scroll`** | Web infinite scroll pagination | `example/examples/web_infinite_scroll` |
| **`web_page_selector`** | Web page selector pagination | `example/examples/web_page_selector` |

Run any additional example:

```bash
cd example/examples/grid_view  # Replace with your desired example
flutter pub get
flutter run
```

For detailed documentation on all examples, see [example/README.md](./example/README.md).

---

## ⚠️ Common Pitfalls

### 1. Not Disposing Controllers

**❌ Wrong:**

```dart
final controller = PaginatrixController<User>(...);
// Controller not disposed - potential memory leak
```

**✅ Correct:**

```dart
@override
void dispose() {
  _controller.close();
  super.dispose();
}
```

### 2. Forgetting to Call `loadFirstPage()`

**❌ Wrong:**

```dart
@override
void initState() {
  super.initState();
  _controller = PaginatrixController<User>(...);
  // Missing loadFirstPage() - data won't load
}
```

**✅ Correct:**

```dart
@override
void initState() {
  super.initState();
  _controller = PaginatrixController<User>(...);
  _controller.loadFirstPage(); // Required
}
```

### 3. Incorrect Meta Parser Configuration

**❌ Wrong:**

```dart
// Paths don't match API structure
metaParser: ConfigMetaParser(MetaConfig.nestedMeta), // But API uses 'results' not 'data'
```

**✅ Correct:**

```dart
// Match your API structure
metaParser: ConfigMetaParser(MetaConfig.resultsFormat), // Or use CustomMetaParser
```

### 4. Not Handling Errors

**❌ Wrong:**

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  // No error handling - users see nothing on error
)
```

**✅ Correct:**

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  errorBuilder: (context, error, onRetry) {
    return PaginatrixErrorView(error: error, onRetry: onRetry);
  },
)
```

### 5. Search vs Filter Behavior

Understanding the difference between search and filters:

- **Search** (`updateSearchTerm`) - Debounced (400ms default), triggers reload after delay
- **Filters** (`updateFilter`, `updateFilters`) - Immediate, triggers reload right away

### 6. Dependency Injection

**❌ Wrong:**

```dart
// Creating new instances everywhere
final dio1 = Dio();
final dio2 = Dio(); // Separate instance
```

**✅ Correct:**

```dart
// Use DI for shared dependencies (example with get_it)
final getIt = GetIt.instance;
getIt.registerSingleton<Dio>(Dio());
final dio = getIt<Dio>(); // Shared instance
```

---

## 🧪 Testing

The package includes comprehensive test coverage. Here's an example test:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  test('should load first page', () async {
    final controller = PaginatrixController<User>(
      loader: mockLoader,
      itemDecoder: (json) => User.fromJson(json),
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );

    await controller.loadFirstPage();

    expect(controller.state.items.length, greaterThan(0));
    expect(controller.state.status, PaginationStatus.success());
  });

  test('should handle search', () async {
    final controller = PaginatrixController<User>(...);
    await controller.loadFirstPage();

    controller.updateSearchTerm('john');
    await Future.delayed(const Duration(milliseconds: 500)); // Wait for debounce

    expect(controller.state.currentQuery.searchTerm, equals('john'));
  });
}
```

See the `test/` directory for additional examples including integration tests and performance tests.

---

## 🤝 Contributing

Contributions are welcome. Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please make sure your code:
- Follows the existing code style
- Includes tests for new features
- Updates documentation as needed
- Passes all existing tests

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Mhamad Hwidi

---

## 🔗 Support & Links

### Package Links

- 📦 [Pub.dev Package](https://pub.dev/packages/flutter_paginatrix)
- 🐙 [GitHub Repository](https://github.com/MhamadHwidi7/flutter_paginatrix)
- 🐛 [Issue Tracker](https://github.com/MhamadHwidi7/flutter_paginatrix/issues)
- 📖 [API Documentation](https://pub.dev/documentation/flutter_paginatrix)
- 📚 [Full Documentation](./doc/README.md)
- 📝 [Changelog](./CHANGELOG.md)

### Support the Project

If you find this package useful, please consider the following:

- ⭐ **Starring the repository** - Help others discover this package
- 🐛 **Reporting bugs** - Help improve the package
- 💡 **Suggesting features** - Share your ideas
- 📖 **Improving documentation** - Help others learn

---

Made with ❤️ for the Flutter community
