class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String role;
  final String phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.role,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      role: json['role'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}
