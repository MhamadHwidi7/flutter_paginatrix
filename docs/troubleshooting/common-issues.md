# Common Issues and Solutions

Solutions to common problems when using Flutter Paginatrix.

## Table of Contents

- [Items Not Loading](#items-not-loading)
- [Infinite Loading](#infinite-loading)
- [Errors Not Displaying](#errors-not-displaying)
- [Memory Leaks](#memory-leaks)
- [Pagination Not Working](#pagination-not-working)
- [Search Not Working](#search-not-working)
- [Performance Issues](#performance-issues)

## Items Not Loading

### Problem

Items are not appearing in the list after calling `loadFirstPage()`.

### Solutions

1. **Check if `loadFirstPage()` is called:**

```dart
@override
void initState() {
  super.initState();
  _controller = PaginatrixController<User>(...);
  _controller.loadFirstPage(); // Don't forget this!
}
```

2. **Verify loader function returns correct format:**

```dart
Future<Map<String, dynamic>> _loadUsers({...}) async {
  final response = await dio.get(...);
  // Must return Map with 'data' or 'results' key
  return response.data; // Should be Map<String, dynamic>
}
```

3. **Check meta parser configuration:**

```dart
// Ensure MetaConfig matches your API response
final parser = ConfigMetaParser(MetaConfig.nestedMeta);
// Or use CustomMetaParser for custom formats
```

4. **Verify item decoder:**

```dart
itemDecoder: User.fromJson, // Must match your model
```

5. **Check for errors:**

```dart
if (_controller.state.hasError) {
  print('Error: ${_controller.state.error}');
}
```

## Infinite Loading

### Problem

Loading indicator never stops, items never appear.

### Solutions

1. **Check API response format:**

```dart
// Ensure API returns correct structure
{
  "data": [...], // or "results"
  "meta": {
    "current_page": 1,
    "per_page": 20,
    // ... other meta fields
  }
}
```

2. **Verify meta parser extracts data correctly:**

```dart
final parser = CustomMetaParser((data) {
  // Debug: Print what parser receives
  print('Parser received: $data');
  
  final items = data['data'] as List;
  final meta = PageMeta(...);
  
  return {
    'items': items,
    'meta': meta.toJson(),
  };
});
```

3. **Check for exceptions in loader:**

```dart
Future<Map<String, dynamic>> _loadUsers({...}) async {
  try {
    final response = await dio.get(...);
    return response.data;
  } catch (e) {
    print('Loader error: $e');
    rethrow; // Let controller handle error
  }
}
```

## Errors Not Displaying

### Problem

Errors occur but are not shown in the UI.

### Solutions

1. **Provide error builder:**

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

2. **Check error state:**

```dart
if (_controller.state.hasError) {
  final error = _controller.state.error;
  print('Error: ${error.toString()}');
}
```

3. **Handle errors in loader:**

```dart
Future<Map<String, dynamic>> _loadUsers({...}) async {
  try {
    final response = await dio.get(...);
    if (response.statusCode != 200) {
      throw PaginationError.network(
        message: 'HTTP ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
    return response.data;
  } catch (e) {
    // Convert to PaginationError
    if (e is PaginationError) rethrow;
    throw PaginationError.unknown(
      message: e.toString(),
      originalError: e.toString(),
    );
  }
}
```

## Memory Leaks

### Problem

Memory usage increases over time, app becomes slow.

### Solutions

1. **Always dispose controllers:**

```dart
@override
void dispose() {
  _controller.dispose(); // Important!
  super.dispose();
}
```

2. **Cancel requests when navigating away:**

```dart
@override
void dispose() {
  _controller.cancel(); // Cancel in-flight requests
  _controller.dispose();
  super.dispose();
}
```

3. **Use proper widget lifecycle:**

```dart
// Don't create controller in build()
// Create in initState() and dispose in dispose()
```

## Pagination Not Working

### Problem

Scrolling doesn't trigger loading next page.

### Solutions

1. **Check `canLoadMore`:**

```dart
if (_controller.canLoadMore) {
  // Should be true if more pages available
}
```

2. **Verify meta parser extracts `hasMore`:**

```dart
final meta = PageMeta(
  hasMore: data['meta']['has_more'] as bool, // Must be correct
);
```

3. **Check prefetch threshold:**

```dart
PaginatrixListView<User>(
  controller: _controller,
  prefetchThreshold: 3, // Load when 3 items from end
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

4. **Ensure scroll detection is working:**

```dart
// Widget automatically handles scroll detection
// But verify list has enough items to scroll
```

## Search Not Working

### Problem

Search doesn't filter results.

### Solutions

1. **Check search term is passed to API:**

```dart
Future<Map<String, dynamic>> _loadUsers({
  int? page,
  int? perPage,
  CancelToken? cancelToken,
  QueryCriteria? query, // Must include this parameter
}) async {
  final params = <String, dynamic>{
    'page': page ?? 1,
    'per_page': perPage ?? 20,
  };
  
  // Add search term
  if (query?.searchTerm != null && query!.searchTerm!.isNotEmpty) {
    params['search'] = query.searchTerm;
  }
  
  final response = await dio.get(
    'https://api.example.com/users',
    queryParameters: params,
    cancelToken: cancelToken,
  );
  return response.data;
}
```

2. **Verify debounce duration:**

```dart
final options = PaginationOptions(
  searchDebounceDuration: Duration(milliseconds: 400),
);
```

3. **Check search is called:**

```dart
TextField(
  onChanged: (value) {
    _controller.search(value); // Must call this
  },
)
```

## Performance Issues

### Problem

List scrolling is slow, UI is laggy.

### Solutions

1. **Optimize item builder:**

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) {
    // Use const widgets where possible
    return const UserTile(user: user);
  },
  // Enable optimizations
  addAutomaticKeepAlives: true,
  addRepaintBoundaries: true,
  cacheExtent: 250,
)
```

2. **Reduce prefetch threshold:**

```dart
PaginatrixListView<User>(
  controller: _controller,
  prefetchThreshold: 1, // Load earlier
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

3. **Limit page size:**

```dart
final options = PaginationOptions(
  defaultPageSize: 20, // Smaller pages = faster loads
);
```

4. **Use keys for items:**

```dart
PaginatrixListView<User>(
  controller: _controller,
  keyBuilder: (user, index) => user.id.toString(),
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

## Still Having Issues?

1. **Enable debug logging:**

```dart
final options = PaginationOptions(
  enableDebugLogging: true,
);
```

2. **Check state:**

```dart
print('State: ${_controller.state}');
print('Items: ${_controller.state.items.length}');
print('Status: ${_controller.state.status}');
print('Error: ${_controller.state.error}');
```

3. **Create an issue:**

- [GitHub Issues](https://github.com/MhamadHwidi7/flutter_paginatrix/issues)
- Include code snippets and error messages
- Describe expected vs actual behavior

## See Also

- [FAQ](faq.md) - Frequently asked questions
- [API Reference](../api-reference/) - Complete API documentation

