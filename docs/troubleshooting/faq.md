# Frequently Asked Questions

Common questions about Flutter Paginatrix.

## General Questions

### What is Flutter Paginatrix?

Flutter Paginatrix is a simple, flexible, and backend-agnostic pagination package for Flutter applications. It provides everything you need for pagination including state management, UI widgets, error handling, and more.

### What pagination strategies are supported?

Flutter Paginatrix supports three pagination strategies:
- **Page-based**: Uses `page` and `per_page` parameters
- **Offset-based**: Uses `offset` and `limit` parameters
- **Cursor-based**: Uses `cursor` or `token` parameters

### Do I need to import flutter_bloc?

No! `PaginatrixController` provides a clean API that doesn't require `flutter_bloc` imports. However, if you want to use `PaginatrixCubit` directly, you'll need to import `flutter_bloc`.

### Is it production-ready?

Yes! Flutter Paginatrix is production-ready with:
- Comprehensive test coverage (171+ tests)
- Full error handling
- Performance optimizations
- Memory leak prevention
- Request cancellation

## Usage Questions

### How do I load the first page?

Call `loadFirstPage()` after creating the controller:

```dart
@override
void initState() {
  super.initState();
  _controller = PaginatrixController<User>(...);
  _controller.loadFirstPage(); // Don't forget this!
}
```

### How do I refresh data?

Call `refresh()`:

```dart
await _controller.refresh();
```

Or use pull-to-refresh:

```dart
PaginatrixListView<User>(
  controller: _controller,
  onPullToRefresh: () => _controller.refresh(),
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

### How do I implement search?

Use the `search()` method:

```dart
TextField(
  onChanged: (value) {
    _controller.search(value);
  },
)
```

The search is automatically debounced to prevent excessive API calls.

### How do I add filters?

Use `updateFilters()`:

```dart
_controller.updateFilters({
  'status': 'active',
  'role': 'admin',
});
```

### How do I implement sorting?

Use `updateSorting()`:

```dart
// Sort ascending
_controller.updateSorting('name', sortDesc: false);

// Sort descending
_controller.updateSorting('price', sortDesc: true);
```

## Configuration Questions

### How do I change the page size?

Configure it in `PaginationOptions`:

```dart
final options = PaginationOptions(
  defaultPageSize: 30,
);
```

### How do I change the debounce duration?

Configure it in `PaginationOptions`:

```dart
final options = PaginationOptions(
  searchDebounceDuration: Duration(milliseconds: 500),
  refreshDebounceDuration: Duration(milliseconds: 300),
);
```

### How do I enable debug logging?

Set `enableDebugLogging` to `true`:

```dart
final options = PaginationOptions(
  enableDebugLogging: true,
);
```

## API Questions

### What API response format is required?

Flutter Paginatrix works with any API format. Common formats:

**Nested Meta Format:**
```json
{
  "data": [...],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total": 100
  }
}
```

**Results Format:**
```json
{
  "results": [...],
  "count": 100,
  "page": 1
}
```

Use `ConfigMetaParser` for standard formats or `CustomMetaParser` for custom formats.

### How do I handle different API formats?

Use `CustomMetaParser`:

```dart
final parser = CustomMetaParser((data) {
  // Extract items and metadata from your API format
  final items = data['your_items_key'] as List;
  final meta = PageMeta(...);
  
  return {
    'items': items,
    'meta': meta.toJson(),
  };
});
```

## Error Handling Questions

### How do I handle errors?

Provide error builders:

```dart
PaginatrixListView<User>(
  controller: _controller,
  errorBuilder: (context, error, onRetry) {
    return PaginatrixErrorView(
      error: error,
      onRetry: onRetry,
    );
  },
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

### How do I retry failed operations?

Call `retry()`:

```dart
_controller.retry();
```

Or use the retry callback:

```dart
onRetryInitial: () {
  _controller.retry();
}
```

### What error types are supported?

Flutter Paginatrix supports 6 error types:
- Network errors
- Parse errors
- Cancelled errors
- Rate limited errors
- Circuit breaker errors
- Unknown errors

## Performance Questions

### How do I optimize performance?

1. **Use keys for items:**
```dart
PaginatrixListView<User>(
  controller: _controller,
  keyBuilder: (user, index) => user.id.toString(),
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

2. **Enable optimizations:**
```dart
PaginatrixListView<User>(
  controller: _controller,
  addAutomaticKeepAlives: true,
  addRepaintBoundaries: true,
  cacheExtent: 250,
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

3. **Adjust prefetch threshold:**
```dart
PaginatrixListView<User>(
  controller: _controller,
  prefetchThreshold: 1, // Load earlier
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

## Troubleshooting Questions

### Items are not loading

1. Check if `loadFirstPage()` is called
2. Verify loader function returns correct format
3. Check meta parser configuration
4. Verify item decoder
5. Check for errors in state

### Pagination is not working

1. Check `canLoadMore` is true
2. Verify meta parser extracts `hasMore`
3. Check prefetch threshold
4. Ensure list has enough items to scroll

### Memory leaks

1. Always call `dispose()` on controller
2. Cancel requests when navigating away
3. Don't create controller in `build()`

## See Also

- [Common Issues](common-issues.md) - Solutions to common problems
- [API Reference](../api-reference/) - Complete API documentation
- [Guides](../guides/) - Usage guides



