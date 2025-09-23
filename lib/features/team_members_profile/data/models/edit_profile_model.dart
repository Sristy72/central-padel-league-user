class EditProfileModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String birthday;
  final String gender;
  final String imageUrl;

  EditProfileModel({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.birthday = '',
    this.gender = '',
    this.imageUrl = 'assets/images/profile.png',
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phoneNumber'] ?? json['phone'] ?? '',
      birthday: json['birthday'] ?? '',
      gender: json['gender'] ?? '',
      imageUrl: json['profileImage'] ?? json['imageUrl'] ?? 'assets/images/profile.png',
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'birthday': birthday,
        'gender': gender,
        'profileImage': imageUrl,
      };
}
