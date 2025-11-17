# 🚀 Flutter Paginatrix

> **The most flexible, backend-agnostic pagination engine for Flutter**

[![pub package](https://img.shields.io/pub/v/flutter_paginatrix.svg)](https://pub.dev/packages/flutter_paginatrix)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.22.0-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.2.0-blue.svg)](https://dart.dev)

A production-ready, type-safe pagination library that works with **any backend API**. Built with clean architecture, comprehensive error handling, and beautiful UI components.

---

## ✨ Features

- 🎯 **Backend-Agnostic** - Works with any API format (REST, GraphQL, custom)
- 🔄 **Multiple Pagination Strategies** - Page-based, offset-based, and cursor-based
- 🎨 **Beautiful UI Components** - Sliver-based ListView and GridView with skeleton loaders
- 🔒 **Type-Safe** - Full generics support with compile-time safety
- 🛡️ **Race Condition Protection** - Generation guards prevent stale responses
- ⚡ **Performance Optimized** - LRU caching, debouncing, and efficient rendering
- 🔍 **Search & Filtering** - Built-in support for search, filters, and sorting
- 🚫 **Request Cancellation** - Automatic cleanup of in-flight requests
- 🔁 **Automatic Retry** - Exponential backoff retry with configurable limits
- 🎭 **6 Error Types** - Network, parse, cancelled, rate-limited, circuit breaker, unknown
- 📱 **Web Support** - Page selector widget for web applications
- 🧪 **Well-Tested** - 211+ tests covering unit, integration, and widget scenarios
- 📚 **Comprehensive Docs** - Extensive documentation and examples

---

## 🎯 Why Flutter Paginatrix?

Unlike typical infinite scroll solutions, Flutter Paginatrix provides:

- **Controller-Based API** - Clean, declarative state management using Cubit
- **Zero Boilerplate** - Minimal configuration required
- **Production-Ready** - Battle-tested with comprehensive error handling
- **Flexible Meta Parsing** - Configurable parsers for any API response structure
- **Clean Architecture** - Well-organized codebase following SOLID principles

---

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_paginatrix: ^1.0.0
```

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
    final response = await dio.get('/users', queryParameters: {
      'page': page,
      'per_page': perPage,
      if (query?.searchTerm.isNotEmpty ?? false) 'q': query!.searchTerm,
    });
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
  controller.loadFirstPage(); // Don't forget this!
}
```

That's it! The widget automatically handles:
- ✅ Loading states
- ✅ Error states
- ✅ Empty states
- ✅ Pagination on scroll
- ✅ Pull-to-refresh
- ✅ Append loading indicators

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
  final _dio = Dio();

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
    final response = await _dio.get(
      '/users',
      queryParameters: {
        'page': page ?? 1,
        'per_page': perPage ?? 20,
        if (query?.searchTerm.isNotEmpty ?? false) 'q': query!.searchTerm,
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

### Search Functionality

```dart
// Update search term (automatically debounced)
_controller.updateSearchTerm('john');

// Access current search term
final searchTerm = _controller.state.currentQuery.searchTerm;
```

### Filters

```dart
// Add a filter
_controller.updateFilter('status', 'active');

// Add multiple filters
_controller.updateFilters({
  'status': 'active',
  'role': 'admin',
});

// Remove a filter
_controller.removeFilter('status');

// Clear all filters
_controller.clearFilters();
```

### Sorting

```dart
// Set sorting
_controller.updateSorting('name', descending: false);

// Clear sorting
_controller.clearSorting();
```

### Custom Meta Parser

For APIs with non-standard response formats:

```dart
final controller = PaginatrixController<Product>(
  loader: _loadProducts,
  itemDecoder: (json) => Product.fromJson(json),
  metaParser: CustomMetaParser(
    (data) {
      // Transform raw API response to standard format
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
    itemsKey: 'items',  // Optional, defaults to 'items'
    metaKey: 'meta',    // Optional, defaults to 'meta'
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
    return ErrorView(
      error: error,
      onRetry: onRetry,
    );
  },
  onError: (context, error) {
    // Show toast, dialog, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.userMessage)),
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
    // Navigate to specific page
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
    requestTimeout: Duration(seconds: 30),
    maxRetries: 5,
    refreshDebounceDuration: Duration(milliseconds: 300),
    searchDebounceDuration: Duration(milliseconds: 400),
    enableDebugLogging: false,
  ),
);
```

---

## 📚 API Overview

### Core Classes

#### `PaginatrixController<T>`

Main controller for managing paginated data. This is a type alias for `PaginatrixCubit<T>`.

**Methods:**
- `loadFirstPage()` - Load the first page (resets list)
- `loadNextPage()` - Load the next page (appends to list)
- `refresh()` - Refresh current data
- `updateSearchTerm(String term)` - Update search term (debounced)
- `updateFilter(String key, dynamic value)` - Add/update a filter
- `updateFilters(Map<String, dynamic> filters)` - Add/update multiple filters
- `removeFilter(String key)` - Remove a filter
- `updateSorting(String field, {bool descending})` - Set sorting
- `clearSearch()` - Clear search term
- `clearFilters()` - Clear all filters
- `clearSorting()` - Clear sorting
- `clearAllQuery()` - Clear all search, filters, and sorting
- `retry()` - Retry failed operation
- `cancel()` - Cancel in-flight requests
- `clear()` - Clear all data and reset
- `close()` - Dispose resources

**Properties:**
- `state: PaginationState<T>` - Current state (read-only)
- `canLoadMore: bool` - Whether more data can be loaded
- `isLoading: bool` - Whether loading is in progress
- `hasData: bool` - Whether data has been loaded
- `hasError: bool` - Whether initial load has error
- `hasAppendError: bool` - Whether append has error

#### `PaginationState<T>`

Immutable state object containing:
- `status: PaginationStatus` - Current status (initial, loading, success, error, etc.)
- `items: List<T>` - Loaded items
- `meta: PageMeta?` - Pagination metadata
- `error: PaginationError?` - Current error (if any)
- `appendError: PaginationError?` - Append error (non-blocking)
- `query: QueryCriteria?` - Current search/filter criteria
- `isStale: bool` - Whether data is stale
- `lastLoadedAt: DateTime?` - Last successful load timestamp

**Extension Methods:**
- `hasData: bool` - Whether items exist
- `isLoading: bool` - Whether in loading state
- `hasError: bool` - Whether has error
- `canLoadMore: bool` - Whether more pages available
- `isAppending: bool` - Whether in appending state
- `shouldShowFooter: bool` - Whether footer should be displayed
- `currentQuery: QueryCriteria` - Current query criteria

#### `PageMeta`

Pagination metadata:
- `page: int?` - Current page number
- `perPage: int?` - Items per page
- `total: int?` - Total items
- `lastPage: int?` - Last page number
- `hasMore: bool` - Whether more pages available
- `nextCursor: String?` - Cursor for cursor-based pagination
- `previousCursor: String?` - Previous cursor
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
- `padding` - Padding around list
- `separatorBuilder` - Optional separator builder
- `skeletonizerBuilder` - Custom skeleton loader
- `emptyBuilder` - Custom empty state
- `errorBuilder` - Custom error state
- `appendErrorBuilder` - Custom append error state
- `appendLoaderBuilder` - Custom append loader
- `onPullToRefresh` - Pull-to-refresh callback
- `onRetryInitial` - Retry initial load callback
- `onRetryAppend` - Retry append callback
- `onError` - Error callback
- `onAppendError` - Append error callback

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

Skeleton loading effect widget.

#### `PaginatrixGridSkeletonizer`

Skeleton loading effect for grid layouts.

#### `PageSelector`

Page selection widget for web with styles:
- `PageSelectorStyle.buttons` - Button-based pagination
- `PageSelectorStyle.dropdown` - Dropdown selector
- `PageSelectorStyle.compact` - Compact display

### Meta Parsers

#### `ConfigMetaParser`

Pre-configured parser for common API formats.

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
```

#### `CustomMetaParser`

Flexible parser for custom API structures. Takes a transform function that converts the raw API response into a standard format with 'items' and 'meta' keys:

```dart
CustomMetaParser(
  (data) {
    // Transform raw API response to standard format
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
  itemsKey: 'items',  // Optional, defaults to 'items'
  metaKey: 'meta',    // Optional, defaults to 'meta'
)
```

The transform function receives the raw API response and must return a Map with:
- An 'items' key containing a List of item maps
- A 'meta' key containing a Map that can be parsed by `PageMeta.fromJson()`

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

---

## 📁 Example Projects

The package includes comprehensive examples:

| Example | Description |
|---------|-------------|
| **`list_view`** | Basic ListView pagination with performance monitoring |
| **`grid_view`** | GridView pagination example |
| **`bloc_pattern`** | BLoC pattern integration with custom events |
| **`cubit_direct`** | Direct `PaginatrixCubit` usage with `BlocBuilder` |
| **`search_basic`** | Basic search functionality with debouncing |
| **`search_advanced`** | Advanced search with filters, sorting, and pagination |
| **`web_infinite_scroll`** | Web infinite scroll pagination |
| **`web_page_selector`** | Web page selector pagination |

Run any example:

```bash
cd examples/list_view
flutter run
```

---

## ⚠️ Common Pitfalls

### 1. Not Disposing Controllers

**❌ Wrong:**
```dart
// Controller not disposed - memory leak!
final controller = PaginatrixController<User>(...);
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
  // Missing loadFirstPage() - no data will load!
}
```

**✅ Correct:**
```dart
@override
void initState() {
  super.initState();
  _controller = PaginatrixController<User>(...);
  _controller.loadFirstPage(); // Don't forget!
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
    return ErrorView(error: error, onRetry: onRetry);
  },
)
```

### 5. Race Conditions

The package handles race conditions internally using generation guards. However, avoid:

**❌ Wrong:**
```dart
// Rapid calls without waiting
controller.loadNextPage();
controller.loadNextPage();
controller.loadNextPage();
```

**✅ Correct:**
```dart
// Let the controller handle it - it will prevent duplicate loads
if (controller.canLoadMore && !controller.isLoading) {
  await controller.loadNextPage();
}
```

### 6. Search vs Filter Behavior

- **Search** (`updateSearchTerm`) - Debounced (400ms default), triggers reload after delay
- **Filters** (`updateFilter`, `updateFilters`) - Immediate, triggers reload right away

### 7. Retry Method

The `retry()` method automatically determines whether to retry initial load or append based on current error state. You don't need separate methods.

---

## 🧪 Testing

The package includes comprehensive test coverage. Here's how to test your pagination:

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

See the `test/` directory for more examples including integration tests and performance tests.

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
- 📚 [Full Documentation](./docs/README.md) - Comprehensive guides and API reference

### Support the Project

If you find this package useful, please consider:

- ⭐ **Starring the repository** - Help others discover this package
- 🐛 **Reporting bugs** - Help improve the package
- 💡 **Suggesting features** - Share your ideas
- 📖 **Improving documentation** - Help others learn

### ☕ Buy Me a Coffee

If this package has been helpful to you, consider supporting its development:

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/mohammadihwidi)

### 👨‍💻 Connect

- 💼 [LinkedIn](https://www.linkedin.com/in/mhamad-hwidi-563915237) - Let's connect and discuss Flutter development!

---

**Made with ❤️ for the Flutter community**
