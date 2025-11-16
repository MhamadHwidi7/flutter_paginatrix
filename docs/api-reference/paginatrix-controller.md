# PaginatrixController API Reference

Complete API reference for `PaginatrixController<T>`.

## Overview

`PaginatrixController<T>` is the main controller for managing paginated data. It provides a clean API without requiring `flutter_bloc` imports.

## Constructor

```dart
PaginatrixController<T>({
  required LoaderFn<T> loader,
  required ItemDecoder<T> itemDecoder,
  required MetaParser metaParser,
  PaginationOptions? options,
})
```

### Parameters

- **`loader`** (required) - Function that loads paginated data
- **`itemDecoder`** (required) - Function to decode items from raw data
- **`metaParser`** (required) - Parser to extract pagination metadata
- **`options`** (optional) - Pagination configuration options

## Properties

### `state: PaginationState<T>`

Current pagination state. Read-only.

```dart
final currentState = controller.state;
final items = controller.state.items;
final status = controller.state.status;
```

### `canLoadMore: bool`

Whether more data can be loaded.

```dart
if (controller.canLoadMore) {
  await controller.loadNextPage();
}
```

### `isLoading: bool`

Whether a load operation is in progress.

```dart
if (controller.isLoading) {
  // Show loading indicator
}
```

### `hasData: bool`

Whether the controller has successfully loaded data.

```dart
if (controller.hasData) {
  // Display items
}
```

### `hasError: bool`

Whether the initial load encountered an error.

```dart
if (controller.hasError) {
  // Show error UI
}
```

### `hasAppendError: bool`

Whether loading the next page encountered an error.

```dart
if (controller.hasAppendError) {
  // Show append error UI
}
```

## Methods

### `loadFirstPage()`

Loads the first page of data (resets the list and starts fresh).

```dart
await controller.loadFirstPage();
```

**Returns:** `Future<void>`

**State transitions:**
- Initial/Loading → Success (with data) or Empty (no data) or Error

**Note:** This will cancel any in-flight requests and reset the state.

### `loadNextPage()`

Loads the next page of data (appends new data to existing list).

```dart
await controller.loadNextPage();
```

**Returns:** `Future<void>`

**State transitions:**
- Success → Appending → Success (with more items) or AppendError

**Note:** Requires that the first page has been loaded successfully. Will not proceed if `canLoadMore` is false or if already loading.

### `refresh()`

Refreshes the current data (reloads first page and replaces all items).

```dart
await controller.refresh();
```

**Returns:** `Future<void>`

**State transitions:**
- Success → Refreshing → Success (with fresh data) or Error

**Debouncing:** Uses debouncing to prevent rapid successive refresh calls. The debounce duration is configurable via `PaginationOptions.refreshDebounceDuration`.

### `updateSearchTerm(String term)`

Updates the search term and triggers a debounced reload of the first page.

```dart
controller.updateSearchTerm('john');
```

**Parameters:**
- **`term`** - Search term (empty string clears search)

**Behavior:**
- Updates `state.query.searchTerm`
- Cancels any previous search debounce timer
- Schedules a new debounced reload after `PaginationOptions.searchDebounceDuration`
- Automatically resets to page 1 when reload occurs
- Empty string triggers immediate reload (bypasses debounce)

### `updateFilter(String key, dynamic value)`

Updates a specific filter and immediately reloads the first page.

```dart
// Add or update a filter
controller.updateFilter('status', 'active');

// Remove a filter by passing null
controller.updateFilter('status', null);
```

**Parameters:**
- **`key`** - Filter key (cannot be empty)
- **`value`** - Filter value (null removes the filter)

**Behavior:**
- Updates `state.query.filters` with the new key-value pair
- If value is null, removes the filter
- Immediately reloads first page (no debouncing)
- Cancels any in-flight requests before starting new load

**Throws:** `ArgumentError` if key is empty

### `updateFilters(Map<String, dynamic> filters)`

Updates filters and immediately reloads the first page.

```dart
controller.updateFilters({
  'status': 'active',
  'role': 'admin',
});
```

**Parameters:**
- **`filters`** - Map of filter key-value pairs

### `clearFilters()`

Clears all filters and immediately reloads the first page.

```dart
controller.clearFilters();
```

**Behavior:**
- Clears all filters from `state.query.filters`
- Preserves search term and sorting
- Immediately reloads first page

### `updateSorting(String? sortBy, {bool sortDesc = false})`

Updates the sorting criteria and immediately reloads the first page.

```dart
// Sort by name ascending
controller.updateSorting('name', sortDesc: false);

// Sort by price descending
controller.updateSorting('price', sortDesc: true);

// Clear sorting
controller.updateSorting(null);
```

**Parameters:**
- **`sortBy`** - Field to sort by (null clears sorting)
- **`sortDesc`** - Whether to sort descending (default: false)

### `clearAllQuery()`

Clears all search, filters, and sorting, then reloads the first page.

```dart
controller.clearAllQuery();
```

**Behavior:**
- Resets query criteria to empty
- Reloads first page with no search, filters, or sorting

### `retry()`

Retries the last failed operation.

```dart
controller.retry();
```

**Returns:** `Future<void>`

**Behavior:**
- Retries initial load if `hasError` is true
- Retries append operation if `hasAppendError` is true
- Uses exponential backoff for retry attempts

### `cancel()`

Cancels the current in-flight request.

```dart
controller.cancel();
```

**Note:** This does not reset the state, only cancels the current request. Use `clear()` if you want to reset the state as well.

### `clear()`

Clears all data and resets to initial state.

```dart
controller.clear();
// Then load first page again
await controller.loadFirstPage();
```

**Behavior:**
- Cancels any in-flight requests
- Resets state to initial
- Clears all items and metadata

### `close()`

Closes the controller and cleans up resources.

```dart
@override
void dispose() {
  controller.close();  // Note: method is close(), not dispose()
  super.dispose();
}
```

**Important:** Always call `close()` in your widget's `dispose()` method to prevent memory leaks.

## Usage Example

```dart
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
    final queryParams = <String, dynamic>{
      if (page != null) 'page': page,
      if (perPage != null) 'per_page': perPage,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
      if (cursor != null) 'cursor': cursor,
      if (query?.searchTerm.isNotEmpty ?? false) 'search': query!.searchTerm,
      ...?query?.filters,
    };
    final response = await dio.get(
      'https://api.example.com/users',
      queryParameters: queryParams,
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
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.refresh(),
          ),
        ],
      ),
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

## See Also

- [PaginatrixCubit](paginatrix-cubit.md) - Advanced Cubit API
- [PaginationState](pagination-state.md) - State object reference
- [Widgets](widgets.md) - UI widget reference

