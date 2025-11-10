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
- ✅ **Minimal Dependencies** - Only requires flutter_bloc for state management
- ✅ **171+ Tests** - Comprehensive test coverage

---

## 📦 Installation

Add `flutter_paginatrix` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_paginatrix: ^1.0.0
  flutter_bloc: ^8.1.6  # Required - PaginatedCubit extends Cubit from flutter_bloc
  dio: ^5.4.0  # Optional - Only needed if using Dio for HTTP requests
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start

### Basic Usage with PaginatedCubit

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
      create: (context) => PaginatedCubit<User>(
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
      body: BlocBuilder<PaginatedCubit<User>, PaginationState<User>>(
        builder: (context, state) {
          return PaginatrixListView<User>(
            cubit: context.read<PaginatedCubit<User>>(),
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
            onPullToRefresh: () => context.read<PaginatedCubit<User>>().refresh(),
          );
        },
      ),
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

The cubit automatically:
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
PaginatrixListView<Product>(
  cubit: cubit,
  itemBuilder: (context, product, index) {
    return ProductCard(product: product);
  },
  appendLoaderBuilder: (context) => const AppendLoader(
    loaderType: LoaderType.pulse,
    message: 'Loading more products...',
  ),
  onPullToRefresh: () => cubit.refresh(),
)
```

### Grid View with Pagination

```dart
PaginatrixGridView<Product>(
  cubit: cubit,
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

### Page Selection (Web)

```dart
BlocBuilder<PaginatedCubit<Product>, PaginationState<Product>>(
  builder: (context, state) {
    return PageSelector(
      currentPage: state.meta?.page ?? 1,
      totalPages: state.meta?.lastPage ?? 1,
      onPageSelected: (page) {
        // Navigate to specific page
        cubit.loadFirstPage(); // Then load the selected page
      },
      style: PageSelectorStyle.buttons,
      showFirstLast: true,
      showPreviousNext: true,
    );
  },
)
```

### Error Handling

```dart
BlocBuilder<PaginatedCubit<User>, PaginationState<User>>(
  builder: (context, state) {
    if (state.hasError) {
      return PaginationErrorView(
        error: state.error!,
        onRetry: () => context.read<PaginatedCubit<User>>().retry(),
      );
    }
    
    if (state.isEmpty) {
      return PaginationEmptyView(
        title: 'No users found',
        description: 'Try refreshing to load users',
        action: ElevatedButton(
          onPressed: () => context.read<PaginatedCubit<User>>().loadFirstPage(),
          child: const Text('Retry'),
        ),
      );
    }
    
    return PaginatrixListView<User>(
      cubit: context.read<PaginatedCubit<User>>(),
      itemBuilder: (context, user, index) => UserTile(user: user),
    );
  },
)
```

---

## 📖 API Reference

### PaginatedCubit<T>

The main cubit for managing paginated data. Extends `Cubit<PaginationState<T>>` from flutter_bloc.

**Constructor:**
```dart
PaginatedCubit<T>({
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

### PaginatrixListView<T>

A ListView widget with built-in pagination support using Slivers.

**Key Parameters:**
- `cubit` - The pagination cubit (required)
- `itemBuilder` - Function to build each item (required)
- `appendLoaderBuilder` - Custom loader widget for pagination
- `onPullToRefresh` - Callback for pull-to-refresh
- `onRetryInitial` - Callback for retrying initial load
- `onRetryAppend` - Callback for retrying append
- `scrollDirection` - Scroll direction (default: Axis.vertical)
- `padding` - Padding around the list
- `physics` - Scroll physics
- `shrinkWrap` - Whether to shrink-wrap the list
- `reverse` - Whether to reverse the list

### PaginatrixGridView<T>

A GridView widget with built-in pagination support using Slivers.

**Key Parameters:**
- `cubit` - The pagination cubit (required)
- `gridDelegate` - Grid layout configuration (required)
- `itemBuilder` - Function to build each item (required)
- `appendLoaderBuilder` - Custom loader widget for pagination
- `onPullToRefresh` - Callback for pull-to-refresh

### PageSelector

A reusable widget for page selection with multiple display styles.

**Styles:**
- `PageSelectorStyle.buttons` - Displays page numbers as buttons
- `PageSelectorStyle.dropdown` - Displays page numbers in a dropdown
- `PageSelectorStyle.compact` - Compact display with current/total pages

### AppendLoader

A beautiful loading widget for pagination.

**Loader Types:**
- `LoaderType.circular` - Circular progress indicator
- `LoaderType.linear` - Linear progress indicator
- `LoaderType.pulse` - Pulsing animation
- `LoaderType.rotating` - Rotating animation
- `LoaderType.wave` - Wave animation
- `LoaderType.bouncingDots` - Bouncing dots animation

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
  transform: (data) {
    // Transform your API response
    return {
      'data': data['items'],
      'meta': {
        'current_page': data['page'],
        'per_page': data['limit'],
        // ...
      },
    };
  },
  itemsPath: 'data',
  pagePath: 'meta.current_page',
  perPagePath: 'meta.per_page',
  totalPath: 'meta.total',
  lastPagePath: 'meta.last_page',
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
)
```

### BuildConfig

Environment-specific configuration:

```dart
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

// Get environment-specific configuration
final config = BuildConfig.current;
final options = config.defaultPaginationOptions;

final cubit = PaginatedCubit<User>(
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
  onRetry: () => cubit.retry(),
)
```

### PaginationEmptyView

Displays empty states:

```dart
PaginationEmptyView(
  title: 'No items found',
  description: 'Try refreshing to load items',
  action: ElevatedButton(
    onPressed: () => cubit.loadFirstPage(),
    child: const Text('Retry'),
  ),
)
```

### PaginationSkeletonizer

Skeleton loading effect for initial load:

```dart
PaginationSkeletonizer(
  itemCount: 5,
  itemBuilder: (context, index) => ShimmerCard(),
)
```

---

## 📱 Examples

The package includes comprehensive examples:

- **example_list** - Basic list pagination
- **example_grid** - Grid pagination
- **example_bloc** - BLoC pattern integration with Pokemon API
- **example_cubit** - Cubit usage example
- **example_web_scroll** - Web scroll-based pagination
- **example_web_pages** - Web page selection pagination

Run any example:

```bash
cd examples/example_list
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

---

## 🧪 Testing

The package includes comprehensive tests:

- **171 tests** covering all scenarios
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

See [CI_CD_GUIDE.md](CI_CD_GUIDE.md) for details.

---

## 📄 Documentation

For complete documentation, see [DOCUMENTATION.md](DOCUMENTATION.md).

For changelog, see [CHANGELOG.md](CHANGELOG.md).

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
