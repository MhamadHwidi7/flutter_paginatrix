library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/pokemon.dart';

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
            child: _PokemonImage(
              imageUrl: pokemon.imageUrl,
              pokemonId: pokemon.id,
              colorScheme: colorScheme,
            ),
          ),
          // Pokemon Info
          _PokemonInfo(
            name: pokemon.name,
            types: pokemon.types,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

/// Pokemon image section with ID badge
class _PokemonImage extends StatelessWidget {
  const _PokemonImage({
    required this.imageUrl,
    required this.pokemonId,
    required this.colorScheme,
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
          child: _PokemonIdBadge(
            pokemonId: pokemonId,
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }
}

/// Pokemon ID badge
class _PokemonIdBadge extends StatelessWidget {
  const _PokemonIdBadge({
    required this.pokemonId,
    required this.colorScheme,
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

/// Pokemon info section (name and types)
class _PokemonInfo extends StatelessWidget {
  const _PokemonInfo({
    required this.name,
    required this.types,
    required this.theme,
  });

  final String name;
  final List<String> types;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pokemon Name
          Text(
            _capitalizeFirst(name),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Pokemon Types
          if (types.isNotEmpty)
            _PokemonTypes(types: types, theme: theme)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

/// Pokemon types badges
class _PokemonTypes extends StatelessWidget {
  const _PokemonTypes({
    required this.types,
    required this.theme,
  });

  final List<String> types;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: types.take(2).map((type) {
        final typeColor = _getTypeColor(type);
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: typeColor,
              width: 1,
            ),
          ),
          child: Text(
            _capitalizeFirst(type),
            style: theme.textTheme.labelSmall?.copyWith(
              color: typeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Color _getTypeColor(String type) {
    const typeColors = {
      'normal': Colors.brown,
      'fire': Colors.orange,
      'water': Colors.blue,
      'electric': Colors.yellow,
      'grass': Colors.green,
      'ice': Colors.lightBlue,
      'fighting': Colors.red,
      'poison': Colors.purple,
      'ground': Colors.brown,
      'flying': Colors.lightBlue,
      'psychic': Colors.pink,
      'bug': Colors.green,
      'rock': Colors.brown,
      'ghost': Colors.purple,
      'dragon': Colors.indigo,
      'dark': Colors.brown,
      'steel': Colors.grey,
      'fairy': Colors.pink,
    };
    return typeColors[type.toLowerCase()] ?? Colors.grey;
  }
}

