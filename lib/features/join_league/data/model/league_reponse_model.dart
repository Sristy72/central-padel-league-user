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
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

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
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory LeagueResponeModel.fromJson(Map<String, dynamic> json) {
    return LeagueResponeModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['user']),
      leagueName: json['leagueName'] ?? '',
      description: json['description'] ?? '',
      leagueLogo: json['leagueLogo'] ?? '',
      bannerImage: json['bannerImage'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      location: json['location'] ?? '',
      addTeams: List<Team>.from(
        (json['addTeams'] ?? []).map((x) => Team.fromJson(x)),
      ),
      totalGameWeeks: json['totalGameWeeks'] ?? 0,
      type: json['type'] ?? '',
      matchFormat: json['matchFormat'] ?? '',
      tiebreakOption: json['tiebreakOption'] ?? '',
      allowSubstitutes: json['allowSubstitutes'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
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
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}
