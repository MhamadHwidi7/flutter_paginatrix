# ListView Example

Basic pagination example using `PaginatrixListView`.

## Overview

This example demonstrates the simplest use case - a paginated list view with automatic loading on scroll.

## Features Demonstrated

- ✅ Basic pagination setup
- ✅ ListView with automatic scroll detection
- ✅ Loading indicators
- ✅ Error handling
- ✅ Pull-to-refresh
- ✅ Performance monitoring

## Running the Example

```bash
cd examples/list_view
flutter run
```

## Code Structure

```
examples/list_view/
├── lib/
│   ├── main.dart          # App entry point
│   ├── app.dart           # Main app widget
│   ├── models/            # Data models
│   └── pages/            # Page widgets
└── pubspec.yaml
```

## Key Code Snippets

### Controller Setup

```dart
final controller = PaginatrixController<Item>(
  loader: _loadItems,
  itemDecoder: Item.fromJson,
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
);
```

### ListView Usage

```dart
PaginatrixListView<Item>(
  controller: controller,
  itemBuilder: (context, item, index) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.description),
    );
  },
)
```

## What You'll Learn

- How to set up basic pagination
- How to configure meta parsers
- How to handle loading states
- How to implement pull-to-refresh

## See Also

- [Basic Usage Guide](../guides/basic-usage.md)
- [Quick Start Guide](../getting-started/quick-start.md)

