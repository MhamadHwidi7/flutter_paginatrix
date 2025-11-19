library;

import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import 'pokemon_image.dart';
import 'pokemon_info.dart';

/// Reusable Pokemon card widget
///
/// Displays a Pokemon with its image, name, ID badge, and types.
/// Optimized with proper image caching sizes to prevent jank frames.
class PokemonCard extends StatelessWidget {
  const PokemonCard({
    required this.pokemon,
    super.key,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pokemon Image
          Expanded(
            child: PokemonImage(
              imageUrl: pokemon.imageUrl,
              pokemonId: pokemon.id,
              colorScheme: colorScheme,
            ),
          ),
          // Pokemon Info
          PokemonInfo(
            name: pokemon.name,
            types: pokemon.types,
            theme: theme,
          ),
        ],
      ),
    );
  }
}
