import 'package:karlfive/features/home/models/player_model.dart';

class MatchTeam {
  final String teamName;
  final List<Player> players;

  MatchTeam({required this.teamName, required this.players});

  factory MatchTeam.fromJson(Map<String, dynamic> json) {
    return MatchTeam(
      teamName: json["teamName"] ?? "",
      players: (json["players"] as List<dynamic>? ?? [])
          .map((e) => Player.fromJson(e))
          .toList(),
    );
  }
}
