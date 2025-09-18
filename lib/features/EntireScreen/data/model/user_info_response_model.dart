// class UserInfoResponseModel {
//   final String label;
//   final String gender;
//   final String mobileNumber;
//   final String? imagePath;

//   UserInfoResponseModel({
//     required this.label,
//     required this.gender,
//     required this.mobileNumber,
//     required this.imagePath,
//   });

//   factory UserInfoResponseModel.fromJson(Map<String, dynamic> json) {
//     return UserInfoResponseModel(
//       // id: json['id'] ?? 0,
//       label: json['level'] ?? '',
//       gender: json['gender'] ?? '',
//       mobileNumber: json['mobile'] ?? '',
//       imagePath: json['photo'] ?? '',
//     );
//   }
// }

class UserInfoResponseModel {
  final String? otp;
  final String? otpExpiry;
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String role;
  final String phoneNumber;
  final bool isVerified;
  final String? resetOtp;
  final String? resetOtpExpiry;
  final String refreshToken;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String clubAffiliation;
  final String gender;
  final String playingLevel;

  UserInfoResponseModel({
    this.otp,
    this.otpExpiry,
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.role,
    required this.phoneNumber,
    required this.isVerified,
    this.resetOtp,
    this.resetOtpExpiry,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.clubAffiliation,
    required this.gender,
    required this.playingLevel,
  });

  factory UserInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return UserInfoResponseModel(
      otp: json["otp"],
      otpExpiry: json["otpExpiry"],
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      profileImage: json["profileImage"],
      role: json["role"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      isVerified: json["isVerified"] ?? false,
      resetOtp: json["reset_otp"],
      resetOtpExpiry: json["reset_otpExpiry"],
      refreshToken: json["refreshToken"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
      clubAffiliation: json["clubAffiliation"] ?? "",
      gender: json["gender"] ?? "",
      playingLevel: json["playingLevel"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "otp": otp,
      "otpExpiry": otpExpiry,
      "_id": id,
      "name": name,
      "email": email,
      "profileImage": profileImage,
      "role": role,
      "phoneNumber": phoneNumber,
      "isVerified": isVerified,
      "reset_otp": resetOtp,
      "reset_otpExpiry": resetOtpExpiry,
      "refreshToken": refreshToken,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
      "clubAffiliation": clubAffiliation,
      "gender": gender,
      "playingLevel": playingLevel,
    };
  }
}
