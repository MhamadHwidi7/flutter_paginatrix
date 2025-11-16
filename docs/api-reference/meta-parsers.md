# Meta Parsers API Reference

Complete API reference for meta parsers in Flutter Paginatrix.

---

## Overview

Meta parsers extract pagination metadata and items from API responses. Flutter Paginatrix provides two types of parsers:

- **ConfigMetaParser** - Pre-configured for common API formats
- **CustomMetaParser** - For custom API structures

---

## ConfigMetaParser

Pre-configured parser for common API response formats.

### Constructor

```dart
ConfigMetaParser(MetaConfig config)
```

### Pre-configured Configs

#### `MetaConfig.nestedMeta`

For APIs with nested meta structure:

```json
{
  "data": [...],
  "meta": {
    "current_page": 1,
    "per_page": 20,
    "total": 100,
    "last_page": 5,
    "has_more": true
  }
}
```

**Usage:**
```dart
final parser = ConfigMetaParser(MetaConfig.nestedMeta);
```

#### `MetaConfig.resultsFormat`

For APIs with results format:

```json
{
  "results": [...],
  "count": 100,
  "page": 1,
  "per_page": 20,
  "has_next": true
}
```

**Usage:**
```dart
final parser = ConfigMetaParser(MetaConfig.resultsFormat);
```

#### `MetaConfig.pageBased`

Simple page-based format:

```json
{
  "data": [...],
  "page": 1,
  "per_page": 20,
  "total": 100,
  "last_page": 5,
  "has_more": true
}
```

**Usage:**
```dart
final parser = ConfigMetaParser(MetaConfig.pageBased);
```

#### `MetaConfig.cursorBased`

Cursor-based pagination:

```json
{
  "data": [...],
  "meta": {
    "next_cursor": "abc123",
    "previous_cursor": "xyz789",
    "has_more": true
  }
}
```

**Usage:**
```dart
final parser = ConfigMetaParser(MetaConfig.cursorBased);
```

#### `MetaConfig.offsetBased`

Offset/limit pagination:

```json
{
  "data": [...],
  "meta": {
    "offset": 0,
    "limit": 20,
    "total": 100,
    "has_more": true
  }
}
```

**Usage:**
```dart
final parser = ConfigMetaParser(MetaConfig.offsetBased);
```

### Custom MetaConfig

Create custom configuration for your API:

```dart
final config = MetaConfig(
  itemsPath: 'data.items',           // Path to items array
  pagePath: 'pagination.page',        // Path to page number
  perPagePath: 'pagination.per_page', // Path to per page
  totalPath: 'pagination.total',      // Path to total count
  lastPagePath: 'pagination.last_page', // Path to last page
  hasMorePath: 'pagination.has_more',  // Path to has more flag
);

final parser = ConfigMetaParser(config);
```

### Path Configuration

Use dot notation for nested paths:

```dart
MetaConfig(
  itemsPath: 'response.data.items',      // Nested path
  pagePath: 'response.pagination.page',   // Deep nesting
)
```

### Methods

#### `extractItems(Map<String, dynamic> data)`

Extracts items array from API response.

**Returns:** `List<Map<String, dynamic>>`

**Throws:** `PaginationError.parse` if items cannot be extracted

#### `parseMeta(Map<String, dynamic> data)`

Parses pagination metadata from API response.

**Returns:** `PageMeta`

**Throws:** `PaginationError.parse` if metadata cannot be parsed

#### `validateStructure(Map<String, dynamic> data)`

Validates that data structure matches configuration.

**Returns:** `bool`

#### `clearCache()`

Clears internal caches (for memory management).

---

## CustomMetaParser

Flexible parser for custom API response structures.

### Constructor

```dart
CustomMetaParser(
  MetaTransform transform, {
  String? itemsKey,
  String? metaKey,
})
```

### Parameters

- **`transform`** (required) - Function that transforms API response
- **`itemsKey`** (optional) - Key for items in transformed result (default: `'items'`)
- **`metaKey`** (optional) - Key for meta in transformed result (default: `'meta'`)

### Transform Function

The transform function receives the raw API response and returns a standardized format:

```dart
Map<String, dynamic> Function(Map<String, dynamic> data)
```

**Example:**
```dart
final parser = CustomMetaParser((data) {
  // Extract items from custom structure
  final items = data['response']['users'] as List;
  
  // Create metadata
  final meta = {
    'page': data['response']['currentPage'] as int,
    'perPage': data['response']['pageSize'] as int,
    'total': data['response']['totalCount'] as int,
    'hasMore': data['response']['hasNext'] as bool,
  };
  
  // Return standardized format
  return {
    'items': items,
    'meta': meta,
  };
});
```

### Methods

#### `extractItems(Map<String, dynamic> data)`

Extracts items using transform function.

#### `parseMeta(Map<String, dynamic> data)`

Parses metadata using transform function.

#### `validateStructure(Map<String, dynamic> data)`

Validates structure using transform function.

---

## MetaParser Interface

Both parsers implement the `MetaParser` interface:

```dart
abstract class MetaParser {
  List<Map<String, dynamic>> extractItems(Map<String, dynamic> data);
  PageMeta parseMeta(Map<String, dynamic> data);
  bool validateStructure(Map<String, dynamic> data);
}
```

---

## Usage Examples

### Standard API Format

```dart
final controller = PaginatrixController<User>(
  loader: _loadUsers,
  itemDecoder: User.fromJson,
  metaParser: ConfigMetaParser(MetaConfig.nestedMeta),
);
```

### Custom API Format

```dart
final parser = CustomMetaParser((data) {
  return {
    'items': data['results'] as List,
    'meta': {
      'page': data['currentPage'] as int,
      'perPage': data['pageSize'] as int,
      'total': data['totalCount'] as int,
      'hasMore': data['hasNext'] as bool,
    },
  };
});

final controller = PaginatrixController<User>(
  loader: _loadUsers,
  itemDecoder: User.fromJson,
  metaParser: parser,
);
```

### Complex Nested Structure

```dart
final config = MetaConfig(
  itemsPath: 'response.data.items',
  pagePath: 'response.pagination.current_page',
  perPagePath: 'response.pagination.per_page',
  totalPath: 'response.pagination.total',
  lastPagePath: 'response.pagination.last_page',
  hasMorePath: 'response.pagination.has_more',
);

final parser = ConfigMetaParser(config);
```

---

## Error Handling

Parsers throw `PaginationError.parse` if:

- Items array cannot be found
- Metadata cannot be extracted
- Data structure doesn't match configuration
- Required fields are missing

**Example:**
```dart
try {
  final items = parser.extractItems(data);
  final meta = parser.parseMeta(data);
} on PaginationError catch (e) {
  // Handle parse error
  print('Parse error: ${e.message}');
}
```

---

## Performance

### Caching

`ConfigMetaParser` includes built-in LRU caching:

- Path segments are cached to avoid repeated parsing
- Metadata is cached for frequently accessed data
- Cache automatically evicts old entries

### Cache Management

```dart
final parser = ConfigMetaParser(MetaConfig.nestedMeta);

// Clear cache if needed
parser.clearCache();
```

---

## Best Practices

1. **Use Pre-configured Parsers**: Use `ConfigMetaParser` with standard configs when possible
2. **Custom Parsers for Complex APIs**: Use `CustomMetaParser` for non-standard formats
3. **Validate Structure**: Always validate API response structure
4. **Handle Errors**: Always handle parse errors gracefully
5. **Clear Cache**: Clear cache when data structure changes significantly

---

## See Also

- [PaginatrixController API](paginatrix-controller.md) - How to use parsers
- [PageMeta API](page-meta.md) - Metadata structure
- [Error Handling Guide](../guides/error-handling.md) - Error handling strategies

---

**Note**: Choose the parser that best matches your API format. Pre-configured parsers are optimized for performance and include caching.

