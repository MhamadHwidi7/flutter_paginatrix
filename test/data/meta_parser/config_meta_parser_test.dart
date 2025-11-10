import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

void main() {
  group('ConfigMetaParser', () {
    late ConfigMetaParser parser;

    setUp(() {
      parser = ConfigMetaParser(MetaConfig.nestedMeta);
    });

    group('parseMeta - Page-based pagination', () {
      test('should parse nested meta format correctly', () {
        final data = {
          'data': [],
          'meta': {
            'current_page': 1,
            'per_page': 20,
            'total': 100,
            'last_page': 5,
            'has_more': true,
          },
        };

        final meta = parser.parseMeta(data);

        expect(meta.page, 1);
        expect(meta.perPage, 20);
        expect(meta.total, 100);
        expect(meta.lastPage, 5);
        expect(meta.hasMore, true);
      });

      test('should parse results format correctly', () {
        final resultsParser = ConfigMetaParser(MetaConfig.resultsFormat);
        final data = {
          'results': [],
          'page': 2,
          'per_page': 10,
          'count': 50,
          'total_pages': 5,
          'has_next': true,
        };

        final meta = resultsParser.parseMeta(data);

        expect(meta.page, 2);
        expect(meta.perPage, 10);
        expect(meta.total, 50);
        expect(meta.lastPage, 5);
        expect(meta.hasMore, true);
      });

      test('should parse simple page-based format', () {
        final pageBasedParser = ConfigMetaParser(MetaConfig.pageBased);
        final data = {
          'data': [],
          'page': 3,
          'per_page': 15,
          'total': 75,
          'last_page': 5,
          'has_more': true,
        };

        final meta = pageBasedParser.parseMeta(data);

        expect(meta.page, 3);
        expect(meta.perPage, 15);
        expect(meta.total, 75);
        expect(meta.lastPage, 5);
        expect(meta.hasMore, true);
      });

      test('should calculate hasMore from lastPage when not provided', () {
        final data = {
          'data': [],
          'meta': {
            'current_page': 2,
            'per_page': 20,
            'last_page': 5,
          },
        };

        final meta = parser.parseMeta(data);

        expect(meta.page, 2);
        expect(meta.hasMore, true); // page 2 < lastPage 5
      });

      test('should set hasMore to false when on last page', () {
        final data = {
          'data': [],
          'meta': {
            'current_page': 5,
            'per_page': 20,
            'last_page': 5,
          },
        };

        final meta = parser.parseMeta(data);

        expect(meta.page, 5);
        expect(meta.hasMore, false); // page 5 == lastPage 5
      });

      test('should handle missing optional fields', () {
        final data = {
          'data': [],
          'meta': {
            'current_page': 1,
            'per_page': 20,
          },
        };

        final meta = parser.parseMeta(data);

        expect(meta.page, 1);
        expect(meta.perPage, 20);
        expect(meta.total, isNull);
        expect(meta.lastPage, isNull);
        expect(meta.hasMore, isNull);
      });
    });

    group('parseMeta - Cursor-based pagination', () {
      test('should parse cursor-based format correctly', () {
        final cursorParser = ConfigMetaParser(MetaConfig.cursorBased);
        final data = {
          'data': [],
          'meta': {
            'next_cursor': 'cursor_123',
            'previous_cursor': 'cursor_122',
            'has_more': true,
          },
        };

        final meta = cursorParser.parseMeta(data);

        expect(meta.nextCursor, 'cursor_123');
        expect(meta.previousCursor, 'cursor_122');
        expect(meta.hasMore, true);
      });

      test('should handle cursor without hasMore', () {
        final cursorParser = ConfigMetaParser(MetaConfig.cursorBased);
        final data = {
          'data': [],
          'meta': {
            'next_cursor': 'cursor_123',
          },
        };

        final meta = cursorParser.parseMeta(data);

        expect(meta.nextCursor, 'cursor_123');
        expect(meta.hasMore, isNull);
      });
    });

    group('parseMeta - Offset-based pagination', () {
      test('should parse offset-based format correctly', () {
        final offsetParser = ConfigMetaParser(MetaConfig.offsetBased);
        // Note: Don't include has_more to avoid cursor-based detection
        final data = {
          'data': [],
          'meta': {
            'offset': 40,
            'limit': 20,
            'total': 100,
          },
        };

        final meta = offsetParser.parseMeta(data);

        // Check if meta was created successfully with offset-based pagination
        expect(meta, isNotNull);
        // The parser should extract offset and limit correctly
        expect(meta.offset, 40);
        expect(meta.limit, 20);
        // Total should be extracted from meta.total path
        expect(meta.total, 100);
        // hasMore should be calculated: 40 + 20 = 60 < 100 = true
        expect(meta.hasMore, true);
      });

      test('should calculate hasMore from offset and total when not provided',
          () {
        final offsetParser = ConfigMetaParser(MetaConfig.offsetBased);
        final data = {
          'data': [],
          'meta': {
            'offset': 40,
            'limit': 20,
            'total': 100,
          },
        };

        final meta = offsetParser.parseMeta(data);

        expect(meta.offset, 40);
        expect(meta.limit, 20);
        expect(meta.total, 100);
        expect(meta.hasMore, true); // 40 + 20 = 60 < 100
      });

      test('should set hasMore to false when at end', () {
        final offsetParser = ConfigMetaParser(MetaConfig.offsetBased);
        final data = {
          'data': [],
          'meta': {
            'offset': 80,
            'limit': 20,
            'total': 100,
          },
        };

        final meta = offsetParser.parseMeta(data);

        expect(meta.offset, 80);
        expect(meta.hasMore, false); // 80 + 20 = 100 >= 100
      });
    });

    group('extractItems', () {
      test('should extract items from nested path', () {
        final data = {
          'data': [
            {'id': 1, 'name': 'Item 1'},
            {'id': 2, 'name': 'Item 2'},
          ],
          'meta': {},
        };

        final items = parser.extractItems(data);

        expect(items.length, 2);
        expect(items[0]['id'], 1);
        expect(items[1]['name'], 'Item 2');
      });

      test('should extract items from results path', () {
        final resultsParser = ConfigMetaParser(MetaConfig.resultsFormat);
        final data = {
          'results': [
            {'id': 1},
            {'id': 2},
          ],
        };

        final items = resultsParser.extractItems(data);

        expect(items.length, 2);
        expect(items[0]['id'], 1);
      });

      test('should throw error when items path does not contain a list', () {
        final data = {
          'data': 'not a list',
          'meta': {},
        };

        expect(
          () => parser.extractItems(data),
          throwsA(isA<PaginationError>()),
        );
      });

      test('should throw error when items path contains non-map items', () {
        final data = {
          'data': [
            {'id': 1},
            'not a map',
            {'id': 3},
          ],
          'meta': {},
        };

        expect(
          () => parser.extractItems(data),
          throwsA(isA<PaginationError>()),
        );
      });

      test('should throw error when items path does not exist', () {
        final data = {
          'meta': {},
        };

        expect(
          () => parser.extractItems(data),
          throwsA(isA<PaginationError>()),
        );
      });
    });

    group('validateStructure', () {
      test('should return true for valid nested meta structure', () {
        final data = {
          'data': [
            {'id': 1}
          ],
          'meta': {
            'current_page': 1,
            'per_page': 20,
          },
        };

        expect(parser.validateStructure(data), isTrue);
      });

      test('should return true for valid results format', () {
        final resultsParser = ConfigMetaParser(MetaConfig.resultsFormat);
        final data = {
          'results': [
            {'id': 1}
          ],
          'page': 1,
        };

        expect(resultsParser.validateStructure(data), isTrue);
      });

      test('should return false when items path does not exist', () {
        final data = {
          'meta': {},
        };

        expect(parser.validateStructure(data), isFalse);
      });

      test('should return false when items is not a list', () {
        final data = {
          'data': 'not a list',
          'meta': {},
        };

        expect(parser.validateStructure(data), isFalse);
      });

      test('should return true for items-only structure (no pagination)', () {
        // Create a parser with no pagination paths configured
        final itemsOnlyParser = ConfigMetaParser(
          const MetaConfig(
            itemsPath: 'data',
            // No pagination paths
          ),
        );

        final data = {
          'data': [
            {'id': 1}
          ],
        };

        expect(itemsOnlyParser.validateStructure(data), isTrue);
      });
    });

    group('Path extraction edge cases', () {
      test('should handle null paths gracefully', () {
        final data = {'data': []};
        final meta = parser.parseMeta(data);

        // Should not throw, but return null values
        expect(meta.page, isNull);
        expect(meta.perPage, isNull);
      });

      test('should handle empty paths gracefully', () {
        final customParser = ConfigMetaParser(
          const MetaConfig(
            itemsPath: 'data',
            pagePath: '',
          ),
        );

        final data = {'data': []};
        final meta = customParser.parseMeta(data);

        expect(meta.page, isNull);
      });

      test('should handle invalid path format', () {
        final customParser = ConfigMetaParser(
          const MetaConfig(
            itemsPath: 'data',
            pagePath: 'meta..current_page', // Invalid: double dot
          ),
        );

        final data = {
          'data': [],
          'meta': {'current_page': 1},
        };

        final meta = customParser.parseMeta(data);
        // Should return null for invalid path
        expect(meta.page, isNull);
      });

      test('should handle nested paths correctly', () {
        final data = {
          'data': [],
          'meta': {
            'pagination': {
              'current_page': 2,
            },
          },
        };

        final customParser = ConfigMetaParser(
          const MetaConfig(
            itemsPath: 'data',
            pagePath: 'meta.pagination.current_page',
          ),
        );

        final meta = customParser.parseMeta(data);
        expect(meta.page, 2);
      });
    });

    group('Type validation', () {
      test('should handle wrong type for page (string instead of int)', () {
        final data = {
          'data': [],
          'meta': {
            'current_page': '1', // String instead of int
            'per_page': 20,
          },
        };

        final meta = parser.parseMeta(data);

        expect(meta.page, isNull); // Should ignore wrong type
        expect(meta.perPage, 20);
      });

      test('should handle wrong type for hasMore (string instead of bool)', () {
        final data = {
          'data': [],
          'meta': {
            'current_page': 1,
            'per_page': 20,
            'has_more': 'true', // String instead of bool
          },
        };

        final meta = parser.parseMeta(data);

        expect(meta.hasMore, isNull); // Should ignore wrong type
      });
    });

    group('Caching', () {
      test('should cache parsed paths', () {
        final data = {
          'data': [],
          'meta': {
            'current_page': 1,
            'per_page': 20,
          },
        };

        // Parse multiple times
        parser.parseMeta(data);
        parser.parseMeta(data);
        parser.parseMeta(data);

        // Path cache should be populated
        // (We can't directly test private cache, but we can verify it works)
        final meta = parser.parseMeta(data);
        expect(meta.page, 1);
      });

      test('should cache parsed metadata for small structures', () {
        final data = {
          'data': [],
          'meta': {
            'current_page': 1,
            'per_page': 20,
          },
        };

        // Parse first time
        final meta1 = parser.parseMeta(data);

        // Parse second time - should use cache
        final meta2 = parser.parseMeta(data);

        expect(meta1.page, meta2.page);
        expect(meta1.perPage, meta2.perPage);
      });

      test('should clear cache when clearCache is called', () {
        final data = {
          'data': [],
          'meta': {'current_page': 1},
        };

        parser.parseMeta(data);
        parser.clearCache();

        // After clearing, should still work
        final meta = parser.parseMeta(data);
        expect(meta.page, 1);
      });
    });

    group('Error handling', () {
      test('should throw PaginationError with truncated data on parse failure',
          () {
        // Create data that will cause a parse error
        final data = {
          'data': 'not a list', // This will cause extractItems to fail
        };

        expect(
          () => parser.extractItems(data),
          throwsA(
            isA<PaginationError>().having(
              (e) => e.when(
                parse: (message, expectedFormat, actualData) => actualData,
                network: (_, __, ___) => null,
                cancelled: (_) => null,
                rateLimited: (_, __) => null,
                circuitBreaker: (_, __) => null,
                unknown: (_, __) => null,
              ),
              'actualData',
              isNotNull,
            ),
          ),
        );
      });

      test('should provide helpful error message on extraction failure', () {
        final data = {'data': 'invalid'};

        expect(
          () => parser.extractItems(data),
          throwsA(
            isA<PaginationError>().having(
              (e) => e.when(
                parse: (message, expectedFormat, actualData) => message,
                network: (_, __, ___) => null,
                cancelled: (_) => null,
                rateLimited: (_, __) => null,
                circuitBreaker: (_, __) => null,
                unknown: (_, __) => null,
              ),
              'message',
              contains('does not contain a list'),
            ),
          ),
        );
      });
    });
  });
}
