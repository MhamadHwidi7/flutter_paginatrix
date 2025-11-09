import 'package:flutter_paginatrix/src/core/entities/page_meta.dart';

/// Contract for parsing pagination metadata from API responses
abstract class MetaParser {
  /// Parses pagination metadata from raw response data
  ///
  /// [data] - Raw response data from API
  ///
  /// Returns parsed metadata or throws PaginationError.parse if parsing fails
  PageMeta parseMeta(Map<String, dynamic> data);

  /// Extracts items from raw response data
  ///
  /// [data] - Raw response data from API
  ///
  /// Returns list of raw item data
  List<Map<String, dynamic>> extractItems(Map<String, dynamic> data);

  /// Validates that the response data has the expected structure
  ///
  /// [data] - Raw response data from API
  ///
  /// Returns true if data structure is valid
  bool validateStructure(Map<String, dynamic> data);
}
