# 🚀 Flutter Paginatrix

[![pub package](https://img.shields.io/pub/v/flutter_paginatrix.svg)](https://pub.dev/packages/flutter_paginatrix)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.22+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.2+-blue.svg)](https://dart.dev)

**The most flexible, backend-agnostic pagination engine for Flutter applications.**

Flutter Paginatrix provides everything you need for pagination with clean architecture, comprehensive error handling, and beautiful UI components built with Slivers for optimal performance. It supports multiple pagination strategies (page-based, offset-based, cursor-based) and works seamlessly with any API structure.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Getting Started](#-getting-started)
- [Basic Usage](#-basic-usage)
- [Advanced Usage](#-advanced-usage)
- [API Overview](#-api-overview)
- [Example Projects](#-example-projects)
- [Common Pitfalls](#-common-pitfalls)
- [Configuration](#-configuration)
- [Testing](#-testing)
- [License](#-license)
- [Support & Links](#-support--links)

---

## 🎯 Overview

Flutter Paginatrix is a complete pagination solution that handles data loading, state management, error recovery, and UI rendering. It uses `flutter_bloc` under the hood for reactive state management but provides a clean API through `PaginatrixController` that doesn't require you to import `flutter_bloc` directly.

### Architecture Principles

- **Type-Safe** - Full generics support with immutable data structures using `freezed`
- **Backend-Agnostic** - Flexible meta parsers that work with any API format
- **Performance-Optimized** - Sliver-based architecture for smooth scrolling
- **Clean Architecture** - Clear separation of concerns (Core/Data/Presentation)
- **Comprehensive Error Handling** - 6 error types with automatic recovery and retry
- **Zero Boilerplate** - Minimal configuration required

### Why Flutter Paginatrix?

Unlike typical infinite scroll solutions, Flutter Paginatrix provides:

- ✅ **Single Loader Function** - One function handles all pagination scenarios
- ✅ **Generation Guards** - Prevents stale responses and race conditions
- ✅ **Request Cancellation** - Automatic cleanup of in-flight requests
- ✅ **Multiple Pagination Strategies** - Page-based, offset-based, and cursor-based
- ✅ **Built-in Debouncing** - Prevents excessive API calls during search
- ✅ **Comprehensive Test Suite** - 171+ tests with full coverage

---

## ✨ Features

### Core Features

- ✅ **Backend Agnostic** - Works with any API structure (page/perPage, offset/limit, cursor-based)
- ✅ **Single Loader Function** - One function handles all pagination scenarios
- ✅ **Type-Safe** - Full generics support with immutable data structures using `freezed`
- ✅ **Reactive State Management** - Built on `flutter_bloc` with clean public API
- ✅ **Performance Optimized** - Sliver-based architecture for smooth scrolling
- ✅ **Comprehensive Error Handling** - 6 error types with automatic recovery and retry
- ✅ **Beautiful UI Components** - Pre-built widgets with modern loading animations
- ✅ **Request Cancellation** - Automatic cleanup of in-flight requests
- ✅ **Stale Response Prevention** - Generation-based guards prevent race conditions
- ✅ **Multiple Pagination Strategies** - Page-based, offset-based, and cursor-based pagination

### Advanced Features

- ✅ **Flexible Meta Parsers** - Pre-configured and custom parsers for any API format
- ✅ **Search & Filtering** - Built-in support for search terms, filters, and sorting
- ✅ **Pull-to-Refresh** - Built-in pull-to-refresh functionality
- ✅ **Skeleton Loading** - Beautiful skeleton loading effects
- ✅ **Empty States** - Pre-built empty state widgets for various scenarios
- ✅ **Web Support** - Page selector widgets optimized for web applications
- ✅ **Exponential Backoff** - Automatic retry with exponential backoff
- ✅ **Debouncing** - Configurable debouncing for search and refresh operations
- ✅ **Comprehensive Test Suite** - 171+ tests with full coverage

---

## 🚀 Getting Started

### Installation

Add `flutter_paginatrix` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_paginatrix: ^1.0.0
  dio: ^5.4.0  # Optional - Only needed if using Dio for HTTP requests
```

Then run:

```bash
flutter pub get
```

### Requirements

- **Flutter SDK**: `>=3.22.0`
- **Dart SDK**: `>=3.2.0 <4.0.0`

---

## 🔧 Basic Usage

### Simple Example with PaginatrixController

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

  @override
  void initState() {
    super.initState();
    
    _controller = PaginatrixController<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    
    // Load first page
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
    QueryCriteria? query,
  }) async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.example.com/users',
      queryParameters: {
        'page': page ?? 1,
        'per_page': perPage ?? 20,
        if (query?.searchTerm.isNotEmpty ?? false)
          'search': query!.searchTerm,
        ...?query?.filters,
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
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
      ),
    );
  }
}
```

### Using PaginatrixCubit (Advanced)

If you prefer to use `PaginatrixCubit` directly with `BlocProvider`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

final cubit = PaginatrixCubit<User>(
  loader: _loadUsers,
  itemDecoder: User.fromJson,
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
);

// In widget tree
BlocProvider(
  create: (_) => cubit..loadFirstPage(),
  child: PaginatrixListView<User>(
    cubit: cubit,
    itemBuilder: (context, user, index) => UserTile(user: user),
  ),
)
```

---

## 📚 Advanced Usage

### Search and Filtering

```dart
// Update search term (debounced automatically)
_controller.updateSearchTerm('john');

// Add or update a single filter
_controller.updateFilter('status', 'active');

// Add multiple filters at once
_controller.updateFilters({
  'status': 'active',
  'role': 'admin',
  'minPrice': 10.0,
});

// Remove a filter
_controller.updateFilter('status', null);

// Clear all filters
_controller.clearFilters();

// Add sorting
_controller.updateSorting('name', sortDesc: false);

// Clear sorting
_controller.updateSorting(null);

// Clear all query criteria (search, filters, sorting)
_controller.clearAllQuery();
```

### Custom Meta Parser

For APIs that don't match standard formats:

```dart
final parser = CustomMetaParser((data) {
  final items = data['results'] as List;
  final meta = PageMeta(
    page: data['currentPage'] as int,
    perPage: data['pageSize'] as int,
    total: data['totalCount'] as int,
    hasMore: data['hasNext'] as bool,
  );
  return {
    'items': items,
    'meta': meta.toJson(),
  };
});

final controller = PaginatrixController<User>(
  loader: _loadUsers,
  itemDecoder: User.fromJson,
  metaParser: parser,
);
```

### Error Handling

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
  onRetryInitial: () {
    _controller.retry(); // Automatically retries initial load
  },
  appendErrorBuilder: (context, error, onRetry) {
    return PaginatrixAppendErrorView(
      error: error,
      onRetry: onRetry,
    );
  },
  onRetryAppend: () {
    _controller.loadNextPage(); // Retry loading next page
  },
)
```

### Custom Loaders and Empty States

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  appendLoaderBuilder: (context) => AppendLoader(
    loaderType: LoaderType.pulse,
    message: 'Loading more...',
  ),
  emptyBuilder: (context) => PaginatrixSearchEmptyView(
    message: 'No users found',
  ),
  skeletonizerBuilder: (context) => PaginationSkeletonizer(
    child: ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => UserSkeletonCard(),
    ),
  ),
)
```

### Grid View

```dart
PaginatrixGridView<User>(
  controller: _controller,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  ),
  itemBuilder: (context, user, index) => UserCard(user: user),
)
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

### Web Page Selector

```dart
// For web applications with page-based pagination
PageSelector(
  currentPage: _controller.state.meta?.page ?? 1,
  totalPages: _controller.state.meta?.lastPage ?? 1,
  onPageSelected: (page) {
    // Navigate to specific page
    _controller.loadFirstPage(); // Will load the requested page
  },
  style: PageSelectorStyle.buttons, // or .dropdown, .compact
)
```

### Retry with Exponential Backoff

The `retry()` method automatically implements exponential backoff:

```dart
// Automatically retries with exponential backoff
// 1st retry: waits 500ms
// 2nd retry: waits 1000ms
// 3rd retry: waits 2000ms
// etc.
await _controller.retry();
```

---

## 📦 API Overview

### Core Classes

#### `PaginatrixController<T>`

Main controller for pagination. Provides a clean API without requiring `flutter_bloc` imports. This is a type alias for `PaginatrixCubit<T>`.

**Key Methods:**

- `loadFirstPage()` - Load the first page of data
- `loadNextPage()` - Load the next page (appends to existing items)
- `refresh()` - Refresh current data (reloads first page)
- `updateSearchTerm(String term)` - Update search term (debounced)
- `updateFilter(String key, dynamic value)` - Add or update a filter
- `updateFilters(Map<String, dynamic> filters)` - Update multiple filters
- `clearFilters()` - Clear all filters
- `updateSorting(String? sortBy, {bool sortDesc})` - Update sorting
- `clearAllQuery()` - Clear all search, filters, and sorting
- `retry()` - Retry failed operation with exponential backoff (automatically determines initial or append retry)
- `cancel()` - Cancel in-flight requests
- `clear()` - Clear all data and reset to initial state
- `close()` - Dispose and clean up resources

**Properties:**

- `state: PaginationState<T>` - Current pagination state (read-only)
- `canLoadMore: bool` - Whether more data can be loaded
- `isLoading: bool` - Whether a load operation is in progress
- `hasData: bool` - Whether the controller has successfully loaded data
- `hasError: bool` - Whether the initial load encountered an error
- `hasAppendError: bool` - Whether loading the next page encountered an error

#### `PaginatrixCubit<T>`

Internal implementation using `Cubit`. Use `PaginatrixController` for most cases. Can be used directly with `BlocProvider` for advanced scenarios.

#### `PaginationState<T>`

Immutable state object containing:

- `status: PaginationStatus` - Current pagination status
- `items: List<T>` - List of loaded items
- `meta: PageMeta?` - Pagination metadata (page, total, etc.)
- `error: PaginationError?` - Current error (if any)
- `appendError: PaginationError?` - Append error (non-blocking)
- `query: QueryCriteria?` - Current search/filter criteria
- `isStale: bool` - Whether data is stale and needs refresh
- `lastLoadedAt: DateTime?` - Last successful load timestamp

#### `PageMeta`

Pagination metadata containing:

- `page: int?` - Current page number
- `perPage: int?` - Items per page
- `total: int?` - Total number of items
- `lastPage: int?` - Last page number
- `hasMore: bool` - Whether more pages are available
- `nextCursor: String?` - Cursor for cursor-based pagination
- `previousCursor: String?` - Previous cursor
- `offset: int?` / `limit: int?` - For offset-based pagination

#### `QueryCriteria`

Immutable value object for search and filter criteria:

- `searchTerm: String` - Search term for text-based searching
- `filters: Map<String, dynamic>` - Filter key-value pairs
- `sortBy: String?` - Field name to sort by
- `sortDesc: bool` - Whether to sort in descending order

**Methods:**

- `withFilter(String key, dynamic value)` - Add or update a filter
- `withFilters(Map<String, dynamic> filters)` - Add or update multiple filters
- `removeFilter(String key)` - Remove a specific filter
- `clearSearch()` - Clear search term
- `clearFilters()` - Clear all filters
- `clearSorting()` - Clear sorting
- `clearAll()` - Clear everything

### Widgets

#### `PaginatrixListView<T>`

ListView widget with built-in pagination support.

**Key Parameters:**

- `controller` or `cubit` - Pagination controller (required, one of them)
- `itemBuilder` - Function to build each item (required)
- `keyBuilder` - Optional function to generate keys for items
- `prefetchThreshold` - Items from end to trigger next page load
- `padding` - Padding around the list
- `physics` - Scroll physics behavior
- `shrinkWrap` - Whether the list should shrink-wrap its contents
- `scrollDirection` - Scroll direction (vertical or horizontal)
- `reverse` - Whether to reverse the scroll direction
- `separatorBuilder` - Optional builder for separators between items
- `skeletonizerBuilder` - Custom skeleton loader for initial state
- `emptyBuilder` - Custom widget for empty state
- `errorBuilder` - Custom widget for error state
- `appendErrorBuilder` - Custom widget for append error state
- `appendLoaderBuilder` - Custom widget for loading more indicator
- `onPullToRefresh` - Callback when user pulls to refresh
- `onRetryInitial` - Callback for retrying initial load
- `onRetryAppend` - Callback for retrying append operation
- `endOfListMessage` - Custom message when no more items are available

#### `PaginatrixGridView<T>`

GridView widget with built-in pagination support.

**Key Parameters:**

- `controller` or `cubit` - Pagination controller (required, one of them)
- `itemBuilder` - Function to build each item (required)
- `gridDelegate` - Grid layout configuration (required)
- Same optional parameters as `PaginatrixListView`

#### `AppendLoader`

Loading indicator widget with multiple animation types.

**Loader Types:**

- `LoaderType.bouncingDots` - Bouncing dots animation
- `LoaderType.wave` - Wave animation
- `LoaderType.rotatingSquares` - Rotating squares animation
- `LoaderType.pulse` - Pulse animation
- `LoaderType.skeleton` - Skeleton loading effect
- `LoaderType.traditional` - Traditional spinner

#### `PaginatrixErrorView`

Error display widget with retry functionality.

#### `PaginatrixAppendErrorView`

Inline error view for append failures with retry functionality.

#### `PaginatrixEmptyView`

Base empty state widget. Pre-built variants:

- `PaginatrixGenericEmptyView` - Generic empty state
- `PaginatrixSearchEmptyView` - Search empty state
- `PaginatrixNetworkEmptyView` - Network empty state

#### `PaginationSkeletonizer`

Skeleton loading effect widget using the `skeletonizer` package.

#### `PageSelector`

Page selection widget for web applications with multiple display styles:

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

#### `CustomMetaParser`

Flexible parser for custom API response structures. Takes a function that transforms the raw API response into the expected format.

### Enums

#### `PaginationStatus`

Union type for pagination status:

- `initial()` - Initial state
- `loading()` - Loading data
- `success()` - Successfully loaded
- `empty()` - Empty state (no data)
- `error()` - Error occurred
- `refreshing()` - Refreshing data
- `appending()` - Loading next page
- `appendError()` - Error during append

#### `PaginationError`

Union type for different error types:

- `network()` - Network errors (connection issues, timeouts, HTTP errors)
- `parse()` - Parse errors (invalid response format, missing keys)
- `cancelled()` - Cancellation errors
- `rateLimited()` - Rate limit errors
- `circuitBreaker()` - Circuit breaker errors
- `unknown()` - Unknown errors

---

## ⚙️ Configuration

### PaginationOptions

Configure pagination behavior:

```dart
final options = PaginationOptions(
  defaultPageSize: 20,
  maxPageSize: 100,
  requestTimeout: Duration(seconds: 30),
  maxRetries: 5,
  initialBackoff: Duration(milliseconds: 500),
  retryResetTimeout: Duration(seconds: 60),
  refreshDebounceDuration: Duration(milliseconds: 300),
  searchDebounceDuration: Duration(milliseconds: 400),
  enableDebugLogging: false,
  defaultPrefetchThreshold: 3,
  defaultPrefetchThresholdPixels: 300.0,
);

final controller = PaginatrixController<User>(
  loader: _loadUsers,
  itemDecoder: User.fromJson,
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
  options: options,
);
```

### MetaConfig

Configure meta parser paths:

```dart
final config = MetaConfig(
  itemsPath: 'data',
  pagePath: 'meta.current_page',
  perPagePath: 'meta.per_page',
  totalPath: 'meta.total',
  lastPagePath: 'meta.last_page',
  hasMorePath: 'meta.has_more',
  nextCursorPath: 'meta.next_cursor',
  previousCursorPath: 'meta.previous_cursor',
  offsetPath: 'meta.offset',
  limitPath: 'meta.limit',
);
```

---

## 📁 Example Projects

The package includes several example applications demonstrating different use cases:

- **`list_view`** - Basic ListView pagination with performance monitoring
- **`grid_view`** - GridView pagination example
- **`bloc_pattern`** - BLoC pattern integration with custom events
- **`cubit_direct`** - Direct PaginatrixCubit usage
- **`search_basic`** - Basic search functionality with pagination
- **`search_advanced`** - Advanced search with filters, sorting, and pagination
- **`web_infinite_scroll`** - Web infinite scroll pagination
- **`web_page_selector`** - Web page selector pagination

Run any example:

```bash
cd examples/list_view
flutter run
```

---

## ❗ Common Pitfalls

### 1. Not Disposing Controllers

Always dispose controllers to prevent memory leaks:

```dart
@override
void dispose() {
  _controller.close(); // or _controller.dispose() if using cubit directly
  super.dispose();
}
```

### 2. Forgetting to Call loadFirstPage()

The controller doesn't automatically load data. You must call `loadFirstPage()`:

```dart
@override
void initState() {
  super.initState();
  _controller = PaginatrixController<User>(...);
  _controller.loadFirstPage(); // Don't forget this!
}
```

### 3. Incorrect Meta Parser Configuration

Ensure your `MetaConfig` paths match your API response structure. Use `CustomMetaParser` for complex structures.

### 4. Not Handling Errors

Always provide error builders or handle errors in your UI:

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  errorBuilder: (context, error, onRetry) {
    return ErrorWidget(error.message);
  },
)
```

### 5. Race Conditions

The package handles race conditions internally using generation guards. However, avoid calling `loadNextPage()` multiple times rapidly - the controller will handle this automatically.

### 6. Search Debouncing

Search uses debouncing by default (400ms). If you need immediate search, set `searchDebounceDuration: Duration.zero` in `PaginationOptions`.

### 7. Filter vs Search Behavior

- **Search** (`updateSearchTerm`) - Debounced, triggers reload after delay
- **Filters** (`updateFilter`, `updateFilters`) - Immediate, triggers reload right away

### 8. Retry Method Behavior

The `retry()` method automatically determines whether to retry the initial load or append operation based on the current error state. You don't need separate `retryInitial()` and `retryAppend()` methods.

---

## 🧪 Testing

The package includes comprehensive test coverage. Here's how to test your pagination:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  test('should load first page', () async {
    final cubit = PaginatrixCubit<User>(
      loader: mockLoader,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );

    await cubit.loadFirstPage();

    expect(cubit.state.items.length, greaterThan(0));
    expect(cubit.state.status, PaginationStatus.success());
  });

  test('should handle search', () async {
    final cubit = PaginatrixCubit<User>(...);
    await cubit.loadFirstPage();

    cubit.updateSearchTerm('john');
    await Future.delayed(Duration(milliseconds: 500)); // Wait for debounce

    expect(cubit.state.currentQuery.searchTerm, equals('john'));
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

- [Pub.dev Package](https://pub.dev/packages/flutter_paginatrix)
- [GitHub Repository](https://github.com/MhamadHwidi7/flutter_paginatrix)
- [Issue Tracker](https://github.com/MhamadHwidi7/flutter_paginatrix/issues)
- [Documentation](https://pub.dev/documentation/flutter_paginatrix)
- [📚 Full Documentation](./docs/README.md) - Comprehensive guides and API reference

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

- [LinkedIn](https://www.linkedin.com/in/mhamad-hwidi-563915237) - Let's connect and discuss Flutter development!

---

**Made with ❤️ for the Flutter community**
