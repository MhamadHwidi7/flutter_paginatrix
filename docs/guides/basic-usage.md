# Basic Usage Guide

Learn how to use Flutter Paginatrix for common pagination scenarios.

## Table of Contents

- [Simple ListView](#simple-listview)
- [GridView Pagination](#gridview-pagination)
- [Pull-to-Refresh](#pull-to-refresh)
- [Custom Loaders](#custom-loaders)
- [Empty States](#empty-states)
- [Error Handling](#error-handling)

## Simple ListView

The most common use case - a paginated list view:

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
    CancelToken? cancelToken,
  }) async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.example.com/users',
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: PaginatrixListView<User>(
        controller: _controller,
        itemBuilder: (context, user, index) {
          return ListTile(
            leading: CircleAvatar(child: Text(user.name[0])),
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
      ),
    );
  }
}
```

## GridView Pagination

Display items in a grid layout:

```dart
PaginatrixGridView<User>(
  controller: _controller,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 0.75,
  ),
  itemBuilder: (context, user, index) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(user.avatarUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(user.name),
          ),
        ],
      ),
    );
  },
)
```

## Pull-to-Refresh

Enable pull-to-refresh functionality:

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  onPullToRefresh: () async {
    await _controller.refresh();
  },
)
```

## Custom Loaders

Customize the loading indicator:

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  appendLoaderBuilder: (context) => AppendLoader(
    loaderType: LoaderType.pulse,
    message: 'Loading more users...',
    color: Theme.of(context).colorScheme.primary,
    size: 28,
    padding: const EdgeInsets.all(20),
  ),
)
```

Available loader types:
- `LoaderType.bouncingDots`
- `LoaderType.wave`
- `LoaderType.rotatingSquares`
- `LoaderType.pulse`
- `LoaderType.skeleton`
- `LoaderType.traditional`

## Empty States

Customize empty state display:

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  emptyBuilder: (context) => PaginatrixSearchEmptyView(
    message: 'No users found',
    icon: Icons.people_outline,
  ),
)
```

Pre-built empty views:
- `PaginatrixGenericEmptyView` - Generic empty state
- `PaginatrixSearchEmptyView` - Search empty state
- `PaginatrixNetworkEmptyView` - Network error empty state

## Error Handling

Handle errors gracefully:

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
  onRetryInitial: () {
    _controller.retry();
  },
  appendErrorBuilder: (context, error, onRetry) {
    return PaginatrixAppendErrorView(
      error: error,
      onRetry: onRetry,
    );
  },
  onRetryAppend: () {
    _controller.retry();
  },
)
```

## Complete Example

Here's a complete example with all features:

```dart
class CompleteExample extends StatefulWidget {
  const CompleteExample({super.key});

  @override
  State<CompleteExample> createState() => _CompleteExampleState();
}

class _CompleteExampleState extends State<CompleteExample> {
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
    final dio = Dio();
    final response = await dio.get(
      'https://api.example.com/users',
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
    _controller.dispose();
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
            leading: CircleAvatar(child: Text(user.name[0])),
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
        onPullToRefresh: () => _controller.refresh(),
        errorBuilder: (context, error, onRetry) {
          return PaginatrixErrorView(
            error: error,
            onRetry: onRetry,
          );
        },
        emptyBuilder: (context) {
          return PaginatrixGenericEmptyView(
            message: 'No users available',
          );
        },
        appendLoaderBuilder: (context) {
          return AppendLoader(
            loaderType: LoaderType.pulse,
            message: 'Loading more...',
          );
        },
      ),
    );
  }
}
```

## Next Steps

- Learn about [Advanced Usage](advanced-usage.md) for search, filtering, and sorting
- Explore [Error Handling](error-handling.md) for comprehensive error management
- Check [Customization](customization.md) for advanced UI customization



