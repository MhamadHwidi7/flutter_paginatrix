# Cubit Example - Direct Usage

This example demonstrates the **simplest and most direct** way to use `flutter_paginatrix` with `PaginatrixCubit` and `BlocBuilder`.

## 🎯 What's Different?

### vs example_bloc_pattern
- **example_bloc_pattern**: Wraps `PaginatrixController` in a custom BLoC with events
- **example_cubit_direct**: Uses `PaginatrixCubit` **directly** - no wrapper needed!

### Key Advantages

✅ **Less Boilerplate** - No need to create custom events and states  
✅ **Simpler Code** - Direct cubit usage  
✅ **BlocBuilder Native** - Built-in flutter_bloc integration  
✅ **Auto Cleanup** - No manual stream management  

---

## 📖 Quick Start

### 1. Create the Cubit

```dart
final cubit = PaginatrixCubit<Pokemon>(
  loader: _loadPokemonPage,
  itemDecoder: Pokemon.fromJson,
  metaParser: CustomMetaParser(
    itemsExtractor: (data) => data['results'],
    metaExtractor: (data) => PageMeta(...),
  ),
);

// Load first page
cubit.loadFirstPage();
```

### 2. Use with BlocBuilder

**Option A: PaginatrixCubitGridView** (Recommended)
```dart
PaginatrixCubitGridView<Pokemon>(
  cubit: cubit,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
  ),
  itemBuilder: (context, pokemon, index) {
    return PokemonCard(pokemon: pokemon);
  },
)
```

**Option B: Manual BlocBuilder**
```dart
BlocBuilder<PaginatrixCubit<Pokemon>, PaginationState<Pokemon>>(
  bloc: cubit,
  builder: (context, state) {
    // Handle states manually
    if (state.isLoading) {
      return LoadingWidget();
    }
    
    if (state.hasData) {
      return ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          return PokemonCard(pokemon: state.items[index]);
        },
      );
    }
    
    return EmptyWidget();
  },
)
```

### 3. Control Pagination

```dart
// Load more
cubit.loadNextPage();

// Refresh
cubit.refresh();

// Retry
cubit.retry();

// Clear
cubit.clear();

// Check state
cubit.state.hasData
cubit.state.isLoading
cubit.state.canLoadMore
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│            UI Widget                    │
│  PaginatrixCubitGridView/ListView       │
└──────────────┬──────────────────────────┘
               │ uses BlocBuilder
               ▼
┌─────────────────────────────────────────┐
│        PaginatedCubit<T>                │
│  (extends Cubit<PaginationState<T>>)    │
│                                         │
│  • loadFirstPage()                      │
│  • loadNextPage()                       │
│  • refresh()                            │
│  • retry()                              │
│  • emit(state)                          │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│      PaginationState<T>                 │
│  (Immutable with Freezed)               │
│                                         │
│  • items: List<T>                       │
│  • status: PaginationStatus             │
│  • meta: PageMeta                       │
│  • error: PaginationError?              │
└─────────────────────────────────────────┘
```

---

## 🆚 Comparison

### example_bloc_pattern (Wrapped BLoC)

```dart
// 1. Create controller
final controller = PaginatedController<Pokemon>(...);

// 2. Create BLoC wrapper
final bloc = PaginationBloc<Pokemon>(controller: controller);

// 3. Use BlocBuilder
BlocBuilder<PaginationBloc<Pokemon>, PaginationBlocState<Pokemon>>(
  bloc: bloc,
  builder: (context, blocState) {
    final state = blocState.paginationState;
    // ...
  },
)

// 4. Dispatch events
bloc.add(const LoadFirstPage());
bloc.add(const LoadNextPage());
```

### example_cubit_direct (Direct Cubit) ✅

```dart
// 1. Create cubit (that's it!)
final cubit = PaginatrixCubit<Pokemon>(...);

// 2. Use BlocBuilder directly
BlocBuilder<PaginatrixCubit<Pokemon>, PaginationState<Pokemon>>(
  bloc: cubit,
  builder: (context, state) {
    // Direct state access!
  },
)

// 3. Call methods directly
cubit.loadFirstPage();
cubit.loadNextPage();
```

**Result:** 50% less code! 🎉

---

## ✨ Features

### Automatic Scroll Detection

```dart
PaginatrixCubitGridView<Pokemon>(
  cubit: cubit,
  prefetchThreshold: 1, // Load when 1 screen from bottom
  // Cubit automatically calls loadNextPage()
)
```

### Pull to Refresh

```dart
PaginatrixCubitGridView<Pokemon>(
  cubit: cubit,
  onPullToRefresh: () {
    cubit.refresh();
  },
)
```

### Error Handling

```dart
// Automatic retry on errors
cubit.retry();

// Custom error handling
if (cubit.state.hasError) {
  print('Error: ${cubit.state.error}');
}

if (cubit.state.hasAppendError) {
  print('Append Error: ${cubit.state.appendError}');
}
```

### State Checks

```dart
final state = cubit.state;

// Check status
state.isLoading      // Currently loading
state.hasData        // Has items
state.canLoadMore    // Can load more pages
state.hasError       // Has error
state.isEmpty        // No items after load

// Access data
state.items          // List<T>
state.meta           // PageMeta
state.error          // PaginationError?
```

---

## 🧪 Testing

Testing with Cubit is super easy:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaginatedCubit', () {
    late PaginatedCubit<Pokemon> cubit;

    setUp(() {
      cubit = PaginatedCubit<Pokemon>(
        loader: mockLoader,
        itemDecoder: Pokemon.fromJson,
        metaParser: mockParser,
      );
    });

    tearDown(() {
      cubit.close();
    });

    blocTest<PaginatedCubit<Pokemon>, PaginationState<Pokemon>>(
      'emits loading then success when loadFirstPage succeeds',
      build: () => cubit,
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => [
        isA<PaginationState<Pokemon>>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<PaginationState<Pokemon>>()
            .having((s) => s.hasData, 'hasData', true),
      ],
    );
  });
}
```

---

## 🔄 Lifecycle

```dart
class _PokemonPageState extends State<PokemonPage> {
  late final PaginatedCubit<Pokemon> _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PaginatedCubit<Pokemon>(...);
    _cubit.loadFirstPage(); // Load initial data
  }

  @override
  void dispose() {
    _cubit.close(); // ✅ Clean up automatically
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatrixCubitGridView<Pokemon>(cubit: _cubit, ...);
  }
}
```

---

## 🎓 Key Takeaways

1. **Use PaginatedCubit directly** - No need to wrap it
2. **Use PaginatrixCubitGridView/ListView** - Built-in BlocBuilder
3. **Call methods directly** - `cubit.loadFirstPage()` instead of events
4. **Access state directly** - `cubit.state.items`
5. **Clean up in dispose** - `cubit.close()`

---

## 🚀 When to Use

### Use Direct Cubit When:
- ✅ Simple pagination needs
- ✅ Don't need custom events
- ✅ Want minimal boilerplate
- ✅ Direct state access is fine

### Use Wrapped BLoC When:
- ⚠️ Need custom business logic
- ⚠️ Want to add analytics/logging to events
- ⚠️ Complex state transformations
- ⚠️ Need event-driven architecture

---

## 📚 Next Steps

- Read [example_bloc_pattern](../example_bloc_pattern) for wrapped BLoC pattern
- Check [example_basic_controller](../example_basic_controller) for basic controller usage
- See [README.md](../../README.md) for full API documentation

---

**Recommendation:** Start with this example (Cubit). If you need more control, upgrade to the wrapped BLoC pattern in [example_bloc_pattern](../example_bloc_pattern).

