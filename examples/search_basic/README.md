# Basic Search Example

This example demonstrates the basic search functionality with `flutter_paginatrix`.

## Features Demonstrated

- ✅ **PaginatrixSearchField** - Search text field with automatic debouncing
- ✅ **Automatic Search Integration** - Search term automatically included in API calls
- ✅ **Reactive Updates** - Results update automatically as user types
- ✅ **Debouncing** - Configurable debounce delay (400ms default) to prevent excessive API calls

## How It Works

1. **Search Field**: The `PaginatrixSearchField` widget handles all search UI and debouncing
2. **Query Criteria**: Search term is stored in `state.query.searchTerm`
3. **Loader Function**: Accesses query criteria via `_controller.state.currentQuery`
4. **API Integration**: Search term is included in API query parameters
5. **Automatic Reload**: When search term changes, first page is automatically reloaded

## Key Code

```dart
// Search field with automatic debouncing
PaginatrixSearchField<Product>(
  controller: _controller,
  hintText: 'Search products...',
)

// Loader function includes search term
final query = _controller.state.currentQuery;
if (query.searchTerm.isNotEmpty) 'q': query.searchTerm,
```

## Running the Example

```bash
cd examples/example_search_basic
flutter run
```


