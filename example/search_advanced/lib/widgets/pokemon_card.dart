library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../utils/pokemon_type_colors.dart';
import 'package:shared/utils/string_extensions.dart';
import 'pokemon_stat_chip.dart';

/// Reusable Pokemon card widget
///
/// Displays a Pokemon with its image, name, ID badge, types, and stats.
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
    final primaryType = pokemon.types.isNotEmpty
        ? PokemonTypeColors.getTypeColor(pokemon.types.first)
        : Colors.grey;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryType.withValues(alpha: 0.15),
              primaryType.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pokemon image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Hero(
                  tag: 'pokemon-${pokemon.id}',
                  child: CachedNetworkImage(
                    imageUrl: pokemon.imageUrl,
                    fit: BoxFit.contain,
                    memCacheWidth: 200,
                    memCacheHeight: 267,
                    maxWidthDiskCache: 400,
                    maxHeightDiskCache: 534,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.error_outline,
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Pokemon info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and ID
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pokemon.name.capitalizeFirst(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '#${pokemon.id.toString().padLeft(3, '0')}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Types
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: pokemon.types.map((type) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: PokemonTypeColors.getTypeColor(type),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          type.capitalizeFirst(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  // Stats
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      PokemonStatChip(
                        icon: Icons.height,
                        label: '${pokemon.height / 10}m',
                      ),
                      PokemonStatChip(
                        icon: Icons.monitor_weight,
                        label: '${pokemon.weight / 10}kg',
                      ),
                      if (pokemon.baseExperience != null)
                        PokemonStatChip(
                          icon: Icons.star,
                          label: '${pokemon.baseExperience} XP',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
