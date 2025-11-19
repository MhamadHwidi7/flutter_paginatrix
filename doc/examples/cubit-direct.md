# Cubit Direct Example

Example demonstrating direct usage of `PaginatrixCubit`.

## Overview

This example shows how to use `PaginatrixCubit` directly without the `PaginatrixController` wrapper, useful for advanced scenarios or when you want full control.

## Features Demonstrated

- ✅ Direct PaginatrixCubit usage
- ✅ Custom meta parser
- ✅ Advanced configuration
- ✅ Manual state management

## Running the Example

```bash
cd examples/cubit_direct
flutter run
```

## Code Structure

```
examples/cubit_direct/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── models/
│   ├── pages/
│   └── widgets/
└── pubspec.yaml
```

## Key Implementation

### Direct Cubit Usage

```dart
class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late final PaginatrixCubit<Item> _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PaginatrixCubit<Item>(
      loader: _loadItems,
      itemDecoder: Item.fromJson,
      metaParser: CustomMetaParser(_parseMeta),
    );
    _cubit.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadItems({
    int? page,
    int? perPage,
    CancelToken? cancelToken,
  }) async {
    // Load items
  }

  Map<String, dynamic> _parseMeta(Map<String, dynamic> data) {
    // Custom parsing logic
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginatrixGridView<Item>(
        cubit: _cubit,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, item, index) {
          return ItemCard(item: item);
        },
      ),
    );
  }
}
```

## When to Use Direct Cubit

Use `PaginatrixCubit` directly when:
- You need full control over state
- You're integrating with existing BLoC architecture
- You want to use `BlocProvider` and `BlocBuilder`
- You need custom state management

## What You'll Learn

- How to use PaginatrixCubit directly
- How to create custom meta parsers
- How to manage cubit lifecycle
- Advanced state management patterns

## See Also

- [PaginatrixCubit API](../api-reference/paginatrix-cubit.md)
- [Core Concepts](../getting-started/core-concepts.md)




