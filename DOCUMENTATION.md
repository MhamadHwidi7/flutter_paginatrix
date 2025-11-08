# 📚 Flutter Paginatrix - Complete Documentation

**Version:** 1.0.0  
**A comprehensive, backend-agnostic pagination engine for Flutter**

---

## 📖 Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Core Concepts](#core-concepts)
4. [Architecture](#architecture)
5. [API Reference](#api-reference)
   - [Controllers](#controllers)
   - [Widgets](#widgets)
   - [Entities](#entities)
   - [Parsers](#parsers)
   - [Utilities](#utilities)
6. [Usage Examples](#usage-examples)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## Overview

Flutter Paginatrix is a production-ready pagination library that provides:

- ✅ **Backend-agnostic** - Works with any API structure
- ✅ **Type-safe** - Full generics support
- ✅ **Immutable** - Built with Freezed and Equatable
- ✅ **Reactive** - Stream-based state management
- ✅ **Performance-optimized** - Sliver-based architecture
- ✅ **Comprehensive error handling** - 6 error types with recovery
- ✅ **Beautiful UI components** - Pre-built widgets with animations

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_paginatrix: ^1.0.0
  dio: ^5.4.0  # For HTTP requests (optional)
```

---

## Core Concepts

### 1. Single Loader Function

The library uses a **single loader function** that handles both initial load and pagination:

```dart
typedef LoaderFn<T> = Future<Map<String, dynamic>> Function({
  int? page,        // Page number (1-based)
  int? perPage,     // Items per page
  int? offset,      // Offset for offset/limit pagination
  int? limit,     // Limit for offset/limit pagination
  String? cursor,   // Cursor for cursor-based pagination
  CancelToken? cancelToken,  // For request cancellation
});
```

The controller automatically:
- Calls this function with `page: 1` for initial load
- Calls it with `page: 2, 3, ...` for pagination
- Manages the list (sets for first page, appends for next pages)

### 2. RequestContext

`RequestContext` prevents stale responses and manages race conditions:

```dart
class RequestContext {
  final int generation;        // Generation number
  final CancelToken cancelToken;  // For cancellation
  final bool isRefresh;        // Whether this is a refresh
  final bool isAppend;         // Whether this is an append
}
```

**Why it exists:**
- Prevents race conditions when multiple requests are in flight
- Ensures only the latest response updates the UI
- Manages request cancellation

### 3. MetaTransform

`MetaTransform` transforms non-standard API responses into the expected format:

```dart
typedef MetaTransform = Map<String, dynamic> Function(Map<String, dynamic> data);
```

**Why it exists:**
- APIs have different response structures
- Some use `data`, others use `results`, `items`, etc.
- Allows you to normalize any API response

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Your App                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              UI Layer (Widgets)                       │  │
│  │  PaginatrixListView / PaginatrixGridView              │  │
│  └────────────────────┬──────────────────────────────────┘  │
│                       │ Stream                               │
│  ┌────────────────────▼──────────────────────────────────┐  │
│  │         PaginatedController<T>                         │  │
│  │  • Manages pagination state                            │  │
│  │  • Handles loading, appending, refreshing             │  │
│  │  • Prevents stale responses                           │  │
│  │  • Manages request cancellation                       │  │
│  └────────────────────┬──────────────────────────────────┘  │
│                       │ Calls                                │
│  ┌────────────────────▼──────────────────────────────────┐  │
│  │         Your Loader Function                          │  │
│  │  • Single function for all pagination                 │  │
│  │  • Called with page number (1, 2, 3...)              │  │
│  │  • Returns data + meta                                │  │
│  └────────────────────┬──────────────────────────────────┘  │
│                       │                                      │
│  ┌────────────────────▼──────────────────────────────────┐  │
│  │         MetaParser                                     │  │
│  │  • Extracts items from response                       │  │
│  │  • Parses pagination metadata                         │  │
│  └─────────────────────────────────────────────────────────┘  │
```

---

## API Reference

### Controllers

#### `PaginatedController<T>`

The main controller for managing paginated data.

**Constructor:**

```dart
PaginatedController<T>({
  required LoaderFn<T> loader,
  required ItemDecoder<T> itemDecoder,
  required MetaParser metaParser,
  PaginationOptions? options,
})
```

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
- `Future<void> refresh()` - Refreshes current data (reloads first page)
- `Future<void> retry()` - Retries the last failed operation
- `void cancel()` - Cancels current request
- `void clear()` - Clears all data and resets to initial state
- `void dispose()` - Disposes the controller

**Example:**

```dart
final controller = PaginatedController<User>(
  loader: myLoaderFunction,
  itemDecoder: User.fromJson,
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
);

// Load first page
await controller.loadFirstPage();

// Load next page
await controller.loadNextPage();

// Refresh
await controller.refresh();

// Listen to state changes
controller.stream.listen((state) {
  print('State: ${state.status}');
  print('Items: ${state.items.length}');
});
```

---

### Widgets

#### `PaginatrixListView<T>`

A ListView widget with built-in pagination support.

**Constructor:**

```dart
PaginatrixListView<T>({
  required PaginatedController<T> controller,
  required Widget Function(BuildContext, T, int) itemBuilder,
  String Function(T, int)? keyBuilder,
  int? prefetchThreshold,
  EdgeInsetsGeometry? padding,
  ScrollPhysics? physics,
  bool shrinkWrap = false,
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  Widget Function(BuildContext, int)? separatorBuilder,
  Widget Function(BuildContext, int)? shimmerBuilder,
  Widget Function(BuildContext)? emptyBuilder,
  Widget Function(BuildContext, PaginationError)? errorBuilder,
  Widget Function(BuildContext, PaginationError)? appendErrorBuilder,
  Widget Function(BuildContext)? appendLoaderBuilder,
  VoidCallback? onPullToRefresh,
  VoidCallback? onRetryInitial,
  VoidCallback? onRetryAppend,
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  bool addSemanticIndexes = true,
  double? cacheExtent,
})
```

**Example:**

```dart
PaginatrixListView<User>(
  controller: controller,
  itemBuilder: (context, user, index) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  },
  appendLoaderBuilder: (context) => AppendLoader(
    loaderType: LoaderType.pulse,
    message: 'Loading more...',
  ),
  onPullToRefresh: () => controller.refresh(),
)
```

#### `PaginatrixGridView<T>`

A GridView widget with built-in pagination support.

**Constructor:**

```dart
PaginatrixGridView<T>({
  required PaginatedController<T> controller,
  required Widget Function(BuildContext, T, int) itemBuilder,
  required SliverGridDelegate gridDelegate,
  String Function(T, int)? keyBuilder,
  int? prefetchThreshold,
  EdgeInsetsGeometry? padding,
  ScrollPhysics? physics,
  bool shrinkWrap = false,
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  Widget Function(BuildContext, int)? shimmerBuilder,
  Widget Function(BuildContext)? emptyBuilder,
  Widget Function(BuildContext, PaginationError)? errorBuilder,
  Widget Function(BuildContext, PaginationError)? appendErrorBuilder,
  Widget Function(BuildContext)? appendLoaderBuilder,
  VoidCallback? onPullToRefresh,
  VoidCallback? onRetryInitial,
  VoidCallback? onRetryAppend,
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  bool addSemanticIndexes = true,
  double? cacheExtent,
})
```

**Example:**

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

#### `PageSelector`

A reusable widget for page selection with multiple display styles.

**Constructor:**

```dart
PageSelector({
  required int currentPage,
  required int totalPages,
  required void Function(int) onPageSelected,
  bool isLoading = false,
  PageSelectorStyle style = PageSelectorStyle.buttons,
  int maxVisiblePages = 7,
  bool showFirstLast = true,
  bool showPreviousNext = true,
  EdgeInsetsGeometry? padding,
  Color? backgroundColor,
  BorderRadius? borderRadius,
})
```

**Styles:**

- `PageSelectorStyle.buttons` - Displays page numbers as buttons
- `PageSelectorStyle.dropdown` - Displays page numbers in a dropdown
- `PageSelectorStyle.compact` - Compact display with current/total pages

**Example:**

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

#### `AppendLoader`

A beautiful loading widget for pagination.

**Constructor:**

```dart
AppendLoader({
  LoaderType loaderType = LoaderType.circular,
  String? message,
  Color? color,
  double size = 24.0,
  EdgeInsetsGeometry? padding,
})
```

**Loader Types:**

- `LoaderType.circular` - Circular progress indicator
- `LoaderType.linear` - Linear progress indicator
- `LoaderType.pulse` - Pulsing animation
- `LoaderType.rotating` - Rotating animation
- `LoaderType.wave` - Wave animation

**Example:**

```dart
AppendLoader(
  loaderType: LoaderType.pulse,
  message: 'Loading more items...',
  color: Theme.of(context).primaryColor,
  size: 28.0,
  padding: EdgeInsets.all(20),
)
```

#### `PaginationErrorView`

A widget for displaying pagination errors.

**Constructor:**

```dart
PaginationErrorView({
  required PaginationError error,
  required VoidCallback onRetry,
  String? title,
  String? message,
  Widget? icon,
  Widget? action,
})
```

**Example:**

```dart
PaginationErrorView(
  error: state.error!,
  onRetry: () => controller.retry(),
)
```

#### `PaginationEmptyView`

A widget for displaying empty states.

**Constructor:**

```dart
PaginationEmptyView({
  required String title,
  String? description,
  Widget? action,
  Widget? icon,
})
```

**Example:**

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

#### `PaginationShimmer`

A shimmer effect widget for loading placeholders.

**Constructor:**

```dart
PaginationShimmer({
  int itemCount = 5,
  Widget Function(BuildContext, int)? itemBuilder,
  EdgeInsetsGeometry? padding,
})
```

---

### Entities

#### `PaginationState<T>`

Represents the complete state of pagination.

**Properties:**

- `PaginationStatus status` - Current status
- `List<T> items` - Loaded items
- `PageMeta? meta` - Pagination metadata
- `PaginationError? error` - Current error
- `PaginationError? appendError` - Append error (non-blocking)
- `RequestContext? requestContext` - Current request context
- `bool isStale` - Whether data is stale
- `DateTime? lastLoadedAt` - Last successful load timestamp

**Convenience Getters:**

- `bool hasData` - Whether has data
- `bool isLoading` - Whether is loading
- `bool hasError` - Whether has error
- `bool canLoadMore` - Whether can load more

**Factory Constructors:**

- `PaginationState.initial()` - Initial state
- `PaginationState.loading(...)` - Loading state
- `PaginationState.success(...)` - Success state
- `PaginationState.empty(...)` - Empty state
- `PaginationState.error(...)` - Error state
- `PaginationState.refreshing(...)` - Refreshing state
- `PaginationState.appending(...)` - Appending state
- `PaginationState.appendError(...)` - Append error state

#### `PaginationStatus`

Represents the current pagination status (sealed class).

**Types:**

- `PaginationStatus.initial()` - Initial state
- `PaginationStatus.loading()` - Loading
- `PaginationStatus.success()` - Success
- `PaginationStatus.empty()` - Empty
- `PaginationStatus.error()` - Error
- `PaginationStatus.refreshing()` - Refreshing
- `PaginationStatus.appending()` - Appending
- `PaginationStatus.appendError()` - Append error

**Usage:**

```dart
state.status.maybeWhen(
  loading: () => CircularProgressIndicator(),
  success: () => ListView(...),
  error: () => ErrorWidget(),
  orElse: () => SizedBox(),
)
```

#### `PaginationError`

Represents pagination errors (sealed class).

**Types:**

- `PaginationError.network(...)` - Network errors
- `PaginationError.parse(...)` - Parse errors
- `PaginationError.cancelled(...)` - Cancelled requests
- `PaginationError.rateLimited(...)` - Rate limiting
- `PaginationError.circuitBreaker(...)` - Circuit breaker
- `PaginationError.unknown(...)` - Unknown errors

**Properties:**

- `String message` - Error message
- `bool isRetryable` - Whether error is retryable
- `bool isUserVisible` - Whether error should be shown to user
- `String userMessage` - User-friendly message

**Usage:**

```dart
error.when(
  network: (message, statusCode, originalError) {
    return 'Network error: $message';
  },
  parse: (message, expectedFormat, actualData) {
    return 'Parse error: $message';
  },
  cancelled: (message) => 'Cancelled',
  rateLimited: (message, retryAfter) => 'Rate limited',
  circuitBreaker: (message, retryAfter) => 'Service unavailable',
  unknown: (message, originalError) => 'Unknown error',
)
```

#### `PageMeta`

Represents pagination metadata.

**Properties:**

- `int? page` - Current page number (1-based)
- `int? perPage` - Items per page
- `int? total` - Total items
- `int? lastPage` - Total pages
- `bool? hasMore` - Whether has more pages
- `String? nextCursor` - Next cursor (cursor-based)
- `String? previousCursor` - Previous cursor (cursor-based)
- `int? offset` - Offset (offset/limit)
- `int? limit` - Limit (offset/limit)

**Factory Methods:**

- `PageMeta.pageBased(...)` - For page-based pagination
- `PageMeta.cursorBased(...)` - For cursor-based pagination
- `PageMeta.offsetBased(...)` - For offset/limit pagination
- `PageMeta.fromJson(...)` - From JSON

#### `RequestContext`

Represents the context of a pagination request.

**Properties:**

- `int generation` - Generation number (prevents stale responses)
- `CancelToken cancelToken` - For request cancellation
- `bool isRefresh` - Whether this is a refresh
- `bool isAppend` - Whether this is an append

**Factory:**

- `RequestContext.create(...)` - Creates a new request context

#### `PaginationType`

Enum for different pagination types.

**Values:**

- `PaginationType.scroll` - Scroll-based pagination
- `PaginationType.pageSelection` - Page selection pagination
- `PaginationType.loadMoreButton` - Load more button
- `PaginationType.cursor` - Cursor-based pagination

---

### Parsers

#### `MetaParser`

Abstract class for parsing pagination metadata.

**Methods:**

- `List<dynamic> extractItems(Map<String, dynamic> data)` - Extracts items
- `PageMeta parseMeta(Map<String, dynamic> data)` - Parses metadata

#### `ConfigMetaParser`

A configurable meta parser.

**Constructor:**

```dart
ConfigMetaParser(MetaConfig config)
```

**Predefined Configs:**

- `MetaConfig.nestedMeta` - `{data: [], meta: {...}}`
- `MetaConfig.resultsFormat` - `{results: [], count: ..., page: ...}`
- `MetaConfig.pageBased` - `{data: [], page: ..., per_page: ...}`

**Example:**

```dart
final parser = ConfigMetaParser(MetaConfig.nestedMeta);
```

#### `CustomMetaParser`

A custom meta parser for non-standard formats.

**Constructor:**

```dart
CustomMetaParser({
  required MetaTransform transform,
  required String itemsPath,
  required String pagePath,
  // ... other paths
})
```

**Example:**

```dart
final parser = CustomMetaParser(
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
);
```

---

### Utilities

#### `PaginationOptions`

Configuration options for pagination.

**Properties:**

- `int defaultPageSize` - Default page size (default: 20)
- `int maxPageSize` - Maximum page size (default: 100)
- `Duration requestTimeout` - Request timeout
- `bool enableDebugLogging` - Enable debug logging

**Factory:**

- `PaginationOptions.defaultOptions` - Default options

#### `LoaderFn<T>`

Function type for loading paginated data.

```dart
typedef LoaderFn<T> = Future<Map<String, dynamic>> Function({
  int? page,
  int? perPage,
  int? offset,
  int? limit,
  String? cursor,
  CancelToken? cancelToken,
});
```

#### `ItemDecoder<T>`

Function type for decoding items.

```dart
typedef ItemDecoder<T> = T Function(Map<String, dynamic> data);
```

#### `MetaTransform`

Function type for transforming API responses.

```dart
typedef MetaTransform = Map<String, dynamic> Function(Map<String, dynamic> data);
```

---

## Usage Examples

### Basic List Pagination

```dart
class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late final PaginatedController<User> _controller;

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
    final response = await dio.get(
      '/users',
      queryParameters: {'page': page, 'per_page': perPage},
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

### Grid Pagination

```dart
PaginatrixGridView<Product>(
  controller: _controller,
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

### Page Selection (Web)

```dart
PageSelector(
  currentPage: controller.state.meta?.page ?? 1,
  totalPages: controller.state.meta?.lastPage ?? 1,
  onPageSelected: (page) {
    // Navigate to page
  },
  style: PageSelectorStyle.buttons,
)
```

---

## Best Practices

1. **Always dispose controllers** - Call `controller.dispose()` in `dispose()`
2. **Use RequestContext** - The library handles this automatically
3. **Handle errors gracefully** - Use `PaginationErrorView` or custom error widgets
4. **Optimize images** - Use `CachedNetworkImage` with appropriate cache sizes
5. **Use appropriate page sizes** - Balance between too many requests and too much data
6. **Test error scenarios** - Network failures, empty responses, etc.
7. **Use type safety** - Always specify the generic type `<T>`

---

## Troubleshooting

### Icons not showing in web examples

Make sure icon paths use `$FLUTTER_BASE_HREF`:

```html
<link rel="icon" type="image/png" href="$FLUTTER_BASE_HREFfavicon.png"/>
<link rel="apple-touch-icon" href="$FLUTTER_BASE_HREFicons/Icon-192.png">
```

### Stale responses

The library automatically handles this with `RequestContext` and generation numbers. If you see stale data, ensure you're not caching responses incorrectly.

### Memory leaks

Always dispose controllers:

```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### Performance issues

- Use appropriate `cacheExtent` values
- Optimize `itemBuilder` functions
- Use `CachedNetworkImage` for images
- Set appropriate `prefetchThreshold`

---

## License

MIT License - see LICENSE file for details.

---

## Support

- **GitHub Issues:** https://github.com/MhamadHwidi7/flutter_paginatrix/issues
- **Repository:** https://github.com/MhamadHwidi7/flutter_paginatrix

---

**Version:** 1.0.0  
**Last Updated:** November 2024

