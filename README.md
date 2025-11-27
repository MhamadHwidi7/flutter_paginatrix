# 🚀 Flutter Paginatrix

> **A production-ready, backend-agnostic pagination engine for Flutter**

[![pub points](https://img.shields.io/pub/points/flutter_paginatrix)](https://pub.dev/packages/flutter_paginatrix/score)
[![Pub Version](https://img.shields.io/pub/v/flutter_paginatrix)](https://pub.dev/packages/flutter_paginatrix)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CI/CD](https://github.com/MhamadHwidi7/flutter_paginatrix/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/MhamadHwidi7/flutter_paginatrix/actions/workflows/ci-cd.yml)

**Flutter Paginatrix** is a comprehensive, type-safe pagination library that works with **any backend** (REST, GraphQL, Firebase) and supports multiple pagination strategies. Built with performance, reliability, and developer experience in mind.

---

## 📋 Table of Contents

- [Why Flutter Paginatrix?](#-why-flutter-paginatrix)
- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Core Concepts](#-core-concepts)
- [Widgets & Components](#-widgets--components)
- [Advanced Usage](#-advanced-usage)
- [Examples](#-examples)
- [API Overview](#-api-overview)
- [Best Practices](#-best-practices)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Why Flutter Paginatrix?

### The Problem
Building pagination in Flutter typically requires:
- Managing loading states manually
- Handling errors and retries
- Implementing infinite scroll logic
- Parsing different API response formats
- Managing cache and request cancellation
- Writing boilerplate code for every list

### The Solution
Flutter Paginatrix provides:
- ✅ **Zero boilerplate** - Get started in minutes
- ✅ **Backend-agnostic** - Works with any API structure
- ✅ **Type-safe** - Full generics support with compile-time safety
- ✅ **Production-ready** - 171+ tests, comprehensive error handling
- ✅ **Beautiful UI** - Pre-built widgets with customizable loaders
- ✅ **High performance** - LRU caching, request cancellation, debouncing
- ✅ **Web support** - Includes `PageSelector` for web applications

---

## ✨ Features

### Core Features
- 🎯 **Backend-Agnostic** - Works with any API structure (REST, GraphQL, Firebase)
- 🔄 **Multiple Strategies** - Page-based, offset-based, and cursor-based pagination
- 🎨 **UI Components** - `PaginatrixListView` & `PaginatrixGridView` with Sliver support
- ⚡ **High Performance** - LRU caching, request cancellation, and debouncing
- 🛡️ **Robust** - Race condition protection and automatic retries
- 🔍 **Search & Filter** - Built-in support for searching, filtering, and sorting
- 📱 **Web Support** - Includes `PageSelector` for web apps
- 🎭 **Multiple Loaders** - 5+ beautiful loader animations
- 🎨 **Customizable** - Extensive customization options for all widgets
- 🔄 **Pull-to-Refresh** - Built-in pull-to-refresh support
- 📊 **State Management** - Works with BLoC, Provider, Riverpod, or standalone

### Technical Features
- **Type-Safe** - Full generics support with compile-time type checking
- **Memory Efficient** - Automatic request cancellation and cache management
- **Error Handling** - 6 error types with automatic retry logic
- **Meta Parsers** - Pre-configured parsers for common API formats
- **Custom Parsers** - Support for any custom API response structure
- **Testing** - Comprehensive test suite (171+ tests)
- **Documentation** - Complete API documentation with examples

---

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_paginatrix: ^1.0.3
```

Then run:

```bash
flutter pub get
```

**Note:** Replace `^1.0.3` with the latest version from [pub.dev](https://pub.dev/packages/flutter_paginatrix).

---

## 🚀 Quick Start

### 1. Create a Controller

```dart
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

final controller = PaginatrixController<User>(
  loader: ({page, perPage, query, cancelToken}) async {
    final response = await api.getUsers(
      page: page,
      perPage: perPage,
      search: query?.searchTerm,
    );
    return response.data; // {data: [...], meta: {...}}
  },
  itemDecoder: User.fromJson,
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

### 3. Initialize in Your Widget

```dart
@override
void initState() {
  super.initState();
  controller.loadFirstPage(); // Required
}

@override
void dispose() {
  controller.close(); // Required
  super.dispose();
}
```

**That's it!** The widget automatically handles:
- ✅ Loading states
- ✅ Error states with retry
- ✅ Empty states
- ✅ Infinite scroll pagination
- ✅ Pull-to-refresh
- ✅ Request cancellation

---

## 🧠 Core Concepts

### Pagination Strategies

Flutter Paginatrix supports three pagination strategies:

1. **Page-based** - Uses `page` and `per_page` parameters
   ```dart
   // API: GET /users?page=1&per_page=20
   ```

2. **Offset-based** - Uses `offset` and `limit` parameters
   ```dart
   // API: GET /users?offset=0&limit=20
   ```

3. **Cursor-based** - Uses `cursor` or `token` parameters
   ```dart
   // API: GET /users?cursor=abc123
   ```

### Meta Parsers

Meta parsers extract pagination metadata from API responses:

**Nested Meta Format** (most common):
```json
{
  "data": [...],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 100,
    "last_page": 5
  }
}
```

**Results Format**:
```json
{
  "results": [...],
  "page": 1,
  "per_page": 20,
  "total": 100
}
```

**Custom Format**:
```dart
metaParser: CustomMetaParser((data) {
  return {
    'items': data['products'],
    'meta': {
      'page': data['currentPage'],
      'hasMore': data['hasNext'],
    },
  };
}),
```

### State Management

Flutter Paginatrix provides two APIs:

1. **PaginatrixController** (Recommended) - Simple, clean API
   ```dart
   final controller = PaginatrixController<User>(...);
   ```

2. **PaginatrixCubit** - For BLoC pattern integration
   ```dart
   final cubit = PaginatrixCubit<User>(...);
   ```

Both APIs are functionally equivalent. Use `PaginatrixController` for simplicity, or `PaginatrixCubit` if you're already using BLoC.

---

## 🎨 Widgets & Components

### Main Widgets

#### PaginatrixListView
A ListView widget with built-in pagination support.

```dart
PaginatrixListView<User>(
  controller: controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  separatorBuilder: (context, index) => Divider(), // Optional
  padding: EdgeInsets.all(16), // Optional
  physics: BouncingScrollPhysics(), // Optional
)
```

**Key Features:**
- Infinite scroll pagination
- Pull-to-refresh support
- Customizable loading states
- Error handling with retry
- Empty state handling
- Sliver-based for optimal performance

#### PaginatrixGridView
A GridView widget with built-in pagination support.

```dart
PaginatrixGridView<Product>(
  controller: controller,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  ),
  itemBuilder: (context, product, index) => ProductCard(product: product),
)
```

**Key Features:**
- Same features as PaginatrixListView
- Grid layout support
- Responsive grid delegates
- Custom grid spacing

### Loader Widgets

#### AppendLoader
Displays a loading indicator when loading more items.

```dart
AppendLoader(
  loaderType: LoaderType.bouncingDots, // or wave, rotatingSquares, pulse, skeleton
  message: 'Loading more...',
  color: Colors.blue,
  size: 40.0,
)
```

**Available Loader Types:**
- `LoaderType.bouncingDots` - Animated bouncing dots
- `LoaderType.wave` - Wave animation
- `LoaderType.rotatingSquares` - Rotating squares
- `LoaderType.pulse` - Pulsing circle
- `LoaderType.skeleton` - Skeleton loader
- `LoaderType.traditional` - Traditional CircularProgressIndicator

#### Modern Loaders
Standalone loader widgets for custom use cases:

```dart
BouncingDotsLoader(
  color: Colors.blue,
  size: 8.0,
  message: 'Loading...',
)

WaveLoader(
  color: Colors.blue,
  size: 40.0,
  message: 'Loading...',
)

RotatingSquaresLoader(
  color: Colors.blue,
  size: 30.0,
)

PulseLoader(
  color: Colors.blue,
  size: 50.0,
)

SkeletonLoader(
  color: Colors.blue,
  itemCount: 5,
  message: 'Loading...',
)
```

### Empty State Widgets

#### PaginatrixEmptyView
Base empty state widget (fully customizable):

```dart
PaginatrixEmptyView(
  icon: Icon(Icons.inbox_outlined),
  title: 'No items found',
  description: 'Try adjusting your search or filters',
  action: ElevatedButton(
    onPressed: () => controller.refresh(),
    child: Text('Refresh'),
  ),
)
```

#### Predefined Empty Views

**PaginatrixSearchEmptyView** - For search results:
```dart
PaginatrixSearchEmptyView(
  searchTerm: 'john',
  onClearSearch: () => controller.clearSearch(),
)
```

**PaginatrixNetworkEmptyView** - For network errors:
```dart
PaginatrixNetworkEmptyView(
  onRetry: () => controller.retry(),
)
```

**PaginatrixGenericEmptyView** - General purpose:
```dart
PaginatrixGenericEmptyView(
  message: 'No items available',
  onRefresh: () => controller.refresh(),
)
```

### Error Widgets

#### PaginatrixErrorView
Displays error states with retry functionality:

```dart
PaginatrixErrorView(
  error: error,
  onRetry: () => controller.retry(),
)
```

#### PaginatrixAppendErrorView
Error view for append operations:

```dart
PaginatrixAppendErrorView(
  error: error,
  onRetry: () => controller.loadNextPage(),
)
```

### Web Widgets

#### PageSelector
Page navigation widget for web applications:

```dart
PageSelector(
  currentPage: controller.state.meta?.page ?? 1,
  totalPages: controller.state.meta?.lastPage ?? 1,
  onPageSelected: (page) => controller.loadPage(page),
  style: PageSelectorStyle.buttons, // or dropdown, compact
)
```

**Available Styles:**
- `PageSelectorStyle.buttons` - Page number buttons
- `PageSelectorStyle.dropdown` - Dropdown selector
- `PageSelectorStyle.compact` - Compact button style

### Skeleton Widgets

#### PaginatrixSkeletonizer
Skeleton loader for list items:

```dart
PaginatrixSkeletonizer(
  itemCount: 5,
  itemBuilder: (context, index) => ListTile(
    leading: CircleAvatar(),
    title: Container(height: 16, color: Colors.grey),
    subtitle: Container(height: 12, color: Colors.grey),
  ),
)
```

#### PaginatrixGridSkeletonizer
Skeleton loader for grid items:

```dart
PaginatrixGridSkeletonizer(
  itemCount: 6,
  crossAxisCount: 2,
  itemBuilder: (context, index) => Card(
    child: Column(
      children: [
        Container(height: 100, color: Colors.grey),
        Container(height: 16, color: Colors.grey),
      ],
    ),
  ),
)
```

---

## 🔥 Advanced Usage

### Search with Debouncing

```dart
// Search is automatically debounced (400ms default)
controller.updateSearchTerm('john');

// Custom debounce delay
final controller = PaginatrixController<User>(
  loader: _loadUsers,
  itemDecoder: User.fromJson,
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
  searchDebounceDelay: Duration(milliseconds: 500), // Custom delay
);
```

### Filtering

```dart
// Single filter
controller.updateFilter('status', 'active');

// Multiple filters
controller.updateFilters({
  'status': 'active',
  'role': 'admin',
  'department': 'engineering',
});

// Remove filter
controller.removeFilter('status');

// Clear all filters
controller.clearFilters();
```

### Sorting

```dart
// Sort by field
controller.updateSorting('name', sortDesc: false);

// Sort descending
controller.updateSorting('created_at', sortDesc: true);

// Clear sorting
controller.clearSorting();
```

### Custom Error Handling

```dart
PaginatrixListView<User>(
  controller: controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  errorBuilder: (context, error, onRetry) {
    if (error is NetworkError) {
      return NetworkErrorWidget(
        error: error,
        onRetry: onRetry,
      );
    }
    return PaginatrixErrorView(
      error: error,
      onRetry: onRetry,
    );
  },
)
```

### Custom Empty State

```dart
PaginatrixListView<User>(
  controller: controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  emptyBuilder: (context) {
    return CustomEmptyState(
      icon: Icons.people_outline,
      title: 'No users found',
      description: 'Get started by adding your first user',
      action: ElevatedButton(
        onPressed: () => Navigator.push(...),
        child: Text('Add User'),
      ),
    );
  },
)
```

### Custom Loader

```dart
PaginatrixListView<User>(
  controller: controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  appendLoaderBuilder: (context) {
    return AppendLoader(
      customLoader: MyCustomLoader(),
      message: 'Loading more users...',
    );
  },
)
```

### Pull-to-Refresh

```dart
PaginatrixListView<User>(
  controller: controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  onPullToRefresh: () async {
    await controller.refresh();
  },
)
```

### Manual Pagination

```dart
// Load specific page
await controller.loadPage(3);

// Load next page
await controller.loadNextPage();

// Load previous page
await controller.loadPreviousPage();

// Refresh current page
await controller.refresh();
```

### State Monitoring

```dart
// Listen to state changes
controller.stream.listen((state) {
  if (state.isLoading) {
    print('Loading...');
  } else if (state.hasError) {
    print('Error: ${state.error}');
  } else if (state.hasItems) {
    print('Items: ${state.items.length}');
  }
});

// Check current state
if (controller.state.isLoading) {
  // Show loading indicator
}

if (controller.state.hasError) {
  // Show error message
}
```

### Request Cancellation

The controller automatically cancels previous requests when:
- A new request is made
- The controller is disposed
- Search/filter/sort changes

You can also manually cancel:

```dart
controller.cancelRequests();
```

---

## 💡 Examples

### Basic ListView

```dart
class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
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
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadUsers({
    required int page,
    required int perPage,
    QueryCriteria? query,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      '/users',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (query?.searchTerm != null) 'search': query!.searchTerm,
      },
      cancelToken: cancelToken,
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
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

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
```

### GridView with Search

```dart
class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final PaginatrixController<Product> _controller;

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
    required int page,
    required int perPage,
    QueryCriteria? query,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      '/products',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (query?.searchTerm != null) 'q': query!.searchTerm,
      },
      cancelToken: cancelToken,
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _controller.updateSearchTerm(value);
              },
            ),
          ),
        ),
      ),
      body: PaginatrixGridView<Product>(
        controller: _controller,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, product, index) {
          return ProductCard(product: product);
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

### BLoC Pattern Integration

```dart
// BLoC
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final PaginatrixCubit<User> _paginationCubit;

  UsersBloc() : _paginationCubit = PaginatrixCubit<User>(
    loader: _loadUsers,
    itemDecoder: User.fromJson,
    metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
  ) {
    _paginationCubit.loadFirstPage();
  }

  @override
  UsersState get initialState => UsersState.initial(_paginationCubit.state);

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    // Handle events and update pagination
  }

  @override
  Future<void> close() {
    _paginationCubit.close();
    return super.close();
  }
}

// Widget
BlocBuilder<PaginatrixCubit<User>, PaginationState<User>>(
  bloc: usersBloc.paginationCubit,
  builder: (context, state) {
    return PaginatrixListView<User>(
      cubit: usersBloc.paginationCubit,
      itemBuilder: (context, user, index) => UserTile(user: user),
    );
  },
)
```

For more examples, see the [Examples Directory](./example/README.md).

---

## 📚 API Overview

### PaginatrixController

Main controller for managing pagination state.

**Key Methods:**
- `loadFirstPage()` - Load the first page
- `loadNextPage()` - Load the next page
- `loadPage(int page)` - Load a specific page
- `refresh()` - Refresh the current page
- `updateSearchTerm(String term)` - Update search term (debounced)
- `updateFilter(String key, dynamic value)` - Update a filter
- `updateFilters(Map<String, dynamic> filters)` - Update multiple filters
- `updateSorting(String field, {bool sortDesc})` - Update sorting
- `retry()` - Retry the last failed request
- `close()` - Dispose the controller

**Properties:**
- `state` - Current pagination state
- `stream` - Stream of state changes

### PaginationState

Represents the current state of pagination.

**Properties:**
- `items` - List of current items
- `status` - Current status (loading, loaded, error, etc.)
- `meta` - Pagination metadata
- `error` - Current error (if any)
- `currentQuery` - Current query criteria

**Extension Methods:**
- `isLoading` - Check if loading
- `hasError` - Check if has error
- `hasItems` - Check if has items
- `isEmpty` - Check if empty
- `shouldShowLoading` - Should show loading indicator
- `shouldShowError` - Should show error view
- `shouldShowEmpty` - Should show empty view

### Meta Parsers

**ConfigMetaParser** - Pre-configured parsers:
- `MetaConfig.nestedMeta` - `{data: [], meta: {...}}`
- `MetaConfig.resultsFormat` - `{results: [], page, per_page, ...}`
- `MetaConfig.pageBased` - Page-based format
- `MetaConfig.offsetBased` - Offset-based format

**CustomMetaParser** - Custom parser for any format:
```dart
CustomMetaParser((data) {
  return {
    'items': data['custom_items'],
    'meta': {
      'page': data['current_page'],
      'hasMore': data['has_next'],
    },
  };
})
```

For complete API documentation, see the [API Reference](https://pub.dev/documentation/flutter_paginatrix).

---

## ✅ Best Practices

### 1. Always Dispose Controllers

```dart
@override
void dispose() {
  _controller.close(); // Required!
  super.dispose();
}
```

### 2. Load First Page in initState

```dart
@override
void initState() {
  super.initState();
  _controller.loadFirstPage(); // Required!
}
```

### 3. Match Your API Structure

Use the correct `MetaParser` for your API:

```dart
// For nested meta format
metaParser: ConfigMetaParser(MetaConfig.nestedMeta),

// For results format
metaParser: ConfigMetaParser(MetaConfig.resultsFormat),

// For custom format
metaParser: CustomMetaParser((data) => {...}),
```

### 4. Handle Errors

Always provide error builders:

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

### 5. Use Appropriate Loader Types

Choose loader types that match your app's design:

```dart
AppendLoader(
  loaderType: LoaderType.bouncingDots, // Modern and smooth
  // or
  loaderType: LoaderType.skeleton, // For content preview
)
```

### 6. Optimize Performance

- Use `keyBuilder` for stable item keys:
  ```dart
  PaginatrixListView<User>(
    controller: _controller,
    keyBuilder: (user, index) => user.id, // Stable keys
    itemBuilder: (context, user, index) => UserTile(user: user),
  )
  ```

- Adjust `prefetchThreshold` for better UX:
  ```dart
  PaginatrixListView<User>(
    controller: _controller,
    prefetchThreshold: 5, // Load next page when 5 items from end
    itemBuilder: (context, user, index) => UserTile(user: user),
  )
  ```

### 7. Search vs Filters

- **Search** (`updateSearchTerm`): Debounced (400ms), for text search
- **Filters** (`updateFilter`): Immediate, for structured filters

```dart
// Search - debounced
_controller.updateSearchTerm('john');

// Filters - immediate
_controller.updateFilter('status', 'active');
```

### 8. Use Type-Safe Decoders

Always use type-safe decoders:

```dart
itemDecoder: User.fromJson, // ✅ Type-safe
// Not: itemDecoder: (json) => User.fromJson(json), // ❌ Less type-safe
```

---

## ⚠️ Troubleshooting

### Common Issues

#### 1. Items Not Loading

**Problem:** List is empty even though API returns data.

**Solutions:**
- Check that `loadFirstPage()` is called in `initState()`
- Verify `metaParser` matches your API structure
- Check that `itemDecoder` correctly parses items
- Ensure API response format matches expected structure

#### 2. Infinite Loading

**Problem:** Loader keeps spinning, never shows items.

**Solutions:**
- Check API response format matches `metaParser` configuration
- Verify `hasMore` or `lastPage` is correctly parsed
- Check for errors in console/logs
- Ensure `itemDecoder` returns correct type

#### 3. Errors Not Showing

**Problem:** Errors occur but error view doesn't appear.

**Solutions:**
- Provide `errorBuilder` in widget:
  ```dart
  PaginatrixListView<User>(
    controller: _controller,
    errorBuilder: (context, error, onRetry) {
      return PaginatrixErrorView(error: error, onRetry: onRetry);
    },
  )
  ```

#### 4. Search Not Working

**Problem:** Search doesn't trigger reload.

**Solutions:**
- Ensure search term is included in loader function:
  ```dart
  loader: ({page, perPage, query, cancelToken}) async {
    final params = {
      'page': page,
      'per_page': perPage,
      if (query?.searchTerm != null) 'search': query!.searchTerm,
    };
    // ...
  }
  ```

#### 5. Filters Not Applied

**Problem:** Filters don't affect results.

**Solutions:**
- Include filters in loader function:
  ```dart
  loader: ({page, perPage, query, cancelToken}) async {
    final params = {
      'page': page,
      'per_page': perPage,
      ...query?.filters ?? {}, // Include filters
    };
    // ...
  }
  ```

### Debugging Tips

1. **Check State:**
   ```dart
   print('State: ${controller.state}');
   print('Items: ${controller.state.items.length}');
   print('Status: ${controller.state.status}');
   print('Error: ${controller.state.error}');
   ```

2. **Monitor Stream:**
   ```dart
   controller.stream.listen((state) {
     print('State changed: $state');
   });
   ```

3. **Verify API Response:**
   ```dart
   loader: ({page, perPage, query, cancelToken}) async {
     final response = await api.getData(...);
     print('API Response: $response'); // Debug
     return response.data;
   }
   ```

For more troubleshooting help, see the [Troubleshooting Guide](./doc/troubleshooting/common-issues.md) or [FAQ](./doc/troubleshooting/faq.md).

---

## 📖 Documentation

For detailed guides and advanced usage:

- **[📚 Full Documentation](./doc/README.md)** - Complete guides and API reference
- **[💡 Examples](./example/README.md)** - Working examples for all features
- **[🔧 Troubleshooting](./doc/troubleshooting/common-issues.md)** - Common issues and solutions
- **[❓ FAQ](./doc/troubleshooting/faq.md)** - Frequently asked questions

### Quick Links

- [Getting Started](./doc/getting-started/quick-start.md) - Installation and setup
- [Core Concepts](./doc/getting-started/core-concepts.md) - Understanding the architecture
- [Advanced Usage](./doc/guides/advanced-usage.md) - Search, filtering, sorting
- [Error Handling](./doc/guides/error-handling.md) - Comprehensive error handling
- [API Reference](https://pub.dev/documentation/flutter_paginatrix) - Detailed API documentation

---

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Reporting Issues

If you find a bug or have a feature request, please open an issue on [GitHub](https://github.com/MhamadHwidi7/flutter_paginatrix/issues).

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Built with ❤️ for the Flutter community
- Inspired by the need for a simple, flexible pagination solution
- Thanks to all contributors and users

---

**Made with ❤️ for the Flutter community**

For questions, issues, or contributions, visit the [GitHub repository](https://github.com/MhamadHwidi7/flutter_paginatrix).
