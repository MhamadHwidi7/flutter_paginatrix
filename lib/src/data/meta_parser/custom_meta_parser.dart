import 'package:flutter_paginatrix/src/core/contracts/meta_parser.dart';
import 'package:flutter_paginatrix/src/core/entities/page_meta.dart';
import 'package:flutter_paginatrix/src/core/entities/pagination_error.dart';
import 'package:flutter_paginatrix/src/core/typedefs/typedefs.dart';
import 'package:flutter_paginatrix/src/core/utils/error_utils.dart';

/// Meta parser that uses custom transform functions
class CustomMetaParser implements MetaParser {
  CustomMetaParser(
    this._transform, {
    String? itemsKey,
    String? metaKey,
  })  : _itemsKey = itemsKey ?? 'items',
        _metaKey = metaKey ?? 'meta';
  final MetaTransform _transform;
  final String? _itemsKey;
  final String? _metaKey;

  @override
  PageMeta parseMeta(Map<String, dynamic> data) {
    try {
      final transformed = _transform(data);

      if (!transformed.containsKey(_metaKey)) {
        throw ErrorUtils.createParseError(
          message: 'Transform result missing meta key "$_metaKey"',
          expectedFormat: 'Expected keys: $_metaKey',
          actualData: transformed,
        );
      }

      final metaData = transformed[_metaKey] as Map<String, dynamic>?;
      if (metaData == null) {
        throw ErrorUtils.createParseError(
          message: 'Meta data is null',
          expectedFormat: 'Expected non-null meta data',
          actualData: transformed,
        );
      }

      return PageMeta.fromJson(metaData);
    } catch (e) {
      if (e is PaginationError) rethrow;
      throw ErrorUtils.createParseError(
        message: 'Failed to parse meta from transform result: $e',
        expectedFormat: 'Expected valid PageMeta data',
        actualData: data,
      );
    }
  }

  @override
  List<Map<String, dynamic>> extractItems(Map<String, dynamic> data) {
    try {
      final transformed = _transform(data);

      if (!transformed.containsKey(_itemsKey)) {
        throw ErrorUtils.createParseError(
          message: 'Transform result missing items key "$_itemsKey"',
          expectedFormat: 'Expected keys: $_itemsKey',
          actualData: transformed,
        );
      }

      final items = transformed[_itemsKey];
      if (items is! List) {
        throw ErrorUtils.createParseError(
          message: 'Items key "$_itemsKey" does not contain a list',
          expectedFormat: 'Expected a list of items',
          actualData: items,
        );
      }

      // Validate all items are Maps before casting
      // This prevents runtime errors from unsafe type casting
      final List<Map<String, dynamic>> validatedItems = [];
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        if (item is Map<String, dynamic>) {
          validatedItems.add(item);
        } else {
          throw ErrorUtils.createParseError(
            message: 'Item at index $i is not a Map<String, dynamic>. '
                'Got ${item.runtimeType} instead.',
            expectedFormat: 'Expected all items to be Map<String, dynamic>',
            actualData: item,
          );
        }
      }
      return validatedItems;
    } catch (e) {
      if (e is PaginationError) rethrow;
      throw ErrorUtils.createParseError(
        message: 'Failed to extract items from transform result: $e',
        expectedFormat: 'Expected items list',
        actualData: data,
      );
    }
  }

  @override
  bool validateStructure(Map<String, dynamic> data) {
    try {
      final transformed = _transform(data);
      return transformed.containsKey(_itemsKey) &&
          transformed.containsKey(_metaKey);
    } catch (e) {
      return false;
    }
  }
}
