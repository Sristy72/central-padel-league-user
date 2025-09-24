class UserProfileModel {
  final String? id;
  final String? name;
  final String email;
  final String? profileImage;
  final String? role;
  final String? phoneNumber;
  final bool? isVerified;
  final String? refreshToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? clubAffiliation;
  final String? gender;
  final String? playingLevel;

  UserProfileModel({
    this.id,
    this.name,
    required this.email,
    this.profileImage,
    this.role,
    this.phoneNumber,
    this.isVerified,
    this.refreshToken,
    this.createdAt,
    this.updatedAt,
    this.clubAffiliation,
    this.gender,
    this.playingLevel,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] as String?,
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      profileImage: json['profileImage'] as String?,
      role: json['role'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isVerified: json['isVerified'] as bool?,
      refreshToken: json['refreshToken'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      clubAffiliation: json['clubAffiliation'] as String?,
      gender: json['gender'] as String?,
      playingLevel: json['playingLevel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'role': role,
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'refreshToken': refreshToken,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'clubAffiliation': clubAffiliation,
      'gender': gender,
      'playingLevel': playingLevel,
    };
  }
}
