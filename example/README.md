# Flutter Paginatrix Examples

This directory contains the main example application and additional examples demonstrating various use cases and integration patterns for `flutter_paginatrix`.

## 📁 Directory Structure

```
example/
├── lib/                    # Main example (ListView pagination)
│   ├── main.dart
│   ├── app.dart
│   ├── models/
│   └── pages/
├── pubspec.yaml           # Main example dependencies
├── examples/              # Additional examples
│   ├── bloc_pattern/
│   ├── cubit_direct/
│   ├── grid_view/
│   ├── search_basic/
│   ├── search_advanced/
│   ├── web_infinite_scroll/
│   └── web_page_selector/
└── README.md              # This file
```

## 📋 Table of Contents

- [Main Example](#main-example)
- [Additional Examples](#additional-examples)
- [Quick Start](#quick-start)
- [Example Details](#example-details)
- [Running Examples](#running-examples)
- [Best Practices](#best-practices)

---

## 🎯 Main Example

The **main example** is located in the root of this directory (`example/lib/main.dart`). This is the example that pub.dev recognizes and displays. It demonstrates:

- ✅ Basic ListView pagination
- ✅ Automatic infinite scroll
- ✅ Pull-to-refresh functionality
- ✅ Error handling and retry
- ✅ Loading states
- ✅ Empty state handling

**To run the main example:**

```bash
# From the example directory
cd example

# Get dependencies
flutter pub get

# Run the example
flutter run
```

---

## 🚀 Additional Examples

Additional examples are located in the `examples/` subdirectory:

| Example | Description | Key Features |
|---------|-------------|--------------|
| **[`examples/grid_view`](#grid_view)** | GridView pagination | Grid layout, infinite scroll, custom loaders |
| **[`examples/bloc_pattern`](#bloc_pattern)** | BLoC pattern integration | BLoC architecture, best practices, clean code |
| **[`examples/cubit_direct`](#cubit_direct)** | Direct Cubit usage | Minimal setup, direct controller access |
| **[`examples/search_basic`](#search_basic)** | Basic search functionality | Search field, debouncing, reactive updates |
| **[`examples/search_advanced`](#search_advanced)** | Advanced search & filters | Search, filters, sorting, complex queries |
| **[`examples/web_infinite_scroll`](#web_infinite_scroll)** | Web infinite scroll | Web-optimized infinite scrolling |
| **[`examples/web_page_selector`](#web_page_selector)** | Web page selector | Page navigation for web applications |

---

## ⚡ Quick Start

### Main Example

```bash
# Navigate to the example directory
cd example

# Get dependencies
flutter pub get

# Run the example
flutter run
```

### Additional Examples

```bash
# Navigate to a specific example
cd example/examples/grid_view  # Replace with your desired example

# Get dependencies
flutter pub get

# Run the example
flutter run
```

For web examples:

```bash
cd example/examples/web_page_selector
flutter pub get
flutter run -d chrome
```

---

## 📖 Example Details

### `examples/grid_view`

**GridView pagination example**

Shows how to implement pagination with `PaginatrixGridView` for grid layouts.

**Features:**
- ✅ GridView pagination
- ✅ Custom grid delegate
- ✅ Infinite scroll in grid
- ✅ Custom append loaders
- ✅ Responsive grid layouts

**Key Code:**
```dart
PaginatrixGridView<Product>(
  controller: _controller,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  ),
  itemBuilder: (context, product, index) {
    return ProductCard(product: product);
  },
)
```

**Run:**
```bash
cd example/examples/grid_view
flutter run
```

---

### `bloc_pattern`

**BLoC pattern integration with best practices**

Demonstrates how to integrate `flutter_paginatrix` with the BLoC pattern following industry best practices.

**Features:**
- ✅ BLoC architecture pattern
- ✅ Enum-based action dispatching
- ✅ Consolidated event handlers
- ✅ Extension methods for state checks
- ✅ Modular widget architecture
- ✅ Stream subscription best practices
- ✅ Clean separation of concerns

**Architecture Highlights:**
- Single execution path for all actions (DRY principle)
- Type-safe action enums
- Reusable state extension methods
- Proper lifecycle management
- Optimized performance

**Key Code:**
```dart
// BLoC with unified action system
enum PaginatrixBlocAction {
  loadFirst,
  loadNext,
  refresh,
  retry,
  clear,
}

// Clean state checks with extensions
if (state.shouldShowLoading) return LoadingWidget();
if (state.shouldShowError) return ErrorWidget();
```

**Run:**
```bash
cd example/examples/bloc_pattern
flutter run
```

**See:** [`example/bloc_pattern/README.md`](./bloc_pattern/README.md) for detailed architecture documentation.

---

### `cubit_direct`

**Direct PaginatrixCubit usage**

Shows the minimal setup required when using `PaginatrixCubit` directly without additional architecture layers.

**Features:**
- ✅ Direct controller usage
- ✅ Minimal boilerplate
- ✅ Simple state management
- ✅ Quick integration

**Key Code:**
```dart
final cubit = PaginatrixCubit<User>(
  loader: _loadUsers,
  itemDecoder: (json) => User.fromJson(json),
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
);

// Use directly in BlocBuilder
BlocBuilder<PaginatrixCubit<User>, PaginationState<User>>(
  bloc: cubit,
  builder: (context, state) {
    // Build UI based on state
  },
)
```

**Run:**
```bash
cd example/examples/cubit_direct
flutter run
```

---

### `search_basic`

**Basic search functionality with debouncing**

Demonstrates how to implement search functionality with automatic debouncing.

**Features:**
- ✅ Search text field with debouncing
- ✅ Automatic search integration
- ✅ Reactive updates as user types
- ✅ Configurable debounce delay (400ms default)
- ✅ Automatic reload on search change

**Key Code:**
```dart
// Search field with automatic debouncing
PaginatrixSearchField<Product>(
  controller: _controller,
  hintText: 'Search products...',
)

// Loader function includes search term
final query = _controller.state.currentQuery;
if (query.searchTerm.isNotEmpty) {
  queryParameters['q'] = query.searchTerm;
}
```

**Run:**
```bash
cd example/examples/search_basic
flutter run
```

**See:** [`example/search_basic/README.md`](./search_basic/README.md) for detailed documentation.

---

### `search_advanced`

**Advanced search with filters and sorting**

Comprehensive example showing search, filtering, and sorting capabilities.

**Features:**
- ✅ Advanced search functionality
- ✅ Multiple filter types
- ✅ Sorting capabilities
- ✅ Complex query combinations
- ✅ Filter UI components
- ✅ Sort controls

**Key Code:**
```dart
// Update search
_controller.updateSearchTerm('john');

// Add filters
_controller.updateFilters({
  'status': 'active',
  'role': 'admin',
});

// Set sorting
_controller.updateSorting('name', sortDesc: false);
```

**Run:**
```bash
cd example/examples/search_advanced
flutter run
```

---

### `web_infinite_scroll`

**Web-optimized infinite scroll pagination**

Demonstrates pagination optimized for web platforms with infinite scrolling.

**Features:**
- ✅ Web-optimized scrolling
- ✅ Infinite scroll behavior
- ✅ Performance optimizations for web
- ✅ Responsive design

**Run:**
```bash
cd example/examples/web_infinite_scroll
flutter run -d chrome
```

---

### `web_page_selector`

**Web page selector pagination**

Shows how to implement page-based navigation for web applications using the `PageSelector` widget.

**Features:**
- ✅ Page selector widget
- ✅ Multiple display styles (buttons, dropdown, compact)
- ✅ Page navigation controls
- ✅ Web-optimized UI

**Key Code:**
```dart
PageSelector(
  currentPage: _controller.state.meta?.page ?? 1,
  totalPages: _controller.state.meta?.lastPage ?? 1,
  onPageSelected: (page) {
    _controller.loadPage(page);
  },
  style: PageSelectorStyle.buttons,
)
```

**Run:**
```bash
cd example/examples/web_page_selector
flutter run -d chrome
```

---

## 🏃 Running Examples

### Prerequisites

- Flutter SDK (>=3.22.0)
- Dart SDK (>=3.2.0)
- For web examples: Chrome browser

### Steps

1. **Navigate to the example directory:**
   ```bash
   # For main example
   cd example
   
   # For additional examples
   cd example/examples/<example_name>
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the example:**
   ```bash
   # For mobile/desktop
   flutter run

   # For web
   flutter run -d chrome
   ```

### Running All Examples

To test all examples:

```bash
# From the project root
# Run main example
cd example && flutter pub get && flutter run -d chrome --web-port=8080 &

# Run additional examples
for dir in example/examples/*/; do
  if [ -f "$dir/pubspec.yaml" ]; then
    echo "Running example: $dir"
    cd "$dir" && flutter pub get && flutter run -d chrome --web-port=8080 &
    cd ../../..
  fi
done
```

---

## 💡 Best Practices

### 1. Controller Lifecycle

Always dispose controllers properly:

```dart
@override
void dispose() {
  _controller.close();
  super.dispose();
}
```

### 2. Initial Data Loading

Don't forget to load the first page:

```dart
@override
void initState() {
  super.initState();
  _controller.loadFirstPage(); // Required!
}
```

### 3. Error Handling

Always provide error builders:

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

### 4. Meta Parser Configuration

Match your API structure:

```dart
// For nested meta format: {data: [], meta: {page, per_page, ...}}
metaParser: ConfigMetaParser(MetaConfig.nestedMeta),

// For results format: {results: [], page, per_page, ...}
metaParser: ConfigMetaParser(MetaConfig.resultsFormat),

// For custom formats
metaParser: CustomMetaParser((data) {
  return {
    'items': data['products'],
    'meta': {
      'page': data['page'],
      'hasMore': data['has_next'],
    },
  };
}),
```

### 5. Search vs Filters

- **Search** (`updateSearchTerm`): Debounced (400ms), triggers reload after delay
- **Filters** (`updateFilter`): Immediate, triggers reload right away

---

## 📚 Additional Resources

- [Main README](../README.md) - Complete package documentation
- [API Documentation](https://pub.dev/documentation/flutter_paginatrix) - Full API reference
- [GitHub Repository](https://github.com/MhamadHwidi7/flutter_paginatrix) - Source code and issues

---

## 🤝 Contributing

If you create a new example or improve an existing one, please:

1. Follow the existing code style
2. Add comprehensive documentation
3. Include a README.md in the example directory
4. Test on multiple platforms (mobile, web, desktop)
5. Update this README with your example

---

**Happy Coding! 🚀**
