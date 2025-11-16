/// Product model
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as String,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  final int id;
  final String name;
  final String price;
  final String image;
  final double rating;
}

