class EditProfileModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String birthday;
  String gender;
  String imageUrl;

  EditProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.imageUrl,
  });

  // Optional: copyWith method for easy updates
  EditProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? birthday,
    String? gender,
    String? imageUrl,
  }) {
    return EditProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Optional: toMap & fromMap for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'birthday': birthday,
      'gender': gender,
      'imageUrl': imageUrl,
    };
  }

  factory EditProfileModel.fromMap(Map<String, dynamic> map) {
    return EditProfileModel(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      birthday: map['birthday'] ?? '',
      gender: map['gender'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

