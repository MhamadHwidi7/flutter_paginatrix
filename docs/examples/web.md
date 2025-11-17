# Web Examples

Examples optimized for web applications.

## Overview

Two web-specific examples are available:
- **Infinite Scroll** - Web infinite scroll pagination
- **Page Selector** - Web page selector pagination

## Infinite Scroll Example

### Features

- ✅ Web-optimized infinite scroll
- ✅ Smooth scrolling
- ✅ Performance optimizations
- ✅ Web-specific UI

### Running

```bash
cd examples/web_infinite_scroll
flutter run -d chrome
```

### Key Implementation

```dart
PaginatrixListView<Item>(
  controller: controller,
  itemBuilder: (context, item, index) {
    return ItemCard(item: item);
  },
  cacheExtent: 500, // Larger cache for web
  prefetchThreshold: 5, // Load earlier on web
)
```

## Page Selector Example

### Features

- ✅ Page selector widget
- ✅ Direct page navigation
- ✅ Page number display
- ✅ Web-optimized UI

### Running

```bash
cd examples/web_page_selector
flutter run -d chrome
```

### Key Implementation

```dart
// Display page selector
PageSelector(
  currentPage: controller.state.meta?.page ?? 1,
  totalPages: controller.state.meta?.lastPage ?? 1,
  onPageChanged: (page) {
    // Navigate to specific page
    controller.loadPage(page);
  },
  style: PageSelectorStyle.buttons,
)

// Or use dropdown style
PageSelector(
  currentPage: controller.state.meta?.page ?? 1,
  totalPages: controller.state.meta?.lastPage ?? 1,
  onPageChanged: (page) {
    controller.loadPage(page);
  },
  style: PageSelectorStyle.dropdown,
)
```

## Web-Specific Considerations

### Performance

- Use larger `cacheExtent` for smoother scrolling
- Increase `prefetchThreshold` for earlier loading
- Enable all optimizations:

```dart
PaginatrixListView<Item>(
  controller: controller,
  addAutomaticKeepAlives: true,
  addRepaintBoundaries: true,
  cacheExtent: 500,
  prefetchThreshold: 5,
  itemBuilder: (context, item, index) => ItemCard(item: item),
)
```

### UI/UX

- Use `PageSelector` for direct page navigation
- Consider dropdown style for mobile web
- Implement keyboard navigation
- Add loading states for better UX

## What You'll Learn

- How to optimize for web
- How to use page selector
- How to implement infinite scroll on web
- Web-specific performance tips

## See Also

- [Performance Guide](../guides/performance.md)
- [PageSelector API](../api-reference/widgets.md#pageselector)



