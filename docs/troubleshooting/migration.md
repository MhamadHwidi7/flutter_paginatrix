# Migration Guide

Guide for migrating to Flutter Paginatrix from other pagination solutions or upgrading between versions.

---

## Table of Contents

- [Migrating from Other Packages](#migrating-from-other-packages)
- [Upgrading Between Versions](#upgrading-between-versions)
- [Breaking Changes](#breaking-changes)
- [Migration Checklist](#migration-checklist)

---

## Migrating from Other Packages

### From `infinite_scroll_pagination`

#### Key Differences

1. **Single Loader Function**: Flutter Paginatrix uses one loader function for all operations
2. **Meta Parser**: Requires a meta parser to extract pagination info
3. **State Management**: Uses `flutter_bloc` internally (but provides clean API)

#### Migration Steps

**Before (infinite_scroll_pagination):**
```dart
final paginationController = PagingController<int, User>(
  firstPageKey: 1,
);

paginationController.addPageRequestListener((pageKey) {
  _fetchPage(pageKey);
});

Future<void> _fetchPage(int pageKey) async {
  try {
    final items = await repository.getUsers(page: pageKey);
    final isLastPage = items.length < pageSize;
    
    if (isLastPage) {
      paginationController.appendLastPage(items);
    } else {
      final nextPageKey = pageKey + 1;
      paginationController.appendPage(items, nextPageKey);
    }
  } catch (error) {
    paginationController.error = error;
  }
}
```

**After (Flutter Paginatrix):**
```dart
final controller = PaginatrixController<User>(
  loader: _loadUsers,
  itemDecoder: User.fromJson,
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
);

Future<Map<String, dynamic>> _loadUsers({
  int? page,
  int? perPage,
  CancelToken? cancelToken,
}) async {
  final response = await dio.get(
    '/users',
    queryParameters: {
      'page': page ?? 1,
      'per_page': perPage ?? 20,
    },
    cancelToken: cancelToken,
  );
  return response.data; // API must return items + meta
}
```

#### Widget Migration

**Before:**
```dart
PagedListView<int, User>(
  pagingController: paginationController,
  builderDelegate: PagedChildBuilderDelegate<User>(
    itemBuilder: (context, user, index) => UserTile(user: user),
  ),
)
```

**After:**
```dart
PaginatrixListView<User>(
  controller: controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

---

### From `flutter_infinite_listview`

#### Key Differences

1. **State Management**: Flutter Paginatrix uses Cubit/Bloc
2. **Error Handling**: Built-in comprehensive error handling
3. **Meta Parsing**: Automatic metadata extraction

#### Migration Steps

**Before:**
```dart
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    on<UsersFetch>(_onUsersFetch);
  }
  
  Future<void> _onUsersFetch(
    UsersFetch event,
    Emitter<UsersState> emit,
  ) async {
    // Manual pagination logic
  }
}
```

**After:**
```dart
final controller = PaginatrixController<User>(
  loader: _loadUsers,
  itemDecoder: User.fromJson,
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
);
// No need for custom Bloc - controller handles everything
```

---

### From Custom Pagination Implementation

#### Migration Checklist

1. **Extract Loader Function**
   - Create a function that loads data from your API
   - Function must return `Future<Map<String, dynamic>>`
   - Include all pagination parameters

2. **Create Meta Parser**
   - Use `ConfigMetaParser` if your API matches standard formats
   - Use `CustomMetaParser` for custom formats

3. **Replace State Management**
   - Remove custom state management code
   - Use `PaginatrixController` instead

4. **Update UI Widgets**
   - Replace custom list widgets with `PaginatrixListView` or `PaginatrixGridView`
   - Remove manual scroll detection code

5. **Update Error Handling**
   - Remove custom error handling
   - Use built-in error builders

---

## Upgrading Between Versions

### From 0.x to 1.0.0

#### Breaking Changes

1. **Method Name Change**: `dispose()` → `close()`

**Before:**
```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

**After:**
```dart
@override
void dispose() {
  _controller.close(); // Changed from dispose()
  super.dispose();
}
```

2. **Search Method**: `search()` → `updateSearchTerm()`

**Before:**
```dart
_controller.search('john');
```

**After:**
```dart
_controller.updateSearchTerm('john');
```

3. **Query Updates**: `updateQuery()` → `updateFilter()`, `updateSorting()`

**Before:**
```dart
_controller.updateQuery(QueryCriteria(
  searchTerm: 'john',
  filters: {'status': 'active'},
));
```

**After:**
```dart
_controller.updateSearchTerm('john');
_controller.updateFilter('status', 'active');
```

#### Migration Steps

1. **Update Method Calls**
   - Replace `dispose()` with `close()`
   - Replace `search()` with `updateSearchTerm()`
   - Replace `updateQuery()` with individual methods

2. **Update Imports**
   - No import changes needed

3. **Test Thoroughly**
   - Test all pagination operations
   - Verify error handling still works
   - Check search and filter functionality

---

## Breaking Changes

### Version 1.0.0

#### Method Renames

| Old Method | New Method | Notes |
|------------|------------|-------|
| `dispose()` | `close()` | Controller cleanup |
| `search()` | `updateSearchTerm()` | Search updates |
| `updateQuery()` | `updateFilter()`, `updateSorting()` | Query updates |

#### API Changes

1. **Loader Function Signature**
   - Added `QueryCriteria?` parameter
   - All parameters remain optional

2. **State Properties**
   - Added `query` property to state
   - Added `isStale` property
   - Added `lastLoadedAt` property

---

## Migration Checklist

### Pre-Migration

- [ ] Review current pagination implementation
- [ ] Identify all pagination-related code
- [ ] List all API endpoints used
- [ ] Document current error handling
- [ ] Note any custom features

### During Migration

- [ ] Install Flutter Paginatrix
- [ ] Create loader function
- [ ] Set up meta parser
- [ ] Replace state management
- [ ] Update UI widgets
- [ ] Update error handling
- [ ] Update search/filter logic
- [ ] Test all functionality

### Post-Migration

- [ ] Verify all features work
- [ ] Test error scenarios
- [ ] Check performance
- [ ] Update documentation
- [ ] Remove old code
- [ ] Update tests

---

## Common Migration Issues

### Issue: Items Not Loading

**Solution:**
1. Verify `loadFirstPage()` is called
2. Check loader function returns correct format
3. Verify meta parser configuration
4. Check API response structure

### Issue: Pagination Not Working

**Solution:**
1. Verify `hasMore` is extracted correctly
2. Check meta parser extracts pagination info
3. Verify `canLoadMore` is true
4. Check prefetch threshold

### Issue: Search Not Working

**Solution:**
1. Use `updateSearchTerm()` instead of `search()`
2. Verify loader function reads `query` parameter
3. Check debounce duration
4. Verify API accepts search parameter

### Issue: Errors Not Displaying

**Solution:**
1. Provide error builders
2. Check error handling in loader function
3. Verify error types are correct
4. Check state for errors

---

## Migration Examples

### Complete Migration Example

**Before (Custom Implementation):**
```dart
class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> _users = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  
  @override
  void initState() {
    super.initState();
    _loadUsers();
  }
  
  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final response = await dio.get('/users', params: {
        'page': _currentPage,
      });
      final newUsers = (response.data['data'] as List)
          .map((json) => User.fromJson(json))
          .toList();
      setState(() {
        _users.addAll(newUsers);
        _hasMore = response.data['meta']['has_more'];
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _users.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _users.length) {
          if (_isLoading) {
            return LoadingIndicator();
          }
          _loadUsers();
          return SizedBox.shrink();
        }
        return UserTile(user: _users[index]);
      },
    );
  }
}
```

**After (Flutter Paginatrix):**
```dart
class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
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
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      '/users',
      queryParameters: {
        'page': page ?? 1,
        'per_page': perPage ?? 20,
      },
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
    return PaginatrixListView<User>(
      controller: _controller,
      itemBuilder: (context, user, index) {
        return UserTile(user: user);
      },
    );
  }
}
```

**Benefits:**
- ✅ Less code (50% reduction)
- ✅ Built-in error handling
- ✅ Automatic pagination
- ✅ Better performance
- ✅ Type-safe

---

## Getting Help

If you encounter issues during migration:

1. Check [Common Issues](common-issues.md)
2. Review [FAQ](faq.md)
3. Search [GitHub Issues](https://github.com/MhamadHwidi7/flutter_paginatrix/issues)
4. Create a new issue with migration details

---

## Additional Resources

- 📖 [Quick Start Guide](../getting-started/quick-start.md) - Get started quickly
- 📘 [API Reference](../api-reference/) - Complete API documentation
- 💡 [Examples](../examples/) - Real-world examples
- 🔧 [Troubleshooting](common-issues.md) - Common problems and solutions

---

**Note**: Migration can be done incrementally. You don't need to migrate everything at once. Start with one page/feature and gradually migrate the rest.

