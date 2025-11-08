# 🚀 Flutter Paginatrix

[![pub package](https://img.shields.io/pub/v/flutter_paginatrix.svg)](https://pub.dev/packages/flutter_paginatrix)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.22+-blue.svg)](https://flutter.dev)

**A simple, flexible, and backend-agnostic pagination package for Flutter applications.**

Flutter Paginatrix provides everything you need for pagination with clean architecture, comprehensive error handling, and beautiful UI components built with Slivers for optimal performance.

---

## ✨ Features

- ✅ **Backend Agnostic** - Works with any API structure (page/perPage, offset/limit, cursor-based)
- ✅ **Single Loader Function** - One function handles all pagination scenarios
- ✅ **Type-Safe** - Full generics support with immutable data structures
- ✅ **Reactive** - Stream-based state management
- ✅ **Performance Optimized** - Sliver-based architecture for smooth scrolling
- ✅ **Comprehensive Error Handling** - 6 error types with automatic recovery
- ✅ **Beautiful UI Components** - Pre-built widgets with modern loading animations
- ✅ **Request Cancellation** - Automatic cleanup of in-flight requests
- ✅ **Stale Response Prevention** - Generation-based guards prevent race conditions
- ✅ **Zero External Dependencies** - No complex DI frameworks required

---

## 📦 Installation

Add `flutter_paginatrix` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_paginatrix: ^1.0.0
  dio: ^5.4.0  # For HTTP requests (optional)
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final PaginatedController<User> _controller;
  final _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  @override
  void initState() {
    super.initState();
    _controller = PaginatedController<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
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
      appBar: AppBar(title: Text('Users')),
      body: PaginatrixListView<User>(
        controller: _controller,
        itemBuilder: (context, user, index) {
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
        appendLoaderBuilder: (context) => AppendLoader(
          loaderType: LoaderType.pulse,
          message: 'Loading more users...',
        ),
        onPullToRefresh: () => _controller.refresh(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

### MetaTransform

`MetaTransform` transforms non-standard API responses into the expected format:

```dart
typedef MetaTransform = Map<String, dynamic> Function(Map<String, dynamic> data);
```

This allows you to normalize any API response structure.

---

## 🎯 Usage Examples

### List View with Pagination

```dart
PaginatrixListView<Product>(
  controller: controller,
  itemBuilder: (context, product, index) {
    return ProductCard(product: product);
  },
  appendLoaderBuilder: (context) => AppendLoader(
    loaderType: LoaderType.pulse,
    message: 'Loading more products...',
  ),
  onPullToRefresh: () => controller.refresh(),
)
```

### Grid View with Pagination

```dart
PaginatrixGridView<Product>(
  controller: controller,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
PageSelector(
  currentPage: controller.state.meta?.page ?? 1,
  totalPages: controller.state.meta?.lastPage ?? 1,
  onPageSelected: (page) {
    // Navigate to page
  },
  style: PageSelectorStyle.buttons,
  showFirstLast: true,
  showPreviousNext: true,
)
```

### BLoC Integration

```dart
class PaginationBloc<T> extends Bloc<PaginationEvent, PaginationBlocState<T>> {
  PaginationBloc({required PaginatedController<T> controller})
      : _controller = controller,
        super(PaginationBlocState<T>(
          paginationState: controller.state,
        )) {
    _controllerSubscription = _controller.stream.listen(
      (state) => add(ControllerStateChanged(state)),
    );
  }

  final PaginatedController<T> _controller;
  StreamSubscription? _controllerSubscription;

  @override
  Future<void> close() {
    _controllerSubscription?.cancel();
    _controller.dispose();
    return super.close();
  }
}
```

---

## 📖 API Reference

### PaginatedController<T>

The main controller for managing paginated data.

**Properties:**
- `Stream<PaginationState<T>> stream` - Stream of pagination states
- `PaginationState<T> state` - Current pagination state
- `bool canLoadMore` - Whether more data can be loaded
- `bool isLoading` - Whether currently loading
- `bool hasData` - Whether has data
- `bool hasError` - Whether has error

**Methods:**
- `Future<void> loadFirstPage()` - Loads the first page (resets list)
- `Future<void> loadNextPage()` - Loads the next page (appends to list)
- `Future<void> refresh()` - Refreshes current data
- `Future<void> retry()` - Retries the last failed operation
- `void cancel()` - Cancels current request
- `void clear()` - Clears all data and resets to initial state
- `void dispose()` - Disposes the controller

### PaginatrixListView<T>

A ListView widget with built-in pagination support.

**Key Parameters:**
- `controller` - The pagination controller
- `itemBuilder` - Function to build each item
- `appendLoaderBuilder` - Custom loader widget for pagination
- `onPullToRefresh` - Callback for pull-to-refresh
- `onRetryInitial` - Callback for retrying initial load
- `onRetryAppend` - Callback for retrying append

### PaginatrixGridView<T>

A GridView widget with built-in pagination support.

**Key Parameters:**
- `controller` - The pagination controller
- `gridDelegate` - Grid layout configuration
- `itemBuilder` - Function to build each item
- `appendLoaderBuilder` - Custom loader widget for pagination

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
  // ...
)
```

### PaginationOptions

```dart
PaginationOptions(
  defaultPageSize: 20,
  maxPageSize: 100,
  requestTimeout: Duration(seconds: 30),
  enableDebugLogging: false,
)
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
    child: Text('Retry'),
  ),
)
```

### PaginationShimmer

Shimmer effect for loading placeholders:

```dart
PaginationShimmer(
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
- **Efficient state management** - Minimal rebuilds
- **Memory-efficient** - Proper disposal and cleanup

---

## 🧪 Testing

The package includes comprehensive tests:

- **65 tests** covering all scenarios
- **Unit tests** for entities and controllers
- **Integration tests** for complete flows
- **Edge case coverage** - Empty responses, errors, cancellation

Run tests:

```bash
flutter test
```

---

## 📄 Documentation

For complete documentation, see [DOCUMENTATION.md](DOCUMENTATION.md).

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🔗 Links

- **Package**: [pub.dev/packages/flutter_paginatrix](https://pub.dev/packages/flutter_paginatrix)
- **Repository**: [github.com/MhamadHwidi7/flutter_paginatrix](https://github.com/MhamadHwidi7/flutter_paginatrix)
- **Issues**: [github.com/MhamadHwidi7/flutter_paginatrix/issues](https://github.com/MhamadHwidi7/flutter_paginatrix/issues)

---

## ⭐ Show Your Support

If you find this package useful, please consider giving it a ⭐ on GitHub!

---

**Made with ❤️ for the Flutter community**

