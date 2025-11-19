# BLoC Pattern Example

Example demonstrating integration with BLoC pattern.

## Overview

This example shows how to use Flutter Paginatrix with the BLoC pattern, including custom events and state management.

## Features Demonstrated

- ✅ BLoC pattern integration
- ✅ Custom events
- ✅ State management
- ✅ Repository pattern
- ✅ Clean architecture

## Running the Example

```bash
cd examples/bloc_pattern
flutter run
```

## Code Structure

```
examples/bloc_pattern/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── bloc/              # BLoC implementation
│   ├── models/            # Data models
│   ├── pages/            # Page widgets
│   ├── repository/        # Data repository
│   └── widgets/          # Reusable widgets
└── pubspec.yaml
```

## Key Implementation

### BLoC Setup

```dart
class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemsRepository repository;
  late final PaginatrixCubit<Item> paginationCubit;

  ItemsBloc({required this.repository}) : super(ItemsInitial()) {
    paginationCubit = PaginatrixCubit<Item>(
      loader: repository.loadItems,
      itemDecoder: Item.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
  }
}
```

### Using with BLoC

```dart
BlocBuilder<ItemsBloc, ItemsState>(
  builder: (context, state) {
    return PaginatrixListView<Item>(
      cubit: context.read<ItemsBloc>().paginationCubit,
      itemBuilder: (context, item, index) {
        return ItemTile(item: item);
      },
    );
  },
)
```

## What You'll Learn

- How to integrate with BLoC pattern
- How to use PaginatrixCubit with BLoC
- How to structure a clean architecture
- How to handle custom events

## See Also

- [PaginatrixCubit API](../api-reference/paginatrix-cubit.md)
- [Core Concepts](../getting-started/core-concepts.md)




