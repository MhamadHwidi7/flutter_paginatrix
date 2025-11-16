# PaginationState API Reference

Complete API reference for `PaginationState<T>`.

---

## Overview

`PaginationState<T>` is an immutable state object that represents the complete state of pagination at any given time. It uses Freezed for immutability and provides type-safe state management.

---

## Type Parameters

- **`T`** - The type of items being paginated (e.g., `User`, `Product`, `Post`)

---

## Properties

### `status: PaginationStatus`

Current pagination status. Read-only.

**Type:** `PaginationStatus`

**Possible Values:**
- `PaginationStatus.initial()` - Initial state (no data loaded)
- `PaginationStatus.loading()` - Loading first page
- `PaginationStatus.success()` - Successfully loaded data
- `PaginationStatus.empty()` - No data available
- `PaginationStatus.error()` - Error occurred during initial load
- `PaginationStatus.refreshing()` - Refreshing data
- `PaginationStatus.appending()` - Loading next page
- `PaginationStatus.appendError()` - Error during append operation

**Example:**
```dart
final status = state.status;
if (status is PaginationStatus.success) {
  // Handle success
}
```

### `items: List<T>`

List of loaded items. Read-only.

**Type:** `List<T>`

**Default:** Empty list `[]`

**Example:**
```dart
final items = state.items;
for (final item in items) {
  print(item.name);
}
```

### `meta: PageMeta?`

Current pagination metadata. Read-only.

**Type:** `PageMeta?` (nullable)

**Contains:**
- Page number
- Items per page
- Total count
- Last page
- Has more flag
- Cursors (for cursor-based pagination)
- Offset/limit (for offset-based pagination)

**Example:**
```dart
final meta = state.meta;
if (meta != null) {
  print('Page: ${meta.page}');
  print('Total: ${meta.total}');
  print('Has more: ${meta.hasMore}');
}
```

### `error: PaginationError?`

Current error (if any). Read-only.

**Type:** `PaginationError?` (nullable)

**Error Types:**
- `PaginationError.network()` - Network errors
- `PaginationError.parse()` - Parse errors
- `PaginationError.cancelled()` - Cancellation errors
- `PaginationError.rateLimited()` - Rate limit errors
- `PaginationError.circuitBreaker()` - Circuit breaker errors
- `PaginationError.unknown()` - Unknown errors

**Example:**
```dart
final error = state.error;
if (error != null) {
  print('Error: ${error.message}');
  if (error.isRetryable) {
    // Retry the operation
  }
}
```

### `appendError: PaginationError?`

Append error (non-blocking). Read-only.

**Type:** `PaginationError?` (nullable)

**Note:** This error doesn't block the UI - existing items remain visible.

**Example:**
```dart
final appendError = state.appendError;
if (appendError != null) {
  // Show inline error, allow retry
}
```

### `requestContext: RequestContext?`

Current request context. Read-only.

**Type:** `RequestContext?` (nullable)

**Contains:**
- Generation number (for stale response prevention)
- Cancel token
- Operation type (first, next, refresh)

**Example:**
```dart
final context = state.requestContext;
if (context != null) {
  print('Generation: ${context.generation}');
  print('Is append: ${context.isAppend}');
}
```

### `isStale: bool`

Whether data is stale and needs refresh. Read-only.

**Type:** `bool`

**Default:** `false`

**Example:**
```dart
if (state.isStale) {
  // Refresh data
  controller.refresh();
}
```

### `lastLoadedAt: DateTime?`

Last successful load timestamp. Read-only.

**Type:** `DateTime?` (nullable)

**Example:**
```dart
final lastLoaded = state.lastLoadedAt;
if (lastLoaded != null) {
  final age = DateTime.now().difference(lastLoaded);
  if (age.inMinutes > 5) {
    // Data is old, refresh
    controller.refresh();
  }
}
```

### `query: QueryCriteria?`

Current search and filter criteria. Read-only.

**Type:** `QueryCriteria?` (nullable)

**Contains:**
- Search term
- Filters map
- Sort field
- Sort direction

**Example:**
```dart
final query = state.query;
if (query != null) {
  print('Search: ${query.searchTerm}');
  print('Filters: ${query.filters}');
  print('Sort by: ${query.sortBy}');
}
```

---

## Factory Constructors

### `PaginationState.initial()`

Creates initial state.

```dart
final state = PaginationState.initial();
// status: initial
// items: []
// meta: null
// error: null
```

### `PaginationState.loading({...})`

Creates loading state.

```dart
final state = PaginationState.loading(
  requestContext: requestContext,
  previousItems: existingItems, // Optional
  previousMeta: existingMeta,   // Optional
  query: currentQuery,           // Optional
);
```

### `PaginationState.success({...})`

Creates success state.

```dart
final state = PaginationState.success(
  items: loadedItems,
  meta: pageMeta,
  requestContext: requestContext,
  query: currentQuery, // Optional
);
```

### `PaginationState.empty({...})`

Creates empty state.

```dart
final state = PaginationState.empty(
  requestContext: requestContext,
  query: currentQuery, // Optional
);
```

### `PaginationState.error({...})`

Creates error state.

```dart
final state = PaginationState.error(
  error: paginationError,
  requestContext: requestContext,
  previousItems: existingItems, // Optional
  previousMeta: existingMeta,    // Optional
  query: currentQuery,            // Optional
);
```

### `PaginationState.refreshing({...})`

Creates refreshing state.

```dart
final state = PaginationState.refreshing(
  requestContext: requestContext,
  currentItems: existingItems,
  currentMeta: existingMeta,
  query: currentQuery, // Optional
);
```

### `PaginationState.appending({...})`

Creates appending state.

```dart
final state = PaginationState.appending(
  requestContext: requestContext,
  currentItems: existingItems,
  currentMeta: existingMeta,
  query: currentQuery, // Optional
);
```

### `PaginationState.appendError({...})`

Creates append error state.

```dart
final state = PaginationState.appendError(
  appendError: paginationError,
  requestContext: requestContext,
  currentItems: existingItems,
  currentMeta: existingMeta,
  query: currentQuery, // Optional
);
```

---

## Extension Methods

### `hasData: bool`

Whether the state has data.

```dart
if (state.hasData) {
  // Display items
}
```

### `isLoading: bool`

Whether the state is loading.

```dart
if (state.isLoading) {
  // Show loading indicator
}
```

### `hasError: bool`

Whether the state has an error.

```dart
if (state.hasError) {
  // Show error UI
}
```

### `hasAppendError: bool`

Whether the state has an append error.

```dart
if (state.hasAppendError) {
  // Show append error UI
}
```

### `canLoadMore: bool`

Whether more data can be loaded.

```dart
if (state.canLoadMore) {
  // Load next page
  controller.loadNextPage();
}
```

### `isStable: bool`

Whether the state is in a stable state (not loading).

```dart
if (state.isStable) {
  // Safe to perform operations
}
```

### `isError: bool`

Whether the state is in an error state.

```dart
if (state.isError) {
  // Handle error
}
```

### `isEmpty: bool`

Whether the state is empty.

```dart
if (state.isEmpty) {
  // Show empty state
}
```

### `isSuccess: bool`

Whether the state is successful.

```dart
if (state.isSuccess) {
  // Display data
}
```

### `currentQuery: QueryCriteria`

Gets the current query criteria, or empty criteria if null.

```dart
final query = state.currentQuery;
// Always returns QueryCriteria (never null)
```

---

## Methods

### `copyWith({...})`

Creates a copy of the state with updated fields.

```dart
final newState = state.copyWith(
  items: updatedItems,
  meta: updatedMeta,
);
```

**Note:** Since `PaginationState` uses Freezed, it's immutable. `copyWith` creates a new instance.

---

## Usage Examples

### Check State and Display UI

```dart
Widget buildContent(PaginationState<User> state) {
  return state.status.when(
    initial: () => const LoadingIndicator(),
    loading: () => const LoadingIndicator(),
    success: () => UserList(items: state.items),
    empty: () => const EmptyView(),
    error: () => ErrorView(error: state.error!),
    refreshing: () => UserList(items: state.items),
    appending: () => UserList(items: state.items),
    appendError: () => UserList(items: state.items),
  );
}
```

### Access Items Safely

```dart
void displayItems(PaginationState<User> state) {
  if (state.hasData) {
    for (final user in state.items) {
      print('${user.name} - ${user.email}');
    }
  }
}
```

### Check Pagination Info

```dart
void checkPagination(PaginationState<User> state) {
  final meta = state.meta;
  if (meta != null) {
    print('Current page: ${meta.page}');
    print('Total pages: ${meta.lastPage}');
    print('Total items: ${meta.total}');
    print('Has more: ${meta.hasMore}');
  }
}
```

### Handle Errors

```dart
void handleError(PaginationState<User> state) {
  if (state.hasError) {
    final error = state.error!;
    print('Error: ${error.message}');
    
    if (error.isRetryable) {
      // Show retry button
    }
  }
  
  if (state.hasAppendError) {
    final error = state.appendError!;
    // Show inline error with retry
  }
}
```

---

## State Transitions

### Normal Flow

```
initial → loading → success
```

### Error Flow

```
initial → loading → error
```

### Empty Flow

```
initial → loading → empty
```

### Refresh Flow

```
success → refreshing → success
```

### Append Flow

```
success → appending → success
```

### Append Error Flow

```
success → appending → appendError
```

---

## Best Practices

1. **Use Extension Methods**: Prefer `state.hasData` over `state.items.isNotEmpty`
2. **Check Status First**: Always check `status` before accessing other properties
3. **Handle Nulls**: Always check for null when accessing `meta`, `error`, etc.
4. **Use Pattern Matching**: Use `status.when()` for exhaustive pattern matching
5. **Immutable Updates**: Always use `copyWith()` to create new states

---

## See Also

- [PaginatrixController API](paginatrix-controller.md) - Controller that manages state
- [PaginationStatus API](pagination-status.md) - Status enum reference
- [PageMeta API](page-meta.md) - Metadata reference
- [PaginationError API](pagination-error.md) - Error types reference

---

**Note**: `PaginationState` is immutable. All updates create new instances, ensuring type safety and preventing accidental mutations.

