class Match {
  final String team1LogoPath;
  final String team1Name;
  final String team2LogoPath;
  final String team2Name;
  final String matchDate;
  final String matchTime;
  final String leagueName;
  final String arena;
  final String score;
  final String winner;

  const Match({
    required this.team1LogoPath,
    required this.team1Name,
    required this.team2LogoPath,
    required this.team2Name,
    required this.matchDate,
    required this.matchTime,
    required this.leagueName,
    required this.arena,
    required this.score,
    required this.winner,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      team1LogoPath: json['team1LogoPath'] as String,
      team1Name: json['team1Name'] as String,
      team2LogoPath: json['team2LogoPath'] as String,
      team2Name: json['team2Name'] as String,
      matchDate: json['matchDate'] as String,
      matchTime: json['matchTime'] as String,
      leagueName: json['leagueName'] as String,
      arena: json['arena'] as String,
      score: json['score'] as String,
      winner: json['winner'] as String,
    );
  }
}
