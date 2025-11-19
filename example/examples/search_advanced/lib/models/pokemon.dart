/// Pokemon model representing a Pokemon from the PokeAPI
class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
    required this.baseExperience,
  });

  /// Pokemon ID
  final int id;

  /// Pokemon name
  final String name;

  /// Pokemon image URL (official artwork)
  final String imageUrl;

  /// Height in decimeters
  final int height;

  /// Weight in hectograms
  final int weight;

  /// List of Pokemon types (e.g., ["fire", "flying"])
  final List<String> types;

  /// Base experience points
  final int? baseExperience;

  /// Creates a Pokemon from JSON
  ///
  /// This handles both:
  /// 1. Full Pokemon details from API (with types, sprites, etc.)
  /// 2. Simplified Pokemon from repository (with pre-processed data)
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Check if this is a simplified Pokemon from repository
    if (json.containsKey('imageUrl') && json['imageUrl'] is String) {
      // Simplified format from repository
      return Pokemon(
        id: json['id'] as int,
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String,
        height: json['height'] as int? ?? 0,
        weight: json['weight'] as int? ?? 0,
        types: (json['types'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        baseExperience: json['baseExperience'] as int?,
      );
    }

    // Full format from PokeAPI
    final id = json['id'] as int;
    final name = json['name'] as String;

    // Extract types
    final typesList = json['types'] as List<dynamic>? ?? [];
    final types = typesList
        .map((type) => (type['type'] as Map<String, dynamic>)['name'] as String)
        .toList();

    // Get official artwork image
    final sprites = json['sprites'] as Map<String, dynamic>? ?? {};
    final other = sprites['other'] as Map<String, dynamic>? ?? {};
    final officialArtwork =
        other['official-artwork'] as Map<String, dynamic>? ?? {};
    final imageUrl = officialArtwork['front_default'] as String? ??
        sprites['front_default'] as String? ??
        '';

    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      height: json['height'] as int? ?? 0,
      weight: json['weight'] as int? ?? 0,
      types: types,
      baseExperience: json['base_experience'] as int?,
    );
  }

  /// Creates a Pokemon from a list item JSON (from paginated response)
  factory Pokemon.fromListItemJson(Map<String, dynamic> json) {
    // When getting from list endpoint, we only have name and url
    // We need to extract ID from URL: https://pokeapi.co/api/v2/pokemon/1/
    final url = json['url'] as String? ?? '';
    final idMatch = RegExp(r'/pokemon/(\d+)/').firstMatch(url);
    final group1 = idMatch?.group(1);
    final id = (group1 != null) ? int.parse(group1) : 0;

    final name = json['name'] as String;

    // Construct image URL from ID
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      height: 0, // Will be filled when fetching full details
      weight: 0, // Will be filled when fetching full details
      types: [], // Will be filled when fetching full details
      baseExperience: null,
    );
  }

  /// Converts Pokemon to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'height': height,
      'weight': weight,
      'types': types,
      'baseExperience': baseExperience,
    };
  }

  /// Creates a copy with updated values
  Pokemon copyWith({
    int? id,
    String? name,
    String? imageUrl,
    int? height,
    int? weight,
    List<String>? types,
    int? baseExperience,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      types: types ?? this.types,
      baseExperience: baseExperience ?? this.baseExperience,
    );
  }

  @override
  String toString() {
    return 'Pokemon(id: $id, name: $name, types: $types)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pokemon && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
