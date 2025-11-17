/// User model for list view example
class User {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      role: json['role'] as String,
    );
  }
}
