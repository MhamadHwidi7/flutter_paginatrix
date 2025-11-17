# GridView Example

Pagination example using `PaginatrixGridView` for grid layouts.

## Overview

This example demonstrates pagination in a grid layout, perfect for displaying cards, images, or any grid-based content.

## Features Demonstrated

- ✅ GridView pagination
- ✅ Custom grid layouts
- ✅ Card-based item display
- ✅ Responsive grid design

## Running the Example

```bash
cd examples/grid_view
flutter run
```

## Code Structure

```
examples/grid_view/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── models/
│   ├── pages/
│   └── widgets/
└── pubspec.yaml
```

## Key Code Snippets

### GridView Setup

```dart
PaginatrixGridView<Item>(
  controller: controller,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 0.75,
  ),
  itemBuilder: (context, item, index) {
    return Card(
      child: Column(
        children: [
          Expanded(child: Image.network(item.imageUrl)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.title),
          ),
        ],
      ),
    );
  },
)
```

## What You'll Learn

- How to use GridView with pagination
- How to configure grid layouts
- How to display cards in a grid
- How to handle grid-specific pagination

## See Also

- [Basic Usage Guide](../guides/basic-usage.md)
- [Widgets API Reference](../api-reference/widgets.md)



