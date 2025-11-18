library;

import 'package:flutter/material.dart';

import 'package:shared/utils/string_extensions.dart';

/// Pokemon types badges
class PokemonTypes extends StatelessWidget {
  const PokemonTypes({
    required this.types,
    required this.theme,
    super.key,
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
            type.capitalizeFirst(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: typeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
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

