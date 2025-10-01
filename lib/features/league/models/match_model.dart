import 'team_model.dart';

class SetScore {
  final int teamOneGames;
  final int teamTwoGames;

  SetScore({required this.teamOneGames, required this.teamTwoGames});

  factory SetScore.fromJson(Map<String, dynamic> json) {
    return SetScore(
      teamOneGames: (json['teamOneGames'] ?? 0) as int,
      teamTwoGames: (json['teamTwoGames'] ?? 0) as int,
    );
  }
}

class Match {
  final String id;
  final Team teamOne;
  final Team teamTwo;
  final DateTime matchDateTime;
  final String matchStatus;
  final List<SetScore> sets;
  final Team? winnerTeam;
  final String venueName;
  final String leagueName;
  final String leagueId;

  Match({
    required this.id,
    required this.teamOne,
    required this.teamTwo,
    required this.matchDateTime,
    required this.matchStatus,
    required this.sets,
    this.winnerTeam,
    required this.venueName,
    required this.leagueName,
    required this.leagueId,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? s) {
      if (s == null) return DateTime.fromMillisecondsSinceEpoch(0);
      try {
        return DateTime.parse(s);
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    final matchScore = json['matchScore'] as Map<String, dynamic>?;
    final setsJson = matchScore != null && matchScore['sets'] is List
        ? (matchScore['sets'] as List)
        : <dynamic>[];

    return Match(
      id: json['_id'] ?? '',
      teamOne: Team.fromJson(json['teamOne'] as Map<String, dynamic>),
      teamTwo: Team.fromJson(json['teamTwo'] as Map<String, dynamic>),
      matchDateTime: parseDate(json['matchDateTime'] as String?),
      matchStatus: json['matchStatus'] ?? '',
      sets: setsJson
          .map((e) => SetScore.fromJson(e as Map<String, dynamic>))
          .toList(),
      winnerTeam: json['winnerTeam'] != null
          ? Team.fromJson(json['winnerTeam'] as Map<String, dynamic>)
          : null,
      venueName: (json['matchVenue'] is Map)
          ? (json['matchVenue']['name'] ?? '') as String
          : '',
      leagueName: (json['league'] is Map)
          ? (json['league']['leagueName'] ?? '') as String
          : (json['league'] ?? '').toString(),
      // capture league id when available for filtering
      leagueId: (json['league'] is Map)
          ? (json['league']['_id'] ?? '') as String
          : (json['league'] ?? '').toString(),
    );
  }

  /// helper: compute set wins as a formatted score like '2 - 1'
  String formattedScore() {
    var a = 0;
    var b = 0;
    for (final s in sets) {
      if (s.teamOneGames > s.teamTwoGames)
        a++;
      else if (s.teamTwoGames > s.teamOneGames)
        b++;
    }
    return '$a - $b';
  }

  /// helper: per-set breakdown like '2-1, 3-0'
  String setsBreakdown() {
    return sets.map((s) => '${s.teamOneGames}-${s.teamTwoGames}').join(', ');
  }
}
