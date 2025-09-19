// class UserInfoRequestModel {
//   final String level;
//   final String gender;
//   final String mobileNumber;
//   final String? imagePath; // or handle via multipart

//   UserInfoRequestModel({
//     required this.level,
//     required this.gender,
//     required this.mobileNumber,
//     required this.imagePath,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "level": level,
//       "gender": gender,
//       "mobile": mobileNumber,
//       "photo": imagePath, // optional, can be sent as multipart instead
//     };
//   }
// }

// class UserInfoRequestModel {
//   final String name;
//   final String phoneNumber;
//   final String clubAffiliation;
//   final String gender;
//   final String playingLevel;

//   UserInfoRequestModel({
//     required this.name,
//     required this.phoneNumber,
//     required this.clubAffiliation,
//     required this.gender,
//     required this.playingLevel,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "name": name,
//       "phoneNumber": phoneNumber,
//       "clubAffiliation": clubAffiliation,
//       "gender": gender,
//       "playingLevel": playingLevel,
//     };
//   }

//   factory UserInfoRequestModel.fromJson(Map<String, dynamic> json) {
//     return UserInfoRequestModel(
//       name: json["name"] ?? "",
//       phoneNumber: json["phoneNumber"] ?? "",
//       clubAffiliation: json["clubAffiliation"] ?? "",
//       gender: json["gender"] ?? "",
//       playingLevel: json["playingLevel"] ?? "",
//     );
//   }
// }

import 'dart:io';
import 'package:dio/dio.dart';

class UserInfoRequestModel {
  final String name;
  final String phoneNumber;
  final String clubAffiliation;
  final String gender;
  final String playingLevel;
  final File? image; // optional image file

  UserInfoRequestModel({
    required this.name,
    required this.phoneNumber,
    required this.clubAffiliation,
    required this.gender,
    required this.playingLevel,
    this.image, // not required anymore
  });

  /// Convert to FormData for Dio request
  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {
      "name": name,
      "phoneNumber": phoneNumber,
      "clubAffiliation": clubAffiliation,
      "gender": gender,
      "playingLevel": playingLevel,
    };

    if (image != null) {
      data["profileImage"] = await MultipartFile.fromFile(
        image!.path,
        filename: image!.path.split("/").last,
      );
    }

    return FormData.fromMap(data);
  }
}
