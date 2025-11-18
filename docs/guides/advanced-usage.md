# Advanced Usage Guide

Learn advanced features like search, filtering, sorting, and custom configurations.

## Table of Contents

- [Search Functionality](#search-functionality)
- [Filtering](#filtering)
- [Sorting](#sorting)
- [Combining Search, Filters, and Sorting](#combining-search-filters-and-sorting)
- [Custom Meta Parsers](#custom-meta-parsers)
- [Configuration Options](#configuration-options)
- [Request Cancellation](#request-cancellation)

## Search Functionality

Implement search with automatic debouncing:

```dart
class SearchableUsersPage extends StatefulWidget {
  const SearchableUsersPage({super.key});

  @override
  State<SearchableUsersPage> createState() => _SearchableUsersPageState();
}

class _SearchableUsersPageState extends State<SearchableUsersPage> {
  late final PaginatrixController<User> _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = PaginatrixController<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      options: PaginationOptions(
        searchDebounceDuration: Duration(milliseconds: 500),
      ),
    );
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
    CancelToken? cancelToken,
    QueryCriteria? query,
  }) async {
    final dio = Dio();
    final params = <String, dynamic>{
      'page': page ?? 1,
      'per_page': perPage ?? 20,
    };
    
    // Add search term if provided
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

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _controller.search(value);
              },
            ),
          ),
          Expanded(
            child: PaginatrixListView<User>(
              controller: _controller,
              itemBuilder: (context, user, index) {
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## Filtering

Add filters to your pagination:

```dart
// Add a filter
_controller.updateQuery(
  QueryCriteria().withFilter('status', 'active'),
);

// Add multiple filters
_controller.updateQuery(
  QueryCriteria().withFilters({
    'status': 'active',
    'role': 'admin',
    'age': 25,
  }),
);

// Update loader to use filters
Future<Map<String, dynamic>> _loadUsers({
  int? page,
  int? perPage,
  CancelToken? cancelToken,
  QueryCriteria? query,
}) async {
  final dio = Dio();
  final params = <String, dynamic>{
    'page': page ?? 1,
    'per_page': perPage ?? 20,
  };
  
  // Add filters if provided
  if (query?.filters != null) {
    params.addAll(query!.filters!.map((key, value) => 
      MapEntry(key, value.toString())
    ));
  }
  
  final response = await dio.get(
    'https://api.example.com/users',
    queryParameters: params,
    cancelToken: cancelToken,
  );
  return response.data;
}
```

### Filter Value Types

Filters support various types:

```dart
// String filter
QueryCriteria().withFilter('status', 'active')

// Integer filter
QueryCriteria().withFilter('age', 25)

// Boolean filter
QueryCriteria().withFilter('enabled', true)

// Double filter
QueryCriteria().withFilter('price', 99.99)

// List filter
QueryCriteria().withFilter('tags', ['tag1', 'tag2'])
```

## Sorting

Implement sorting:

```dart
// Sort by name ascending
_controller.updateSorting('name', sortDesc: false);

// Sort by price descending
_controller.updateSorting('price', sortDesc: true);

// Clear sorting
_controller.updateSorting(null);

// Update loader to use sorting
Future<Map<String, dynamic>> _loadUsers({
  int? page,
  int? perPage,
  CancelToken? cancelToken,
  QueryCriteria? query,
}) async {
  final dio = Dio();
  final params = <String, dynamic>{
    'page': page ?? 1,
    'per_page': perPage ?? 20,
  };
  
  // Add sorting if provided
  if (query?.sortBy != null) {
    params['sort_by'] = query!.sortBy;
    params['sort_desc'] = query.sortDesc;
  }
  
  final response = await dio.get(
    'https://api.example.com/users',
    queryParameters: params,
    cancelToken: cancelToken,
  );
  return response.data;
}
```

## Combining Search, Filters, and Sorting

Combine all query parameters:

```dart
// Update query with all parameters
_controller.updateQuery(
  QueryCriteria()
    .withSearchTerm('john')
    .withFilters({
      'status': 'active',
      'role': 'admin',
    })
    .withSort('name', descending: false),
);

// Or use copyWith
_controller.updateQuery(
  QueryCriteria().copyWith(
    searchTerm: 'john',
    filters: {'status': 'active'},
    sortBy: 'name',
    sortDesc: false,
  ),
);
```

## Custom Meta Parsers

For APIs that don't match standard formats:

```dart
final parser = CustomMetaParser((data) {
  // Extract items
  final items = data['results'] as List;
  
  // Extract metadata
  final meta = PageMeta(
    page: data['currentPage'] as int,
    perPage: data['pageSize'] as int,
    total: data['totalCount'] as int,
    hasMore: data['hasNext'] as bool,
  );
  
  return {
    'items': items,
    'meta': meta.toJson(),
  };
});

final controller = PaginatrixController<User>(
  loader: _loadUsers,
  itemDecoder: User.fromJson,
  metaParser: parser,
);
```

## Configuration Options

Customize pagination behavior:

```dart
final options = PaginationOptions(
  // Page size
  defaultPageSize: 20,
  maxPageSize: 100,
  
  // Request timeout
  requestTimeout: Duration(seconds: 30),
  
  // Retry configuration
  maxRetries: 5,
  initialBackoff: Duration(milliseconds: 500),
  retryResetTimeout: Duration(seconds: 60),
  
  // Debouncing
  refreshDebounceDuration: Duration(milliseconds: 300),
  searchDebounceDuration: Duration(milliseconds: 400),
  
  // Debug logging
  enableDebugLogging: true,
);

final controller = PaginatrixController<User>(
  loader: _loadUsers,
  itemDecoder: User.fromJson,
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
  options: options,
);
```

## Request Cancellation

Cancel in-flight requests:

```dart
// Cancel current request
_controller.cancel();

// Clear all data and reset
_controller.clear();

// Automatically cancelled when:
// - Navigating away from page (if disposed)
// - Starting a new request
// - Refreshing data
```

## Advanced Example: Complete Search & Filter UI

```dart
class AdvancedSearchPage extends StatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  State<AdvancedSearchPage> createState() => _AdvancedSearchPageState();
}

class _AdvancedSearchPageState extends State<AdvancedSearchPage> {
  late final PaginatrixController<User> _controller;
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';
  String _sortBy = 'name';
  bool _sortDesc = false;

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
    CancelToken? cancelToken,
    QueryCriteria? query,
  }) async {
    final dio = Dio();
    final params = <String, dynamic>{
      'page': page ?? 1,
      'per_page': perPage ?? 20,
    };
    
    if (query?.searchTerm != null && query!.searchTerm!.isNotEmpty) {
      params['search'] = query.searchTerm;
    }
    
    if (query?.filters != null) {
      params.addAll(query!.filters!.map((key, value) => 
        MapEntry(key, value.toString())
      ));
    }
    
    if (query?.sortBy != null) {
      params['sort_by'] = query!.sortBy;
      params['sort_desc'] = query.sortDesc;
    }
    
    final response = await dio.get(
      'https://api.example.com/users',
      queryParameters: params,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  void _applyFilters() {
    final filters = <String, dynamic>{};
    if (_selectedStatus != 'all') {
      filters['status'] = _selectedStatus;
    }
    
    _controller.updateQuery(
      QueryCriteria()
        .withSearchTerm(_searchController.text)
        .withFilters(filters)
        .withSort(_sortBy, descending: _sortDesc),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Search')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => _controller.search(value),
            ),
          ),
          // Filters
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: ['all', 'active', 'inactive']
                    .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ))
                    .toList(),
                  onChanged: (value) {
                    setState(() => _selectedStatus = value!);
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _sortBy,
                  items: ['name', 'email', 'created_at']
                    .map((field) => DropdownMenuItem(
                      value: field,
                      child: Text(field),
                    ))
                    .toList(),
                  onChanged: (value) {
                    setState(() => _sortBy = value!);
                    _applyFilters();
                  },
                ),
                IconButton(
                  icon: Icon(_sortDesc ? Icons.arrow_downward : Icons.arrow_upward),
                  onPressed: () {
                    setState(() => _sortDesc = !_sortDesc);
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: PaginatrixListView<User>(
              controller: _controller,
              itemBuilder: (context, user, index) {
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## Next Steps

- Learn about [Error Handling](error-handling.md)
- Explore [Customization](customization.md)
- Check [Performance Optimization](performance.md)




