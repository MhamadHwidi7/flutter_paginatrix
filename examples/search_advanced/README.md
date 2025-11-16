# Advanced Search, Filter, and Sort Example

This example demonstrates the complete search, filtering, and sorting functionality with `flutter_paginatrix`.

## Features Demonstrated

- ✅ **PaginatrixSearchFilterBar** - Complete search/filter/sort UI component
- ✅ **Multiple Filters** - Filter chips for different categories and criteria
- ✅ **Sorting** - Dropdown with sort field selection and direction toggle
- ✅ **Clear All** - Button to reset all search, filters, and sorting
- ✅ **Combined Query** - All query criteria (search, filters, sort) included in API calls
- ✅ **Reactive UI** - All widgets update automatically when query changes

## How It Works

1. **Search Filter Bar**: The `PaginatrixSearchFilterBar` combines all query UI components
2. **Filter Chips**: Each chip represents a filter option (category, price range, etc.)
3. **Sort Dropdown**: Select sort field and toggle direction by clicking again
4. **Query Criteria**: All criteria stored in `state.query` (searchTerm, filters, sortBy, sortDesc)
5. **Loader Function**: Accesses all query criteria and includes in API call
6. **Automatic Updates**: Results update automatically when any query criteria changes

## Key Code

```dart
// Complete search and filter bar
PaginatrixSearchFilterBar<Product>(
  controller: _controller,
  searchHint: 'Search products...',
  filters: [
    PaginatrixFilterConfig(
      key: 'category',
      value: 'smartphones',
      label: Text('Smartphones'),
    ),
    // ... more filters
  ],
  sortFields: ['title', 'price', 'rating'],
  showClearButton: true,
)

// Loader function includes all query criteria
final query = _controller.state.currentQuery;
if (query.searchTerm.isNotEmpty) 'q': query.searchTerm,
if (query.filters.isNotEmpty) ...query.filters,
if (query.sortBy != null) 'sortBy': query.sortBy,
```

## Running the Example

```bash
cd examples/example_search_advanced
flutter run
```

## Widget Breakdown

- **PaginatrixSearchField**: Handles search input with debouncing
- **PaginatrixFilterChip**: Individual filter option (can be used separately)
- **PaginatrixSortDropdown**: Sort field selection (can be used separately)
- **PaginatrixSearchFilterBar**: Combines all three for convenience


