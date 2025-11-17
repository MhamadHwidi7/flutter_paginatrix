/// Simple Pokemon model
class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = int.parse(url.split('/')[url.split('/').length - 2]);

    return Pokemon(
      id: id,
      name: json['name'] as String,
      url: url,
    );
  }

  final int id;
  final String name;
  final String url;

  String get imageUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }
}


