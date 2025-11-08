import 'package:dio/dio.dart';
import 'package:flutter_paginatrix/flutter_paginatrix.dart';

import '../models/pokemon.dart';

/// Repository for Pokemon API operations
///
/// This repository follows the Repository Pattern, providing a clean abstraction
/// over the data source (Pokemon API). It handles:
/// - API calls to PokeAPI
/// - Data transformation
/// - Error handling
/// - Pagination support
class PokemonRepository {
  PokemonRepository({
    Dio? dio,
  }) : _dio = dio ?? Dio(
          BaseOptions(
            baseUrl: 'https://pokeapi.co/api/v2',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  final Dio _dio;

  /// Loads a page of Pokemon data
  ///
  /// This single function handles both initial load and pagination.
  /// The returned data will be appended to the existing list by PaginatedController.
  ///
  /// [page] - Page number (1-based). For first page, use 1. For next page, use current + 1.
  /// [perPage] - Number of items per page
  /// [offset] - Alternative to page: offset for offset/limit pagination
  /// [limit] - Alternative to perPage: limit for offset/limit pagination
  /// [cancelToken] - Optional cancel token for request cancellation
  ///
  /// Returns a map with 'data' (list of Pokemon to add) and 'meta' (pagination info)
  Future<Map<String, dynamic>> loadPokemonPage({
    int? page,
    int? perPage,
    int? offset,
    int? limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    try {
      // PokeAPI uses offset/limit, not page/perPage
      final currentPage = page ?? 1;
      final itemsPerPage = perPage ?? 20;
      final offsetValue = offset ?? ((currentPage - 1) * itemsPerPage);
      final limitValue = limit ?? itemsPerPage;

      final response = await _dio.get(
        '/pokemon',
        queryParameters: {
          'offset': offsetValue,
          'limit': limitValue,
        },
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw PaginationError.network(
          message: 'Failed to fetch Pokemon: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final data = response.data as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? [];
      final count = data['count'] as int? ?? 0;
      final next = data['next'] as String?;

      // Extract Pokemon IDs from results
      final pokemonIds = <int>[];
      for (final item in results) {
        final itemMap = item as Map<String, dynamic>;
        final url = itemMap['url'] as String? ?? '';
        final idMatch = RegExp(r'/pokemon/(\d+)/').firstMatch(url);
        if (idMatch != null) {
          pokemonIds.add(int.parse(idMatch.group(1)!));
        }
      }

      // Fetch full Pokemon details in parallel (includes types, images, stats, etc.)
      // All requests run simultaneously for better performance
      final pokemonFutures = pokemonIds.map((id) => fetchPokemonDetails(
            pokemonId: id,
            cancelToken: cancelToken,
          ));

      // Wait for all Pokemon details to be fetched
      final pokemonList = await Future.wait(pokemonFutures);

      // Calculate pagination metadata
      final totalPages = (count / itemsPerPage).ceil();
      final hasMore = next != null;

      // Return the Pokemon data that will be added to the list
      // PaginatedController handles appending this to existing items
      return {
        'data': pokemonList.map((p) => _pokemonToJson(p)).toList(),
        'meta': {
          'current_page': currentPage,
          'per_page': itemsPerPage,
          'total': count,
          'last_page': totalPages,
          'has_more': hasMore,
          'offset': offsetValue,
          'limit': limitValue,
        },
      };
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
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
      if (e is PaginationError) rethrow;
      throw PaginationError.unknown(
        message: 'An unexpected error occurred: ${e.toString()}',
        originalError: e.toString(),
      );
    }
  }

  /// Fetches detailed information for a specific Pokemon
  ///
  /// [pokemonId] - The Pokemon ID
  /// [cancelToken] - Optional cancel token for request cancellation
  Future<Pokemon> fetchPokemonDetails({
    required int pokemonId,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        '/pokemon/$pokemonId',
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw PaginationError.network(
          message: 'Failed to fetch Pokemon details: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final data = response.data as Map<String, dynamic>;
      return Pokemon.fromJson(data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw const PaginationError.cancelled(
          message: 'Request was cancelled',
        );
      }

      throw PaginationError.network(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e.toString(),
      );
    } catch (e) {
      if (e is PaginationError) rethrow;
      throw PaginationError.unknown(
        message: 'An unexpected error occurred: ${e.toString()}',
        originalError: e.toString(),
      );
    }
  }

  /// Converts Pokemon to JSON for the pagination system
  Map<String, dynamic> _pokemonToJson(Pokemon pokemon) {
    return {
      'id': pokemon.id,
      'name': pokemon.name,
      'imageUrl': pokemon.imageUrl,
      'height': pokemon.height,
      'weight': pokemon.weight,
      'types': pokemon.types,
      'baseExperience': pokemon.baseExperience,
    };
  }
}

