library;

import 'package:flutter/material.dart';

import 'package:shared/utils/string_extensions.dart';

import 'pokemon_types.dart';

/// Pokemon info section (name and types)
class PokemonInfo extends StatelessWidget {
  const PokemonInfo({
    required this.name,
    required this.types,
    required this.theme,
    super.key,
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
            name.capitalizeFirst(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Pokemon Types
          if (types.isNotEmpty)
            PokemonTypes(types: types, theme: theme)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

