# 🚀 Flutter Paginatrix

> **The most flexible, backend-agnostic pagination engine for Flutter**

[![pub package](https://img.shields.io/pub/v/flutter_paginatrix.svg)](https://pub.dev/packages/flutter_paginatrix)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.22.0-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.2.0-blue.svg)](https://dart.dev)

A production-ready, type-safe pagination library that works with **any backend API**. Built with clean architecture, comprehensive error handling, and beautiful UI components.

---

## ✨ Features

### Core Capabilities
- 🎯 **Backend-Agnostic** - Works with any API format (REST, GraphQL, custom)
- 🔄 **Multiple Pagination Strategies** - Page-based, offset-based, and cursor-based
- 🎨 **Beautiful UI Components** - Sliver-based ListView and GridView with skeleton loaders
- 🔒 **Type-Safe** - Full generics support with compile-time safety
- 🧩 **Dependency Injection** - Use any DI solution (`get_it`, `provider`, `riverpod`) or create instances directly

### Performance & Reliability
- ⚡ **Performance Optimized** - LRU caching for metadata, debouncing, efficient Sliver rendering
- 🛡️ **Race Condition Protection** - Generation guards prevent stale responses from corrupting state
- 🚫 **Request Cancellation** - Automatic cleanup of in-flight requests with operation coordination
- 🔁 **Automatic Retry** - Exponential backoff retry (1s → 2s → 4s → 8s) with configurable limits
- ⏱️ **Smart Debouncing** - Search (400ms) and refresh (300ms) debouncing to prevent API spam
- 💾 **Metadata Caching** - LRU cache prevents redundant parsing of pagination metadata

### Developer Experience
- 🔍 **Search & Filtering** - Built-in support for search, filters, and sorting with type-safe access
- 🎭 **6 Error Types** - Network, parse, cancelled, rate-limited, circuit breaker, unknown
- 📱 **Web Support** - Page selector widget with multiple styles (buttons, dropdown, compact)
- 🎨 **Customizable UI** - Custom builders for empty states, errors, loaders, and skeletons
- 🧪 **Well-Tested** - 211+ tests covering unit, integration, and widget scenarios
- 📚 **Comprehensive Docs** - Extensive documentation, examples, and guides

---

## 🎯 Why Flutter Paginatrix?

Unlike typical infinite scroll solutions, Flutter Paginatrix provides:

- **Controller-Based API** - Clean, declarative state management using Cubit (flutter_bloc)
- **Zero Boilerplate** - Minimal configuration required, sensible defaults
- **Production-Ready** - Battle-tested with comprehensive error handling and race condition protection
- **Flexible Meta Parsing** - Configurable parsers for any API response structure
- **Clean Architecture** - Well-organized codebase following SOLID principles
- **No DI Required** - Use any DI solution (`get_it`, `provider`, `riverpod`) or create instances directly
- **Performance First** - LRU caching, debouncing, efficient Sliver rendering, request cancellation
- **Developer Friendly** - Type-safe, well-documented, extensive examples, comprehensive test suite

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
    final searchTerm = query?.searchTerm;
    final response = await dio.get('/users', queryParameters: {
      'page': page,
      'per_page': perPage,
      if (searchTerm != null && searchTerm.isNotEmpty) 'q': searchTerm,
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
    initialBackoff: Duration(milliseconds: 500),
    retryResetTimeout: Duration(seconds: 60),
    refreshDebounceDuration: Duration(milliseconds: 300),
    searchDebounceDuration: Duration(milliseconds: 400),
    defaultPrefetchThreshold: 3,
    defaultPrefetchThresholdPixels: 300.0,
    enableDebugLogging: false,
  ),
);
```

### Dependency Injection

**Important:** The core pagination classes (`PaginatrixController`, `PaginatrixCubit`, etc.) do **NOT** require any specific DI solution. They accept dependencies through constructors or parameters, allowing you to use any DI approach you prefer.

You can use your preferred DI solution like `get_it`, `provider`, or `riverpod`, or simply create instances directly.

#### Using `get_it` Package

```dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

// Setup (in main() or app initialization)
void setupDependencies() {
  getIt.registerSingleton<Dio>(Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
  )));
  
  getIt.registerSingleton<MetaParser>(
    ConfigMetaParser(MetaConfig.nestedMeta),
  );
}

// Use in your code
class UsersRepository {
  Future<Map<String, dynamic>> loadUsers({...}) async {
    final dio = getIt<Dio>();
    // ... use dio
  }
}

// Create controller
final controller = PaginatrixController<User>(
  loader: getIt<UsersRepository>().loadUsers,
  itemDecoder: (json) => User.fromJson(json),
  metaParser: getIt<MetaParser>(),
);
```

#### Using `provider` Package

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Create providers
class DioProvider extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
  Dio get dio => _dio;
}

// In your app
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => DioProvider()),
    Provider(create: (_) => ConfigMetaParser(MetaConfig.nestedMeta)),
  ],
  child: MyApp(),
)

// Use in widget
final dio = Provider.of<DioProvider>(context).dio;
final metaParser = Provider.of<MetaParser>(context);
```

**When to use which:**
- **get_it** - Complex apps, need singleton/lazy/factory patterns, async initialization
- **provider/riverpod** - Flutter-first, reactive state management, widget tree integration
- **Direct instantiation** - Simple projects, no DI needed

### Advanced Performance Features

#### LRU Metadata Caching

The package automatically caches parsed pagination metadata using an LRU cache to prevent redundant parsing:

```dart
// Metadata is automatically cached and reused
// Cache size is optimized for typical pagination responses
// Cache keys are based on canonical metadata structure (not items array)
```

#### Smart Debouncing

Prevents excessive API calls:

```dart
// Search debouncing (400ms default)
_controller.updateSearchTerm('john'); // Waits 400ms before triggering API call
_controller.updateSearchTerm('joh');  // Cancels previous, waits another 400ms
_controller.updateSearchTerm('j');    // Cancels previous, waits another 400ms
// Only the last call executes after user stops typing

// Refresh debouncing (300ms default)
_controller.refresh(); // Waits 300ms before executing
_controller.refresh(); // Cancels previous, waits another 300ms
// Prevents rapid successive refresh calls
```

#### Exponential Backoff Retry

Automatic retry with exponential backoff:

```dart
// Retry attempts with increasing delays:
// 1st retry: 1000ms delay (500ms * 2 * 2^0)
// 2nd retry: 2000ms delay (500ms * 2 * 2^1)
// 3rd retry: 4000ms delay (500ms * 2 * 2^2)
// 4th retry: 8000ms delay (500ms * 2 * 2^3)
// 5th retry: 16000ms delay (500ms * 2 * 2^4)
// Max retries: 5 (configurable)

await controller.retry(); // Automatically retries with backoff
```

#### Operation Coordination

Prevents race conditions by coordinating conflicting operations:

```dart
// Refresh cancels append (refresh replaces data)
controller.loadNextPage(); // Append operation starts
controller.refresh();      // Cancels append, starts refresh

// First page load cancels both refresh and append
controller.refresh();      // Refresh operation starts
controller.loadFirstPage(); // Cancels refresh, starts first page load
```

#### Generation Guards

Prevents stale responses from corrupting state:

```dart
// Each request gets a generation number
// Only responses matching current generation update state
// Stale responses (from cancelled requests) are automatically dropped
// This ensures data integrity even with rapid user interactions
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

Skeleton loading effect widget with customizable item builders. Automatically handles bounded constraints for sliver widgets.

#### `PaginatrixGridSkeletonizer`

Skeleton loading effect for grid layouts with aspect ratio constraints.

#### `PageSelector`

Page selection widget for web with styles:
- `PageSelectorStyle.buttons` - Button-based pagination
- `PageSelectorStyle.dropdown` - Dropdown selector
- `PageSelectorStyle.compact` - Compact display

### Meta Parsers

Meta parsers extract pagination metadata from API responses. The package includes two powerful parsers:

#### `ConfigMetaParser`

Pre-configured parser for common API formats with **automatic caching** to prevent redundant parsing.

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

**Features:**
- ✅ Automatic LRU caching of parsed metadata
- ✅ Path-based extraction (supports nested paths like `meta.current_page`)
- ✅ Type-safe field extraction
- ✅ Automatic pagination type detection (page-based, cursor-based, offset-based)

#### `CustomMetaParser`

Flexible parser for custom API structures. Takes a transform function that converts the raw API response into a standard format:

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

**When to use:**
- API response structure doesn't match any pre-configured format
- Need complex transformations or data validation
- Working with GraphQL or other non-standard formats

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

#### `LoaderType`

Types of modern loaders available for pagination UI. Used with `AppendLoader` widget to display loading indicators:

- `bouncingDots` - Bouncing dots animation
  - Animated dots that bounce up and down
  - Modern, playful loading indicator

- `wave` - Wave animation
  - Smooth wave-like animation
  - Elegant and fluid motion

- `rotatingSquares` - Rotating squares animation
  - Squares that rotate in a pattern
  - Geometric and structured appearance

- `pulse` - Pulse animation
  - Pulsing/breathing effect
  - Subtle and smooth animation

- `skeleton` - Skeleton loading effect
  - Shimmer/skeleton effect
  - Mimics content structure while loading

- `traditional` - Traditional spinner
  - Classic circular spinner
  - Standard loading indicator

**Usage Example:**
```dart
PaginatrixListView<User>(
  controller: controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  appendLoaderBuilder: (context) => AppendLoader(
    loaderType: LoaderType.bouncingDots, // Choose your loader type
  ),
)
```

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

### 8. Dependency Injection

**❌ Wrong:**
```dart
// Creating new instances everywhere
final dio1 = Dio();
final dio2 = Dio(); // Different instance!
```

**✅ Correct:**
```dart
// Use DI for shared dependencies (example with get_it)
final getIt = GetIt.instance;
getIt.registerSingleton<Dio>(Dio());
final dio = getIt<Dio>(); // Same instance everywhere
```

### 9. Performance Optimization

**❌ Wrong:**
```dart
// No keys, no optimizations
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

**✅ Correct:**
```dart
// Use keys and optimizations for better performance
PaginatrixListView<User>(
  controller: _controller,
  keyBuilder: (user, index) => user.id.toString(),
  addAutomaticKeepAlives: true,
  addRepaintBoundaries: true,
  cacheExtent: 250,
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

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

### 👨‍💻 Connect

- 💼 [LinkedIn](https://www.linkedin.com/in/mhamad-hwidi-563915237) - Let's connect and discuss Flutter development!

---

**Made with ❤️ for the Flutter community**
