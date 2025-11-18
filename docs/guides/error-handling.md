# Error Handling Guide

Comprehensive guide to handling errors in Flutter Paginatrix.

## Error Types

Flutter Paginatrix defines 6 error types:

### 1. Network Errors

Connection issues, timeouts, HTTP errors:

```dart
PaginationError.network(
  message: 'Connection timeout',
  statusCode: 408,
  originalError: 'TimeoutException',
)
```

### 2. Parse Errors

Invalid response format, missing keys:

```dart
PaginationError.parse(
  message: 'Invalid response format',
  expectedFormat: 'Expected: items at "data", page at "meta.current_page"',
  actualData: {...},
)
```

### 3. Cancelled Errors

Request was cancelled:

```dart
PaginationError.cancelled(
  message: 'Request was cancelled',
)
```

### 4. Rate Limited Errors

Too many requests:

```dart
PaginationError.rateLimited(
  message: 'Rate limit exceeded',
  retryAfter: Duration(seconds: 60),
)
```

### 5. Circuit Breaker Errors

Service unavailable:

```dart
PaginationError.circuitBreaker(
  message: 'Service unavailable',
  retryAfter: Duration(seconds: 30),
)
```

### 6. Unknown Errors

Unexpected errors:

```dart
PaginationError.unknown(
  message: 'An unexpected error occurred',
  originalError: 'Exception details',
)
```

## Error Handling in UI

### Basic Error Handling

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

### Custom Error Widget

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  errorBuilder: (context, error, onRetry) {
    return error.when(
      network: (message, statusCode, originalError) {
        return NetworkErrorWidget(
          message: message,
          statusCode: statusCode,
          onRetry: onRetry,
        );
      },
      parse: (message, expectedFormat, actualData) {
        return ParseErrorWidget(
          message: message,
          onRetry: onRetry,
        );
      },
      cancelled: (message) {
        return const SizedBox.shrink(); // Don't show cancelled errors
      },
      rateLimited: (message, retryAfter) {
        return RateLimitErrorWidget(
          message: message,
          retryAfter: retryAfter,
          onRetry: onRetry,
        );
      },
      circuitBreaker: (message, retryAfter) {
        return CircuitBreakerErrorWidget(
          message: message,
          retryAfter: retryAfter,
          onRetry: onRetry,
        );
      },
      unknown: (message, originalError) {
        return UnknownErrorWidget(
          message: message,
          onRetry: onRetry,
        );
      },
    );
  },
)
```

### Append Error Handling

Handle errors when loading next page:

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  appendErrorBuilder: (context, error, onRetry) {
    return PaginatrixAppendErrorView(
      error: error,
      onRetry: onRetry,
    );
  },
  onRetryAppend: () {
    _controller.retry();
  },
)
```

## Retry Mechanism

### Automatic Retry

The controller includes automatic retry with exponential backoff:

```dart
final options = PaginationOptions(
  maxRetries: 5,
  initialBackoff: Duration(milliseconds: 500),
  retryResetTimeout: Duration(seconds: 60),
);
```

### Manual Retry

```dart
// Retry failed operation
_controller.retry();

// Retry with callback
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  onRetryInitial: () {
    _controller.retry();
  },
  onRetryAppend: () {
    _controller.retry();
  },
)
```

## Error State Checking

### Check for Errors

```dart
// Check if has error
if (_controller.state.hasError) {
  final error = _controller.state.error;
  // Handle error
}

// Check if has append error
if (_controller.state.hasAppendError) {
  final error = _controller.state.appendError;
  // Handle append error
}
```

### Error Properties

```dart
final error = _controller.state.error;

// Check if error is retryable
if (error?.isRetryable ?? false) {
  // Show retry button
}

// Check if error should be shown to user
if (error?.isUserVisible ?? false) {
  // Display error message
}
```

## Error Handling Best Practices

### 1. Always Provide Error Builders

```dart
PaginatrixListView<User>(
  controller: _controller,
  itemBuilder: (context, user, index) => UserTile(user: user),
  errorBuilder: (context, error, onRetry) {
    // Always provide error handling
    return ErrorWidget(error);
  },
)
```

### 2. Handle Different Error Types

```dart
errorBuilder: (context, error, onRetry) {
  return error.when(
    network: (message, statusCode, _) {
      // Show network error UI
      return NetworkErrorView(message: message, onRetry: onRetry);
    },
    parse: (message, _, __) {
      // Show parse error UI
      return ParseErrorView(message: message, onRetry: onRetry);
    },
    // Handle other error types...
    orElse: () => GenericErrorView(onRetry: onRetry),
  );
}
```

### 3. Provide Retry Functionality

```dart
onRetryInitial: () {
  _controller.retry();
},
onRetryAppend: () {
  _controller.retry();
},
```

### 4. Log Errors for Debugging

```dart
errorBuilder: (context, error, onRetry) {
  // Log error for debugging
  debugPrint('Pagination error: ${error.toString()}');
  
  return PaginatrixErrorView(
    error: error,
    onRetry: onRetry,
  );
}
```

## Complete Error Handling Example

```dart
class ErrorHandlingExample extends StatefulWidget {
  const ErrorHandlingExample({super.key});

  @override
  State<ErrorHandlingExample> createState() => _ErrorHandlingExampleState();
}

class _ErrorHandlingExampleState extends State<ErrorHandlingExample> {
  late final PaginatrixController<User> _controller;

  @override
  void initState() {
    super.initState();
    _controller = PaginatrixController<User>(
      loader: _loadUsers,
      itemDecoder: User.fromJson,
      metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
      options: PaginationOptions(
        maxRetries: 3,
        initialBackoff: Duration(milliseconds: 500),
      ),
    );
    _controller.loadFirstPage();
  }

  Future<Map<String, dynamic>> _loadUsers({
    int? page,
    int? perPage,
    CancelToken? cancelToken,
  }) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.example.com/users',
        queryParameters: {
          'page': page ?? 1,
          'per_page': perPage ?? 20,
        },
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      // Handle errors and convert to PaginationError
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout) {
          throw PaginationError.network(
            message: 'Connection timeout',
            originalError: e.toString(),
          );
        }
        // Handle other DioException types...
      }
      rethrow;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error Handling Example')),
      body: PaginatrixListView<User>(
        controller: _controller,
        itemBuilder: (context, user, index) {
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
          );
        },
        errorBuilder: (context, error, onRetry) {
          return PaginatrixErrorView(
            error: error,
            onRetry: onRetry,
          );
        },
        appendErrorBuilder: (context, error, onRetry) {
          return PaginatrixAppendErrorView(
            error: error,
            onRetry: onRetry,
          );
        },
        onRetryInitial: () {
          _controller.retry();
        },
        onRetryAppend: () {
          _controller.retry();
        },
      ),
    );
  }
}
```

## Next Steps

- Learn about [Customization](customization.md)
- Explore [Performance Optimization](performance.md)
- Check [Troubleshooting](../troubleshooting/common-issues.md)




