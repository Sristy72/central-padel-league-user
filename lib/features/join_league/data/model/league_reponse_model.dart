import 'package:karlfive/features/auth/data/models/user_model.dart';

import 'team_model.dart';

class LeagueResponeModel {
  final String id;
  final UserModel user;
  final String leagueName;
  final String description;
  final String leagueLogo;
  final String? bannerImage;
  final DateTime startDate;
  final DateTime? endDate;
  final String location;
  final List<Team> addTeams;
  final int totalGameWeeks;
  final String type;
  final String matchFormat;
  final String tiebreakOption;
  final bool allowSubstitutes;
  final String leagueType; // Add leagueType field
  final String? leagueCode; // Add leagueCode field for OTP verification
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String? price; // New field for amount

  LeagueResponeModel({
    required this.id,
    required this.user,
    required this.leagueName,
    required this.description,
    required this.leagueLogo,
    this.bannerImage,
    required this.startDate,
    this.endDate,
    required this.location,
    required this.addTeams,
    required this.totalGameWeeks,
    required this.type,
    required this.matchFormat,
    required this.tiebreakOption,
    required this.allowSubstitutes,
    required this.leagueType, // Add leagueType parameter
    this.leagueCode, // Add leagueCode parameter
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.price, 
  });

  factory LeagueResponeModel.fromJson(Map<String, dynamic> json) {
    return LeagueResponeModel(
      id: json['_id'] ?? '',
      user: json['user'] != null 
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>) 
          : _createDummyUser(),
      leagueName: json['leagueName'] ?? '',
      description: json['description'] ?? '',
      leagueLogo: json['leagueLogo'] ?? '',
      bannerImage: json['bannerImage'],
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate']) 
          : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      location: json['location'] ?? '',
      addTeams: json['addTeams'] != null 
          ? List<Team>.from((json['addTeams'] as List).map((x) => Team.fromJson(x as Map<String, dynamic>)))
          : [],
      totalGameWeeks: json['totalGameWeeks'] ?? 0,
      type: json['type'] ?? '',
      matchFormat: json['matchFormat'] ?? '',
      tiebreakOption: json['tiebreakOption'] ?? '',
      allowSubstitutes: json['allowSubstitutes'] ?? false,
      leagueType: json['leagueType'] ?? 'public', // Add leagueType parsing
      leagueCode: json['leagueCode'], // Add leagueCode parsing
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      v: json['__v'] ?? 0,
      price: json['price']?.toString(), 
    );
  }

  // Helper method for null user handling
  static UserModel _createDummyUser() {
    return UserModel(
      id: '',
      name: 'Unknown User',
      email: '',
      password: '',
      role: 'player',
      phoneNumber: '',
      isVerified: false,
      refreshToken: '',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      v: 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': user.toJson(),
    'leagueName': leagueName,
    'description': description,
    'leagueLogo': leagueLogo,
    'bannerImage': bannerImage,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'location': location,
    'addTeams': List<dynamic>.from(addTeams.map((x) => x.toJson())),
    'totalGameWeeks': totalGameWeeks,
    'type': type,
    'matchFormat': matchFormat,
    'tiebreakOption': tiebreakOption,
    'allowSubstitutes': allowSubstitutes,
    'leagueType': leagueType, // Add leagueType to JSON
    'leagueCode': leagueCode, // Add leagueCode to JSON
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
    'price': price, 
  };
}
