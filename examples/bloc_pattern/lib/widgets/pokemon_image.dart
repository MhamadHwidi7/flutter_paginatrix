library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'pokemon_id_badge.dart';

/// Pokemon image section with ID badge
class PokemonImage extends StatelessWidget {
  const PokemonImage({
    required this.imageUrl,
    required this.pokemonId,
    required this.colorScheme,
    super.key,
  });

  final String imageUrl;
  final int pokemonId;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          // Optimized cache sizes for 2-column grid to prevent jank frames
          // Display size: ~180-200px width, ~240-267px height
          // Memory cache: Actual display size (1x)
          memCacheWidth: 200,
          memCacheHeight: 267,
          // Disk cache: 2x for retina displays
          maxWidthDiskCache: 400,
          maxHeightDiskCache: 534,
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return ColoredBox(
              color: colorScheme.surfaceContainerHighest,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: downloadProgress.progress,
                  color: colorScheme.primary,
                ),
              ),
            );
          },
          errorWidget: (context, url, error) => ColoredBox(
            color: colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.image_not_supported,
              color: colorScheme.onSurfaceVariant,
              size: 48,
            ),
          ),
          fadeInDuration: const Duration(milliseconds: 300),
        ),
        // Pokemon ID badge
        Positioned(
          top: 8,
          right: 8,
          child: PokemonIdBadge(
            pokemonId: pokemonId,
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }
}
