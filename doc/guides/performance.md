# Performance Optimization Guide

Learn how to optimize Flutter Paginatrix for the best performance in your applications.

---

## Table of Contents

- [Overview](#overview)
- [Widget Performance](#widget-performance)
- [List Optimization](#list-optimization)
- [Memory Management](#memory-management)
- [Network Optimization](#network-optimization)
- [State Management](#state-management)
- [Best Practices](#best-practices)
- [Performance Monitoring](#performance-monitoring)

---

## Overview

Flutter Paginatrix is built with performance in mind, using:

- ✅ **Sliver-based architecture** for efficient scrolling
- ✅ **Automatic keep-alives** to preserve widget state
- ✅ **Repaint boundaries** to minimize rebuilds
- ✅ **Smart prefetching** to load data before user reaches the end
- ✅ **Request cancellation** to prevent unnecessary network calls
- ✅ **Generation guards** to prevent stale responses

However, you can further optimize performance by following these guidelines.

---

## Widget Performance

### Use Keys for Items

Always provide keys for list items to help Flutter efficiently update the widget tree:

```dart
PaginatrixListView<User>(
  controller: _controller,
  keyBuilder: (user, index) => user.id.toString(), // Unique key
  itemBuilder: (context, user, index) {
    return UserTile(user: user);
  },
)
```

**Benefits:**
- Faster widget tree updates
- Preserves scroll position
- Prevents unnecessary rebuilds

### Enable Performance Optimizations

All performance optimizations are enabled by default, but you can customize them:

```dart
PaginatrixListView<User>(
  controller: _controller,
  addAutomaticKeepAlives: true,      // Preserve widget state
  addRepaintBoundaries: true,         // Minimize repaints
  addSemanticIndexes: true,          // Accessibility
  cacheExtent: 250.0,                // Cache extent in pixels
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

**Recommendations:**
- Keep `addAutomaticKeepAlives: true` for better scroll performance
- Keep `addRepaintBoundaries: true` to minimize repaints
- Adjust `cacheExtent` based on item size (larger items = larger cache)

---

## List Optimization

### Optimize Item Builders

Keep item builders lightweight and avoid heavy computations:

```dart
// ❌ Bad: Heavy computation in builder
itemBuilder: (context, user, index) {
  final expensiveData = performExpensiveCalculation(user);
  return UserTile(data: expensiveData);
}

// ✅ Good: Pre-compute or use memoization
itemBuilder: (context, user, index) {
  return UserTile(user: user); // Lightweight builder
}
```

### Use const Constructors

Use `const` constructors where possible:

```dart
itemBuilder: (context, user, index) {
  return const UserTile(user: user); // If UserTile supports const
}
```

### Optimize Images

If displaying images, use optimized loading:

```dart
itemBuilder: (context, user, index) {
  return ListTile(
    leading: Image.network(
      user.avatarUrl,
      cacheWidth: 100,  // Resize for performance
      cacheHeight: 100,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const CircularProgressIndicator();
      },
    ),
    title: Text(user.name),
  );
}
```

---

## Memory Management

### Always Dispose Controllers

Always call `close()` in `dispose()` to prevent memory leaks:

```dart
@override
void dispose() {
  _controller.close(); // Important!
  super.dispose();
}
```

### Cancel Requests on Navigation

Cancel in-flight requests when navigating away:

```dart
@override
void dispose() {
  _controller.cancel(); // Cancel any in-flight requests
  _controller.close();
  super.dispose();
}
```

### Limit Cache Sizes

If using custom meta parsers with caching, monitor cache sizes:

```dart
// ConfigMetaParser has built-in LRU cache with size limits
// Cache automatically evicts old entries when full
final parser = ConfigMetaParser(MetaConfig.nestedMeta);
// Cache size is limited to prevent memory issues
```

### Clear Data When Needed

Clear pagination data when it's no longer needed:

```dart
// Clear all data and reset state
_controller.clear();

// Or just cancel current request
_controller.cancel();
```

---

## Network Optimization

### Configure Debouncing

Adjust debounce durations to balance responsiveness and API calls:

```dart
final options = PaginationOptions(
  searchDebounceDuration: Duration(milliseconds: 400), // Default
  refreshDebounceDuration: Duration(milliseconds: 300), // Default
);

// For faster search (more API calls)
searchDebounceDuration: Duration(milliseconds: 200),

// For slower search (fewer API calls)
searchDebounceDuration: Duration(milliseconds: 600),
```

### Use Request Cancellation

Always use `cancelToken` in your loader function:

```dart
Future<Map<String, dynamic>> _loadUsers({
  CancelToken? cancelToken, // Always use this
  // ... other parameters
}) async {
  final response = await dio.get(
    'https://api.example.com/users',
    cancelToken: cancelToken, // Prevents unnecessary requests
  );
  return response.data;
}
```

### Optimize Page Size

Choose an appropriate page size:

```dart
final options = PaginationOptions(
  defaultPageSize: 20, // Default
  maxPageSize: 100,    // Maximum allowed
);

// Smaller pages = more requests but faster initial load
defaultPageSize: 10,

// Larger pages = fewer requests but slower initial load
defaultPageSize: 50,
```

**Recommendations:**
- Mobile: 20-30 items per page
- Tablet: 30-50 items per page
- Desktop/Web: 50-100 items per page

### Configure Prefetch Threshold

Adjust when the next page loads:

```dart
PaginatrixListView<User>(
  controller: _controller,
  prefetchThreshold: 3, // Load when 3 items from end (default)
  itemBuilder: (context, user, index) => UserTile(user: user),
)

// Load earlier (more aggressive)
prefetchThreshold: 5,

// Load later (less aggressive)
prefetchThreshold: 1,
```

---

## State Management

### Minimize State Rebuilds

The widget automatically minimizes rebuilds using `buildWhen`:

```dart
// Widget only rebuilds when:
// - Status changes
// - Items change
// - Errors change
// - Meta changes
// It does NOT rebuild for query changes if items haven't changed
```

### Use State Extensions

Use state extensions for cleaner code:

```dart
// Instead of checking status manually
if (controller.state.status.maybeWhen(
  loading: () => true,
  orElse: () => false,
)) {
  // Show loading
}

// Use extension
if (controller.isLoading) {
  // Show loading
}
```

### Avoid Unnecessary State Access

Don't access state in `build()` if not needed:

```dart
// ❌ Bad: Accesses state on every build
@override
Widget build(BuildContext context) {
  final items = _controller.state.items; // Unnecessary
  return Scaffold(...);
}

// ✅ Good: Widget handles state internally
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: PaginatrixListView<User>(
      controller: _controller, // Widget handles state
      itemBuilder: (context, user, index) => UserTile(user: user),
    ),
  );
}
```

---

## Best Practices

### 1. Use Appropriate Pagination Strategy

Choose the right strategy for your use case:

- **Page-based**: Best for most APIs, simple to implement
- **Offset-based**: Good for databases, but has limitations with large datasets
- **Cursor-based**: Best for real-time data, social feeds, infinite scroll

### 2. Handle Errors Gracefully

Always provide error builders:

```dart
PaginatrixListView<User>(
  controller: _controller,
  errorBuilder: (context, error, onRetry) {
    return PaginatrixErrorView(
      error: error,
      onRetry: onRetry,
    );
  },
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

### 3. Optimize Item Rendering

Keep item widgets lightweight:

```dart
// ✅ Good: Simple, efficient widget
class UserTile extends StatelessWidget {
  final User user;
  
  const UserTile({required this.user});
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  }
}

// ❌ Bad: Heavy computation in build
class UserTile extends StatelessWidget {
  final User user;
  
  @override
  Widget build(BuildContext context) {
    final processed = expensiveProcessing(user); // Don't do this!
    return ListTile(...);
  }
}
```

### 4. Use Skeleton Loading

Skeleton loading provides better UX:

```dart
PaginatrixListView<User>(
  controller: _controller,
  skeletonizerBuilder: (context, index) {
    return UserSkeletonTile(); // Custom skeleton
  },
  itemBuilder: (context, user, index) => UserTile(user: user),
)
```

### 5. Monitor Performance

Enable debug logging to monitor performance:

```dart
final options = PaginationOptions(
  enableDebugLogging: true, // Logs operations for debugging
);
```

---

## Performance Monitoring

### Enable Debug Logging

Monitor operations in development:

```dart
final options = PaginationOptions(
  enableDebugLogging: true,
);

// Logs include:
// - Load operations
// - State transitions
// - Error occurrences
// - Retry attempts
```

### Profile Your App

Use Flutter DevTools to profile:

1. Open DevTools
2. Go to Performance tab
3. Record a session
4. Scroll through paginated list
5. Analyze frame times and rebuilds

### Check Memory Usage

Monitor memory in DevTools:

1. Open DevTools
2. Go to Memory tab
3. Check for memory leaks
4. Verify controllers are disposed

### Monitor Network Requests

Track API calls:

```dart
Future<Map<String, dynamic>> _loadUsers({...}) async {
  final stopwatch = Stopwatch()..start();
  final response = await dio.get(...);
  stopwatch.stop();
  
  debugPrint('Load took ${stopwatch.elapsedMilliseconds}ms');
  return response.data;
}
```

---

## Common Performance Issues

### Issue: Slow Scrolling

**Solutions:**
1. Use keys for items
2. Keep item builders lightweight
3. Enable performance optimizations
4. Optimize images
5. Reduce item complexity

### Issue: High Memory Usage

**Solutions:**
1. Always dispose controllers
2. Cancel requests on navigation
3. Limit page size
4. Clear data when not needed
5. Monitor cache sizes

### Issue: Too Many API Calls

**Solutions:**
1. Increase debounce duration
2. Adjust prefetch threshold
3. Use request cancellation
4. Implement proper caching

### Issue: Laggy Initial Load

**Solutions:**
1. Reduce initial page size
2. Use skeleton loading
3. Optimize API response
4. Implement progressive loading

---

## Performance Checklist

Before releasing your app, verify:

- ✅ Keys are provided for all items
- ✅ Controllers are disposed properly
- ✅ Request cancellation is implemented
- ✅ Debounce durations are optimized
- ✅ Page sizes are appropriate
- ✅ Item builders are lightweight
- ✅ Error handling is in place
- ✅ Memory leaks are prevented
- ✅ Performance is profiled
- ✅ Network requests are optimized

---

## Additional Resources

- 📖 [Basic Usage Guide](basic-usage.md) - Basic examples
- 📘 [Advanced Usage Guide](advanced-usage.md) - Advanced features
- 📚 [API Reference](../api-reference/) - Complete API documentation
- 🔧 [Troubleshooting](../troubleshooting/) - Common issues and solutions

---

**Remember**: Performance optimization is an ongoing process. Profile your app regularly and optimize based on real-world usage patterns.

