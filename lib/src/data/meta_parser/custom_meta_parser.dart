import '../../core/contracts/meta_parser.dart';
import '../../core/entities/page_meta.dart';
import '../../core/entities/pagination_error.dart';
import '../../core/typedefs/typedefs.dart';

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
        throw PaginationError.parse(
          message: 'Transform result missing meta key "$_metaKey"',
          expectedFormat: 'Expected keys: $_metaKey',
          actualData: transformed.toString(),
        );
      }

      final metaData = transformed[_metaKey] as Map<String, dynamic>?;
      if (metaData == null) {
        throw PaginationError.parse(
          message: 'Meta data is null',
          expectedFormat: 'Expected non-null meta data',
          actualData: transformed.toString(),
        );
      }

      return PageMeta.fromJson(metaData);
    } catch (e) {
      if (e is PaginationError) rethrow;
      throw PaginationError.parse(
        message: 'Failed to parse meta from transform result: $e',
        expectedFormat: 'Expected valid PageMeta data',
        actualData: data.toString(),
      );
    }
  }

  @override
  List<Map<String, dynamic>> extractItems(Map<String, dynamic> data) {
    try {
      final transformed = _transform(data);

      if (!transformed.containsKey(_itemsKey)) {
        throw PaginationError.parse(
          message: 'Transform result missing items key "$_itemsKey"',
          expectedFormat: 'Expected keys: $_itemsKey',
          actualData: transformed.toString(),
        );
      }

      final items = transformed[_itemsKey];
      if (items is List) {
        return items.cast<Map<String, dynamic>>();
      } else {
        throw PaginationError.parse(
          message: 'Items key "$_itemsKey" does not contain a list',
          expectedFormat: 'Expected a list of items',
          actualData: items.toString(),
        );
      }
    } catch (e) {
      if (e is PaginationError) rethrow;
      throw PaginationError.parse(
        message: 'Failed to extract items from transform result: $e',
        expectedFormat: 'Expected items list',
        actualData: data.toString(),
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
