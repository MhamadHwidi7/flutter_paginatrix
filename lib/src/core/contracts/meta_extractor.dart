import 'package:flutter_paginatrix/src/core/entities/page_meta.dart';

/// Contract for extracting pagination metadata and items from API responses
///
/// This interface follows the Interface Segregation Principle by separating
/// extraction concerns from validation concerns. Use this interface when you
/// only need to extract data without validation.
abstract class MetaExtractor {
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
}
