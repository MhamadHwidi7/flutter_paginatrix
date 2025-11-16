import 'package:dio/dio.dart';
import 'package:flutter_paginatrix/src/core/entities/query_criteria.dart';

/// Function type for loading a page of paginated data
///
/// This single function handles both initial load and pagination.
/// The controller will call this function with the appropriate page number,
/// and the returned data will be either set (first page) or appended (next page).
///
/// [page] - Page number (1-based). For first page, use 1. For next page, use current + 1.
/// [perPage] - Number of items per page
/// [offset] - Offset for offset/limit pagination (alternative to page)
/// [limit] - Limit for offset/limit pagination (alternative to perPage)
/// [cursor] - Cursor for cursor-based pagination
/// [cancelToken] - Cancel token for request cancellation
/// [query] - Optional QueryCriteria containing search, filters, and sorting.
///           If provided, use this for type-safe access to all query parameters.
///           If not provided, you can access query via closure from state.
///
/// Returns a Future that resolves to a map with 'data' (list of items to add)
/// and 'meta' (pagination metadata)
///
/// **Note:** The [query] parameter is optional for backward compatibility.
/// New implementations should use [query] instead of accessing state via closure.
typedef LoaderFn<T> = Future<Map<String, dynamic>> Function({
  int? page,
  int? perPage,
  int? offset,
  int? limit,
  String? cursor,
  CancelToken? cancelToken,
  QueryCriteria? query,
});

/// Function type for decoding individual items from raw data
///
/// [data] - Raw item data from the response
///
/// Returns the decoded item of type T
typedef ItemDecoder<T> = T Function(Map<String, dynamic> data);

/// Function type for transforming raw response data
///
/// [data] - Raw response data
///
/// Returns a map containing 'items' and 'meta' keys
typedef MetaTransform = Map<String, dynamic> Function(
    Map<String, dynamic> data);
