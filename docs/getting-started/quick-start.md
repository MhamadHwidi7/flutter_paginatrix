# Quick Start Guide

Get up and running with Flutter Paginatrix in just a few minutes! This guide will walk you through creating your first paginated list.

---

## Prerequisites

Before you begin, ensure you have:

- ✅ Flutter SDK `>=3.22.0` installed
- ✅ Dart SDK `>=3.2.0 <4.0.0`
- ✅ A Flutter project set up
- ✅ Basic understanding of Flutter widgets and state management

---

## Step 1: Installation

Add `flutter_paginatrix` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_paginatrix: ^1.0.0
  dio: ^5.4.0  # Optional - Only needed if using Dio for HTTP requests
```

Then run:

```bash
flutter pub get
```

See [Installation Guide](installation.md) for detailed setup instructions.

---

## Step 2: Create Your Model

First, create a model class for your data:

```dart
class User {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
```

**Key Points:**
- Your model needs a `fromJson` factory constructor
- The `fromJson` method will be used as the `itemDecoder`

---

## Step 3: Create the Loader Function

Create a function that loads data from your API:

```dart
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
  
  final response = await dio.get(
    'https://api.example.com/users',
    queryParameters: {
      'page': page ?? 1,
      'per_page': perPage ?? 20,
      // Add search if provided
      if (query?.searchTerm.isNotEmpty ?? false)
        'search': query!.searchTerm,
      // Add filters if provided
      ...?query?.filters,
    },
    cancelToken: cancelToken,
  );
  
  return response.data; // Must return Map<String, dynamic>
}
```

**Key Points:**
- The function signature must match exactly (all parameters are optional)
- Must return `Future<Map<String, dynamic>>`
- Use `cancelToken` to support request cancellation
- Access `query` parameter for search/filter/sort criteria

---

## Step 4: Set Up Your API Response Format

Your API should return data in one of these formats:

### Option 1: Nested Meta Format (Recommended)

```json
{
  "data": [
    {"id": 1, "name": "User 1", "email": "user1@example.com"},
    {"id": 2, "name": "User 2", "email": "user2@example.com"}
  ],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total": 100,
    "last_page": 5,
    "has_more": true
  }
}
```

Use: `ConfigMetaParser(MetaConfig.nestedMeta)`

### Option 2: Results Format

```json
{
  "results": [
    {"id": 1, "name": "User 1", "email": "user1@example.com"}
  ],
  "count": 100,
  "page": 1,
  "per_page": 20,
  "has_next": true
}
```

Use: `ConfigMetaParser(MetaConfig.resultsFormat)`

### Option 3: Custom Format

If your API uses a different format, use `CustomMetaParser`:

```dart
final parser = CustomMetaParser((data) {
  final items = data['your_items_key'] as List;
  final meta = PageMeta(
    page: data['your_page_key'] as int,
    perPage: data['your_per_page_key'] as int,
    total: data['your_total_key'] as int,
    hasMore: data['your_has_more_key'] as bool,
  );
  return {
    'items': items,
    'meta': meta.toJson(),
  };
});
```

See [Meta Parsers API](../api-reference/meta-parsers.md) for more details.

---

## Step 5: Create the Controller

Create a `PaginatrixController` in your widget's `initState`:

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
    
    // Create controller
    _controller = PaginatrixController<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    
    // Load first page
    _controller.loadFirstPage();
  }

  // Loader function (from Step 3)
  Future<Map<String, dynamic>> _loadUsers({...}) async {
    // ... implementation
  }

  @override
  void dispose() {
    _controller.close(); // Important: Always close the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... widget tree
  }
}
```

**Key Points:**
- Controller must be created in `initState`
- Always call `loadFirstPage()` after creating the controller
- Always call `close()` in `dispose()` to prevent memory leaks

---

## Step 6: Create the UI

Use `PaginatrixListView` or `PaginatrixGridView` to display your data:

```dart
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
          leading: CircleAvatar(
            child: Text(user.name[0]),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    ),
  );
}
```

**That's it!** Your pagination is now working. The widget will:
- ✅ Automatically load the first page
- ✅ Detect when user scrolls near the end
- ✅ Load the next page automatically
- ✅ Show loading indicators
- ✅ Handle errors gracefully
- ✅ Support pull-to-refresh

---

## Complete Example

Here's the complete working example:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
import 'package:dio/dio.dart';

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}

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
    _controller.close();
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
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
      ),
    );
  }
}
```

---

## What's Happening Behind the Scenes?

1. **Controller Creation**: `PaginatrixController` manages pagination state using `flutter_bloc` internally
2. **Initial Load**: `loadFirstPage()` triggers the loader function with `page=1`
3. **Data Parsing**: Meta parser extracts items and pagination metadata from API response
4. **State Update**: Controller updates state with items and metadata
5. **UI Rendering**: `PaginatrixListView` displays items and handles scrolling
6. **Auto Pagination**: When user scrolls near the end, controller automatically calls `loadNextPage()`
7. **Item Appending**: New items are appended to the existing list

---

## Next Steps

Now that you have a working pagination:

1. **Learn More**: Read [Core Concepts](core-concepts.md) to understand the architecture
2. **Add Features**: Check [Basic Usage](../guides/basic-usage.md) for pull-to-refresh, custom loaders, etc.
3. **Advanced Features**: Explore [Advanced Usage](../guides/advanced-usage.md) for search, filtering, and sorting
4. **Customize**: See [Widgets API](../api-reference/widgets.md) for customization options
5. **Handle Errors**: Read [Error Handling](../guides/error-handling.md) for comprehensive error management

---

## Common Issues

### Items Not Loading?

1. ✅ Check if `loadFirstPage()` is called
2. ✅ Verify loader function returns correct format
3. ✅ Ensure meta parser matches your API format
4. ✅ Check for errors: `controller.state.hasError`

### Pagination Not Working?

1. ✅ Verify `hasMore` is extracted correctly from API
2. ✅ Check `canLoadMore` property: `controller.canLoadMore`
3. ✅ Ensure list has enough items to scroll

### Memory Leaks?

1. ✅ Always call `controller.close()` in `dispose()`
2. ✅ Don't create controller in `build()` method

See [Common Issues](../troubleshooting/common-issues.md) for more solutions.

---

## Additional Resources

- 📖 [Core Concepts](core-concepts.md) - Deep dive into architecture
- 📘 [Basic Usage Guide](../guides/basic-usage.md) - More examples and patterns
- 📚 [API Reference](../api-reference/) - Complete API documentation
- 💡 [Examples](../examples/) - Real-world use cases
- ❓ [FAQ](../troubleshooting/faq.md) - Frequently asked questions

---

**Congratulations!** 🎉 You've successfully set up pagination with Flutter Paginatrix!
