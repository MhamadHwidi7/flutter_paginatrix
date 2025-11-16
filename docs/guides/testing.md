# Testing Guide

Learn how to test pagination in your Flutter applications using Flutter Paginatrix.

---

## Table of Contents

- [Overview](#overview)
- [Unit Testing](#unit-testing)
- [Widget Testing](#widget-testing)
- [Integration Testing](#integration-testing)
- [Mocking](#mocking)
- [Test Helpers](#test-helpers)
- [Best Practices](#best-practices)

---

## Overview

Flutter Paginatrix is designed to be easily testable. The package includes:

- ✅ **Comprehensive test suite** (171+ tests)
- ✅ **Testable architecture** with clear separation of concerns
- ✅ **Mockable dependencies** for easy testing
- ✅ **Test helpers** for common scenarios

---

## Unit Testing

### Testing the Controller

Test controller methods and state changes:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  group('PaginatrixController Tests', () {
    late PaginatrixCubit<User> controller;
    
    setUp(() {
      controller = PaginatrixCubit<User>(
        loader: mockLoader,
        itemDecoder: User.fromJson,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      );
    });
    
    tearDown(() {
      controller.close();
    });
    
    test('should load first page', () async {
      await controller.loadFirstPage();
      
      expect(controller.state.items.length, greaterThan(0));
      expect(controller.state.status, PaginationStatus.success());
      expect(controller.hasData, isTrue);
    });
    
    test('should load next page', () async {
      await controller.loadFirstPage();
      final initialCount = controller.state.items.length;
      
      await controller.loadNextPage();
      
      expect(controller.state.items.length, greaterThan(initialCount));
      expect(controller.state.meta?.page, 2);
    });
    
    test('should handle errors', () async {
      // Use a loader that throws
      final errorController = PaginatrixCubit<User>(
        loader: (_) async => throw Exception('Network error'),
        itemDecoder: User.fromJson,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      );
      
      await errorController.loadFirstPage();
      
      expect(errorController.hasError, isTrue);
      expect(errorController.state.error, isNotNull);
      
      errorController.close();
    });
  });
}
```

### Testing State Transitions

Verify state transitions are correct:

```dart
test('should transition through correct states', () async {
  expect(controller.state.status, PaginationStatus.initial());
  
  final loadFuture = controller.loadFirstPage();
  
  // Should be loading
  expect(controller.isLoading, isTrue);
  
  await loadFuture;
  
  // Should be success
  expect(controller.state.status, PaginationStatus.success());
  expect(controller.hasData, isTrue);
});
```

### Testing Search and Filters

Test query updates:

```dart
test('should update search term', () async {
  await controller.loadFirstPage();
  
  controller.updateSearchTerm('john');
  
  // Wait for debounce
  await Future.delayed(Duration(milliseconds: 500));
  
  expect(controller.state.query?.searchTerm, 'john');
});

test('should update filters', () async {
  await controller.loadFirstPage();
  
  controller.updateFilter('status', 'active');
  
  expect(controller.state.query?.filters['status'], 'active');
});
```

---

## Widget Testing

### Testing PaginatrixListView

Test widget rendering and interactions:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  group('PaginatrixListView Tests', () {
    late PaginatrixController<User> controller;
    
    setUp(() {
      controller = PaginatrixController<User>(
        loader: mockLoader,
        itemDecoder: User.fromJson,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      );
    });
    
    tearDown(() {
      controller.close();
    });
    
    testWidgets('should display items', (tester) async {
      await controller.loadFirstPage();
      await tester.pump();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixListView<User>(
              controller: controller,
              itemBuilder: (context, user, index) {
                return ListTile(
                  title: Text(user.name),
                );
              },
            ),
          ),
        ),
      );
      
      // Wait for items to load
      await tester.pumpAndSettle();
      
      // Verify items are displayed
      expect(find.text('User 1'), findsOneWidget);
      expect(find.text('User 2'), findsOneWidget);
    });
    
    testWidgets('should show loading indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixListView<User>(
              controller: controller,
              itemBuilder: (context, user, index) => ListTile(
                title: Text(user.name),
              ),
            ),
          ),
        ),
      );
      
      // Trigger load
      controller.loadFirstPage();
      await tester.pump();
      
      // Should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    
    testWidgets('should show error view', (tester) async {
      final errorController = PaginatrixCubit<User>(
        loader: (_) async => throw Exception('Error'),
        itemDecoder: User.fromJson,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      );
      
      await errorController.loadFirstPage();
      await tester.pump();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginatrixListView<User>(
              cubit: errorController,
              itemBuilder: (context, user, index) => ListTile(
                title: Text(user.name),
              ),
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Should show error
      expect(find.text('Error'), findsOneWidget);
      
      errorController.close();
    });
  });
}
```

### Testing User Interactions

Test scroll and refresh:

```dart
testWidgets('should trigger load on scroll', (tester) async {
  await controller.loadFirstPage();
  await tester.pumpAndSettle();
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PaginatrixListView<User>(
          controller: controller,
          itemBuilder: (context, user, index) => ListTile(
            title: Text(user.name),
          ),
        ),
      ),
    ),
  );
  
  // Scroll to near end
  final listView = find.byType(ListView);
  await tester.drag(listView, Offset(0, -500));
  await tester.pumpAndSettle();
  
  // Should trigger next page load
  expect(controller.isLoading, isTrue);
});
```

---

## Integration Testing

### Testing Complete Flow

Test the complete pagination flow:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  group('Integration Tests', () {
    test('complete pagination flow', () async {
      final controller = PaginatrixCubit<User>(
        loader: createMockLoader(totalItems: 200),
        itemDecoder: User.fromJson,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      );
      
      // Initial load
      await controller.loadFirstPage();
      expect(controller.state.items.length, 20);
      expect(controller.state.meta?.page, 1);
      
      // Load next page
      await controller.loadNextPage();
      expect(controller.state.items.length, 40);
      expect(controller.state.meta?.page, 2);
      
      // Refresh
      await controller.refresh();
      expect(controller.state.items.length, 20);
      expect(controller.state.meta?.page, 1);
      
      controller.close();
    });
    
    test('search and filter flow', () async {
      final controller = PaginatrixCubit<User>(
        loader: createMockLoader(),
        itemDecoder: User.fromJson,
        metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      );
      
      await controller.loadFirstPage();
      
      // Update search
      controller.updateSearchTerm('john');
      await Future.delayed(Duration(milliseconds: 500));
      
      expect(controller.state.query?.searchTerm, 'john');
      
      // Add filter
      controller.updateFilter('status', 'active');
      
      expect(controller.state.query?.filters['status'], 'active');
      
      controller.close();
    });
  });
}
```

---

## Mocking

### Mock Loader Function

Create a mock loader for testing:

```dart
Future<Map<String, dynamic>> mockLoader({
  int? page,
  int? perPage,
  CancelToken? cancelToken,
  QueryCriteria? query,
}) async {
  // Simulate API delay
  await Future.delayed(Duration(milliseconds: 100));
  
  final pageNum = page ?? 1;
  final perPageNum = perPage ?? 20;
  final start = (pageNum - 1) * perPageNum;
  final end = start + perPageNum;
  
  final items = List.generate(
    perPageNum,
    (i) => {
      'id': start + i + 1,
      'name': 'User ${start + i + 1}',
      'email': 'user${start + i + 1}@example.com',
    },
  );
  
  return {
    'data': items,
    'meta': {
      'current_page': pageNum,
      'per_page': perPageNum,
      'total': 100,
      'last_page': 5,
      'has_more': pageNum < 5,
    },
  };
}
```

### Mock with Mockito

Use Mockito for more advanced mocking:

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Dio])
void main() {
  test('should handle API errors', () async {
    final mockDio = MockDio();
    
    when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
        .thenThrow(DioException(
          requestOptions: RequestOptions(path: '/users'),
        ));
    
    final controller = PaginatrixCubit<User>(
      loader: ({page, perPage, cancelToken}) async {
        await mockDio.get('/users', queryParameters: {
          'page': page,
          'per_page': perPage,
        });
        return {};
      },
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    );
    
    await controller.loadFirstPage();
    
    expect(controller.hasError, isTrue);
    
    controller.close();
  });
}
```

---

## Test Helpers

### Create Test Controller

Helper function to create a test controller:

```dart
PaginatrixCubit<User> createTestController({
  List<Map<String, dynamic>>? mockData,
  Duration loaderDelay = Duration.zero,
}) {
  return PaginatrixCubit<User>(
    loader: createMockLoader(
      mockData: mockData,
      delay: loaderDelay,
    ),
    itemDecoder: User.fromJson,
    metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
    options: PaginationOptions(
      searchDebounceDuration: Duration.zero, // No debounce in tests
      refreshDebounceDuration: Duration.zero,
    ),
  );
}
```

### Create Mock Data

Helper to generate mock data:

```dart
List<Map<String, dynamic>> createMockData({
  int totalItems = 100,
}) {
  return List.generate(
    totalItems,
    (i) => {
      'id': i + 1,
      'name': 'User ${i + 1}',
      'email': 'user${i + 1}@example.com',
    },
  );
}
```

### Wait for Debounce

Helper to wait for debounce in tests:

```dart
Future<void> waitForDebounce() async {
  await Future.delayed(Duration(milliseconds: 500));
}
```

---

## Best Practices

### 1. Always Dispose Controllers

Always close controllers in `tearDown`:

```dart
tearDown(() {
  controller.close();
});
```

### 2. Use Zero Debounce in Tests

Disable debounce for faster tests:

```dart
final options = PaginationOptions(
  searchDebounceDuration: Duration.zero,
  refreshDebounceDuration: Duration.zero,
);
```

### 3. Test Error Scenarios

Always test error handling:

```dart
test('should handle network errors', () async {
  // Test network error
});

test('should handle parse errors', () async {
  // Test parse error
});

test('should handle cancellation', () async {
  // Test cancellation
});
```

### 4. Test Edge Cases

Test boundary conditions:

```dart
test('should handle empty results', () async {
  // Test empty response
});

test('should handle last page', () async {
  // Test when hasMore is false
});

test('should handle single page', () async {
  // Test when all data fits in one page
});
```

### 5. Use Realistic Data

Use realistic mock data that matches your API:

```dart
final mockData = [
  {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'},
  {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com'},
  // ... more realistic data
];
```

### 6. Test State Transitions

Verify state transitions are correct:

```dart
test('should transition: initial -> loading -> success', () async {
  expect(controller.state.status, PaginationStatus.initial());
  
  final future = controller.loadFirstPage();
  expect(controller.isLoading, isTrue);
  
  await future;
  expect(controller.state.status, PaginationStatus.success());
});
```

---

## Testing Checklist

Before considering tests complete, verify:

- ✅ Unit tests for controller methods
- ✅ Widget tests for UI components
- ✅ Integration tests for complete flows
- ✅ Error scenario tests
- ✅ Edge case tests
- ✅ State transition tests
- ✅ Search and filter tests
- ✅ Performance tests (if applicable)
- ✅ Memory leak tests
- ✅ All controllers are disposed

---

## Additional Resources

- 📖 [Basic Usage Guide](basic-usage.md) - Usage examples
- 📘 [Advanced Usage Guide](advanced-usage.md) - Advanced features
- 📚 [API Reference](../api-reference/) - Complete API documentation
- 🔧 [Troubleshooting](../troubleshooting/) - Common issues

---

**Remember**: Good tests are essential for maintaining code quality. Write tests that are readable, maintainable, and cover both happy paths and error scenarios.

