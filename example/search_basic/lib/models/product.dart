/// Product model
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
    );
  }
}
