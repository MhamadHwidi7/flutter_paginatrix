# Search Examples

Examples demonstrating search functionality with pagination.

## Overview

Two search examples are available:
- **Basic Search** - Simple search implementation
- **Advanced Search** - Search with filters and sorting

## Basic Search Example

### Features

- ✅ Simple search input
- ✅ Debounced search
- ✅ Search results pagination
- ✅ Empty state handling

### Running

```bash
cd examples/search_basic
flutter run
```

### Key Implementation

```dart
TextField(
  onChanged: (value) {
    controller.search(value);
  },
)
```

## Advanced Search Example

### Features

- ✅ Search with multiple filters
- ✅ Sorting options
- ✅ Combined query parameters
- ✅ Filter UI components

### Running

```bash
cd examples/search_advanced
flutter run
```

### Key Implementation

```dart
// Search
controller.search(searchTerm);

// Filters
controller.updateFilters({
  'status': 'active',
  'category': 'electronics',
});

// Sorting
controller.updateSorting('price', sortDesc: true);

// Combined
controller.updateQuery(
  QueryCriteria()
    .withSearchTerm('laptop')
    .withFilters({'category': 'electronics'})
    .withSort('price', descending: false),
);
```

## What You'll Learn

- How to implement search
- How to add filters
- How to implement sorting
- How to combine search, filters, and sorting
- How to debounce search input

## See Also

- [Advanced Usage Guide](../guides/advanced-usage.md)
- [PaginatrixController API](../api-reference/paginatrix-controller.md)



