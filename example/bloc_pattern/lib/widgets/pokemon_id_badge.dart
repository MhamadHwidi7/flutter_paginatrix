library;

import 'package:flutter/material.dart';

/// Pokemon ID badge
class PokemonIdBadge extends StatelessWidget {
  const PokemonIdBadge({
    required this.pokemonId,
    required this.colorScheme,
    super.key,
  });

  final int pokemonId;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '#${pokemonId.toString().padLeft(3, '0')}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
