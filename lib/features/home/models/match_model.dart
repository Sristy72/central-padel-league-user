import 'package:karlfive/features/home/models/team_model.dart';

class Match {
  final String date;
  final String time;
  final MatchTeam team1;
  final MatchTeam team2;

  Match({
    required this.date,
    required this.time,
    required this.team1,
    required this.team2,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      date: json["date"] ?? "",
      time: json["time"] ?? "",
      team1: MatchTeam.fromJson(json["team1"] ?? {}),
      team2: MatchTeam.fromJson(json["team2"] ?? {}),
    );
  }
}