import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import '../models/pokemon.dart';

/// Repository for Pokemon API operations with search, filter, and sort support
///
/// This repository follows the Repository Pattern, providing a clean abstraction
/// over the data source (Pokemon API). It handles:
/// - API calls to PokeAPI
/// - Client-side search, filtering, and sorting
/// - Data transformation
/// - Error handling
/// - Pagination support
class PokemonRepository {
  PokemonRepository({
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://pokeapi.co/api/v2',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  final Dio _dio;

  /// Loads a page of Pokemon data with search, filter, and sort support
  ///
  /// This function handles both initial load and pagination.
  /// The returned data will be appended to the existing list by PaginatedController.
  ///
  /// [page] - Page number (1-based). For first page, use 1. For next page, use current + 1.
  /// [perPage] - Number of items per page
  /// [offset] - Alternative to page: offset for offset/limit pagination
  /// [limit] - Alternative to perPage: limit for offset/limit pagination
  /// [cancelToken] - Optional cancel token for request cancellation
  /// [query] - Optional query criteria containing search term, filters, and sorting
  ///
  /// Returns a map with 'data' (list of Pokemon to add) and 'meta' (pagination info)
  Future<Map<String, dynamic>> loadPokemonPage({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
    QueryCriteria? query,
  }) async {
    // Extract query parameters
    final searchTerm = query?.searchTerm;
    final typeFilter = query?.filters['type'] as String?;
    final sortBy = query?.sortBy;
    final sortDesc = query?.sortDesc ?? false;
    try {
      // PokeAPI uses offset/limit, not page/perPage
      final currentPage = page ?? 1;
      final itemsPerPage = perPage ?? 20;
      final offsetValue = offset ?? ((currentPage - 1) * itemsPerPage);
      final limitValue = limit ?? itemsPerPage;

      // Debug: Print API call parameters
      debugPrint('🔵 [PokemonRepository] API Call:');
      debugPrint('   📄 Page: $currentPage');
      debugPrint('   📊 Items per page: $itemsPerPage');
      debugPrint('   📍 Offset: $offsetValue, Limit: $limitValue');
      if (searchTerm != null && searchTerm.isNotEmpty) {
        debugPrint('   🔍 Search: "$searchTerm"');
      }
      if (typeFilter != null && typeFilter.isNotEmpty) {
        debugPrint('   🏷️  Type filter: $typeFilter');
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        debugPrint('   🔄 Sort: $sortBy (${sortDesc ? "desc" : "asc"})');
      }

      // Fetch list of Pokemon from API
      debugPrint(
          '   🌐 Making API request: GET /pokemon?offset=$offsetValue&limit=$limitValue');
      final stopwatch = Stopwatch()..start();
      final response = await _dio.get<Map<String, dynamic>>(
        '/pokemon',
        queryParameters: {
          'offset': offsetValue,
          'limit': limitValue,
        },
        cancelToken: cancelToken,
      );
      stopwatch.stop();
      debugPrint(
          '   ✅ API Response received in ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('   📦 Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw PaginationError.network(
          message: 'Failed to fetch Pokemon: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final data = response.data ?? <String, dynamic>{};
      final results = (data['results'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      final count = (data['count'] as num?)?.toInt() ?? 0;

      debugPrint('   📋 Raw results from API: ${results.length} items');
      debugPrint('   📊 Total count: $count');

      // Fetch full Pokemon details in parallel
      debugPrint('   🔄 Fetching details for ${results.length} Pokemon...');
      final detailsStopwatch = Stopwatch()..start();
      final pokemonFutures = results.map((item) async {
        final url = item['url'] as String;
        final detailResponse = await _dio.get<Map<String, dynamic>>(
          url.replaceFirst('https://pokeapi.co/api/v2', ''),
          cancelToken: cancelToken,
        );
        return detailResponse.data ?? <String, dynamic>{};
      });

      final pokemonDetails = await Future.wait(pokemonFutures);
      detailsStopwatch.stop();
      debugPrint(
          '   ✅ Details fetched in ${detailsStopwatch.elapsedMilliseconds}ms');

      // Transform to Pokemon objects
      var pokemonList = pokemonDetails
          .cast<Map<String, dynamic>>()
          .map(Pokemon.fromJson)
          .toList();

      debugPrint('   🎯 Before filters: ${pokemonList.length} Pokemon');

      // Apply search filter
      if (searchTerm != null && searchTerm.isNotEmpty) {
        final searchLower = searchTerm.toLowerCase();
        final beforeCount = pokemonList.length;
        pokemonList = pokemonList.where((pokemon) {
          final matchesName = pokemon.name.toLowerCase().contains(searchLower);
          final matchesId = pokemon.id.toString().contains(searchLower);
          return matchesName || matchesId;
        }).toList();
        debugPrint(
            '   🔍 After search filter: ${pokemonList.length} Pokemon (filtered ${beforeCount - pokemonList.length})');
      }

      // Apply type filter
      if (typeFilter != null && typeFilter.isNotEmpty) {
        final beforeCount = pokemonList.length;
        pokemonList = pokemonList
            .where((pokemon) => pokemon.types.contains(typeFilter))
            .toList();
        debugPrint(
            '   🏷️  After type filter: ${pokemonList.length} Pokemon (filtered ${beforeCount - pokemonList.length})');
      }

      // Apply sorting
      if (sortBy != null && sortBy.isNotEmpty) {
        pokemonList.sort((a, b) {
          final int comparison;
          switch (sortBy) {
            case 'name':
              comparison = a.name.compareTo(b.name);
              break;
            case 'id':
              comparison = a.id.compareTo(b.id);
              break;
            case 'height':
              comparison = a.height.compareTo(b.height);
              break;
            case 'weight':
              comparison = a.weight.compareTo(b.weight);
              break;
            default:
              comparison = 0;
          }
          return sortDesc ? -comparison : comparison;
        });
        debugPrint('   🔄 Sorted by: $sortBy (${sortDesc ? "desc" : "asc"})');
      }

      // Calculate pagination metadata
      final totalPages = (count / itemsPerPage).ceil();
      final hasMore = currentPage < totalPages;

      debugPrint(
          '   📊 Pagination: Page $currentPage/$totalPages, Has more: $hasMore');
      debugPrint('   ✅ Returning ${pokemonList.length} Pokemon');

      // Return the Pokemon data that will be added to the list
      // PaginatedController handles appending this to existing items
      return {
        'data': pokemonList.map((p) => p.toJson()).toList(),
        'meta': {
          'current_page': currentPage,
          'per_page': itemsPerPage,
          'total': count,
          'last_page': totalPages,
          'has_more': hasMore,
        },
      };
    } on DioException catch (e) {
      debugPrint('   ❌ API Error: ${e.type} - ${e.message}');
      if (e.type == DioExceptionType.cancel) {
        debugPrint('   🚫 Request was cancelled');
        throw const PaginationError.cancelled(
          message: 'Request was cancelled',
        );
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const PaginationError.network(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: null,
        );
      }

      throw PaginationError.network(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e.toString(),
      );
    } catch (e) {
      debugPrint('   ❌ Unexpected error: $e');
      if (e is PaginationError) rethrow;
      throw PaginationError.unknown(
        message: 'An unexpected error occurred: ${e.toString()}',
        originalError: e.toString(),
      );
    }
  }
}
