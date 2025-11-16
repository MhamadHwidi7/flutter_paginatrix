# Widgets API Reference

Complete reference for Flutter Paginatrix UI widgets.

## PaginatrixListView

ListView widget with built-in pagination support.

### Constructor

```dart
PaginatrixListView<T>({
  Key? key,
  PaginatrixCubit<T>? cubit,
  PaginatrixController<T>? controller,
  required Widget Function(BuildContext, T, int) itemBuilder,
  String? Function(T, int)? keyBuilder,
  int? prefetchThreshold,
  EdgeInsets? padding,
  ScrollPhysics? physics,
  bool shrinkWrap = false,
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  Widget? Function(BuildContext, int)? separatorBuilder,
  Widget? Function(BuildContext)? skeletonizerBuilder,
  Widget? Function(BuildContext)? emptyBuilder,
  Widget? Function(BuildContext, PaginationError, VoidCallback)? errorBuilder,
  Widget? Function(BuildContext, PaginationError, VoidCallback)? appendErrorBuilder,
  Widget? Function(BuildContext)? appendLoaderBuilder,
  Future<void> Function()? onPullToRefresh,
  VoidCallback? onRetryInitial,
  VoidCallback? onRetryAppend,
  String? endOfListMessage,
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  bool addSemanticIndexes = false,
  double? cacheExtent,
})
```

### Required Parameters

- **`itemBuilder`** - Function to build each item widget
- **`controller` or `cubit`** - Pagination controller (one required)

### Key Parameters

- **`prefetchThreshold`** - Number of items from end to trigger next page load (default: 3)
- **`padding`** - Padding around the list
- **`physics`** - Scroll physics behavior
- **`scrollDirection`** - Scroll direction (vertical or horizontal)
- **`reverse`** - Whether to reverse scroll direction
- **`errorBuilder`** - Custom error widget
- **`emptyBuilder`** - Custom empty state widget
- **`appendLoaderBuilder`** - Custom loading indicator
- **`onPullToRefresh`** - Callback for pull-to-refresh
- **`cacheExtent`** - Cache extent for scroll view

## PaginatrixGridView

GridView widget with built-in pagination support.

### Constructor

```dart
PaginatrixGridView<T>({
  Key? key,
  PaginatrixCubit<T>? cubit,
  PaginatrixController<T>? controller,
  required Widget Function(BuildContext, T, int) itemBuilder,
  required SliverGridDelegate gridDelegate,
  String? Function(T, int)? keyBuilder,
  int? prefetchThreshold,
  EdgeInsets? padding,
  ScrollPhysics? physics,
  bool shrinkWrap = false,
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  Widget? Function(BuildContext)? skeletonizerBuilder,
  Widget? Function(BuildContext)? emptyBuilder,
  Widget? Function(BuildContext, PaginationError, VoidCallback)? errorBuilder,
  Widget? Function(BuildContext, PaginationError, VoidCallback)? appendErrorBuilder,
  Widget? Function(BuildContext)? appendLoaderBuilder,
  Future<void> Function()? onPullToRefresh,
  VoidCallback? onRetryInitial,
  VoidCallback? onRetryAppend,
  String? endOfListMessage,
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  bool addSemanticIndexes = false,
  double? cacheExtent,
})
```

### Required Parameters

- **`itemBuilder`** - Function to build each item widget
- **`gridDelegate`** - Grid layout configuration
- **`controller` or `cubit`** - Pagination controller (one required)

## AppendLoader

Loading indicator widget with multiple animation types.

### Constructor

```dart
AppendLoader({
  Key? key,
  required LoaderType loaderType,
  String? message,
  Color? color,
  double size = 24.0,
  EdgeInsets padding = const EdgeInsets.all(16.0),
})
```

### Loader Types

- `LoaderType.bouncingDots` - Bouncing dots animation
- `LoaderType.wave` - Wave animation
- `LoaderType.rotatingSquares` - Rotating squares animation
- `LoaderType.pulse` - Pulse animation
- `LoaderType.skeleton` - Skeleton loading effect
- `LoaderType.traditional` - Traditional spinner

## PaginatrixErrorView

Error display widget with retry functionality.

### Constructor

```dart
PaginatrixErrorView({
  Key? key,
  required PaginationError error,
  required VoidCallback onRetry,
  String? title,
  String? message,
  Widget? icon,
})
```

## PaginatrixAppendErrorView

Inline error view for append failures.

### Constructor

```dart
PaginatrixAppendErrorView({
  Key? key,
  required PaginationError error,
  required VoidCallback onRetry,
  String? message,
})
```

## PaginatrixEmptyView

Base empty state widget.

### Constructor

```dart
PaginatrixEmptyView({
  Key? key,
  required String message,
  Widget? icon,
  Widget? action,
})
```

## Pre-built Empty Views

### PaginatrixGenericEmptyView

Generic empty state.

```dart
PaginatrixGenericEmptyView({
  Key? key,
  String? message,
  Widget? icon,
})
```

### PaginatrixSearchEmptyView

Search empty state.

```dart
PaginatrixSearchEmptyView({
  Key? key,
  String? message,
  Widget? icon,
})
```

### PaginatrixNetworkEmptyView

Network error empty state.

```dart
PaginatrixNetworkEmptyView({
  Key? key,
  String? message,
  Widget? icon,
})
```

## PageSelector

Page selection widget for web applications.

### Constructor

```dart
PageSelector({
  Key? key,
  required int currentPage,
  required int totalPages,
  required ValueChanged<int> onPageChanged,
  PageSelectorStyle style = PageSelectorStyle.buttons,
  int maxVisiblePages = 7,
})
```

### Styles

- `PageSelectorStyle.buttons` - Button-based selector
- `PageSelectorStyle.dropdown` - Dropdown selector
- `PageSelectorStyle.compact` - Compact button selector

## Usage Examples

### Basic ListView

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  },
)
```

### GridView with Custom Loader

```dart
PaginatrixGridView<User>(
  controller: _controller,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemBuilder: (context, user, index) => UserCard(user: user),
  appendLoaderBuilder: (context) => AppendLoader(
    loaderType: LoaderType.pulse,
    message: 'Loading more...',
  ),
)
```

### Custom Error Handling

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
)
```

## See Also

- [PaginatrixController](paginatrix-controller.md) - Controller API
- [Basic Usage](../guides/basic-usage.md) - Usage examples

