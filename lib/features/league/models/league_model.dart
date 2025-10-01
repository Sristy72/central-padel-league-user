import 'package:karlfive/features/league/models/league_user_model.dart';
import 'package:karlfive/features/league/models/team_model.dart';

class League {
  final String id;
  final User? user;
  final String leagueName;
  final String description;
  final String leagueLogo;
  final String? bannerImage;
  final DateTime startDate;
  final DateTime? endDate;
  final String location;
  final List<Team> addTeams; // Added field for teams
  final int? totalGameWeeks;
  final String type;
  final String matchFormat;
  final String tiebreakOption;
  final bool allowSubstitutes;

  League({
    required this.id,
    this.user,
    required this.leagueName,
    required this.description,
    required this.leagueLogo,
    this.bannerImage,
    required this.startDate,
    this.endDate,
    required this.location,
    this.addTeams = const [],
    this.totalGameWeeks,
    required this.type,
    required this.matchFormat,
    required this.tiebreakOption,
    required this.allowSubstitutes,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    DateTime? tryParseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return null;
      }
    }

    // parse teams if present; will be mapped inline below
    return League(
      id: json['_id'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      leagueName: json['leagueName'] ?? '',
      description: json['description'] ?? '',
      leagueLogo: json['leagueLogo'] ?? '',
      bannerImage: json['bannerImage'],
      startDate: tryParseDate(json['startDate']) ?? DateTime.now(),
      endDate: tryParseDate(json['endDate']),
      location: json['location'] ?? '',
      addTeams: (json['addTeams'] is List)
          ? (json['addTeams'] as List)
                .map((e) => Team.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      totalGameWeeks: json['totalGameWeeks'],
      type: json['type'] ?? '',
      matchFormat: json['matchFormat'] ?? '',
      tiebreakOption: json['tiebreakOption'] ?? '',
      allowSubstitutes: json['allowSubstitutes'] ?? false,
    );
  }
}
