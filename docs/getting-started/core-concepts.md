# Core Concepts

Understanding the core concepts of Flutter Paginatrix will help you use it effectively.

## Architecture Overview

Flutter Paginatrix follows a clean architecture pattern:

```
┌─────────────────────────────────────┐
│      UI Layer (Widgets)             │
│  PaginatrixListView/GridView       │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   Controller Layer                  │
│   PaginatrixController/Cubit       │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   Data Layer                        │
│   Loader Function + Meta Parser     │
└─────────────────────────────────────┘
```

## Key Components

### 1. PaginatrixController

The main controller that manages pagination state and operations.

**Responsibilities:**
- Loading data (first page, next page, refresh)
- Managing state (loading, success, error)
- Handling search, filters, and sorting
- Request cancellation and retry

**Key Methods:**
- `loadFirstPage()` - Load initial data
- `loadNextPage()` - Load next page (appends)
- `refresh()` - Reload current data
- `search(String)` - Update search term
- `updateQuery(QueryCriteria)` - Update filters/sorting

### 2. Loader Function

A single function that loads paginated data from your API.

**Signature:**
```dart
Future<Map<String, dynamic>> Function({
  int? page,
  int? perPage,
  int? offset,
  int? limit,
  String? cursor,
  CancelToken? cancelToken,
  QueryCriteria? query,
})
```

**Called Automatically:**
- For initial load (page 1)
- For pagination (page 2, 3, etc.)
- For refresh (page 1 again)
- With search/filter parameters

### 3. Meta Parser

Extracts pagination metadata from API responses.

**Types:**
- `ConfigMetaParser` - Pre-configured for common formats
- `CustomMetaParser` - For custom API structures

**What It Does:**
- Extracts items array
- Extracts pagination metadata (page, total, hasMore, etc.)
- Returns structured data for the controller

### 4. PaginationState

Immutable state object containing:
- `items` - List of loaded items
- `status` - Current status (loading, success, error)
- `meta` - Pagination metadata
- `error` - Error information (if any)
- `query` - Search/filter criteria

### 5. UI Widgets

Pre-built widgets that handle UI rendering:
- `PaginatrixListView` - List view with pagination
- `PaginatrixGridView` - Grid view with pagination

**Features:**
- Automatic scroll detection
- Loading indicators
- Error handling
- Empty states
- Pull-to-refresh

## Data Flow

### Initial Load

```
1. User opens page
2. Controller calls loadFirstPage()
3. Loader function called with page=1
4. API returns data
5. Meta parser extracts items and metadata
6. State updated with items
7. UI displays items
```

### Pagination (Load More)

```
1. User scrolls near end
2. Widget detects scroll position
3. Controller calls loadNextPage()
4. Loader function called with page=2
5. API returns next page data
6. Items appended to existing list
7. UI updates with new items
```

### Search/Filter

```
1. User types in search box
2. Controller.updateSearchTerm() called
3. Debounce timer waits (400ms default)
4. Controller reloads first page with search term
5. Loader function receives query parameter
6. API returns filtered results
7. State updated with new items
```

## State Management

Flutter Paginatrix uses `flutter_bloc` internally but provides a clean API:

### Using PaginatrixController (Recommended)

```dart
final controller = PaginatrixController<User>(...);

// No flutter_bloc imports needed!
PaginatrixListView<User>(
  controller: controller,
  itemBuilder: (context, user, index) => UserTile(user),
)
```

### Using PaginatrixCubit (Advanced)

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

final cubit = PaginatrixCubit<User>(...);

BlocProvider(
  create: (_) => cubit,
  child: PaginatrixListView<User>(
    cubit: cubit,
    itemBuilder: (context, user, index) => UserTile(user),
  ),
)
```

## Pagination Strategies

### Page-Based Pagination

```dart
// API: GET /users?page=1&per_page=20
loader: ({page, perPage, ...}) async {
  return await api.get('/users', params: {
    'page': page,
    'per_page': perPage,
  });
}
```

### Offset-Based Pagination

```dart
// API: GET /users?offset=0&limit=20
loader: ({offset, limit, ...}) async {
  return await api.get('/users', params: {
    'offset': offset,
    'limit': limit,
  });
}
```

### Cursor-Based Pagination

```dart
// API: GET /users?cursor=abc123
loader: ({cursor, ...}) async {
  return await api.get('/users', params: {
    'cursor': cursor,
  });
}
```

## Error Handling

Errors are automatically handled and stored in state:

```dart
// Check for errors
if (controller.state.hasError) {
  final error = controller.state.error;
  // Handle error
}

// Retry failed operation
controller.retry();
```

## Best Practices

1. **Always dispose controllers** to prevent memory leaks
2. **Use appropriate meta parser** for your API format
3. **Handle errors** with custom error builders
4. **Configure debouncing** for search to reduce API calls
5. **Use prefetchThreshold** to optimize loading timing

## Next Steps

- Read [Basic Usage](../guides/basic-usage.md) for detailed examples
- Explore [Advanced Usage](../guides/advanced-usage.md) for complex scenarios
- Check [API Reference](../api-reference/) for complete documentation

