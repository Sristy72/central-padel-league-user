class Standing {
  final String id;
  final String leagueId;
  final String leagueName;
  final String teamId;
  final String teamName;
  final String teamLogoUrl;
  final int position;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalDifference;
  final int points;

  Standing({
    required this.id,
    required this.leagueId,
    required this.leagueName,
    required this.teamId,
    required this.teamName,
    required this.teamLogoUrl,
    required this.position,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalDifference,
    required this.points,
  });

  factory Standing.fromJson(Map<String, dynamic> json) {
    final team = json['team'] as Map<String, dynamic>?;
    final league = json['league'] as Map<String, dynamic>?;
    return Standing(
      id: json['_id'] ?? '',
      leagueId: league?['_id'] ?? '',
      leagueName: league?['leagueName'] ?? '',
      teamId: team?['_id'] ?? '',
      teamName: team?['teamName'] ?? '',
      teamLogoUrl: team?['logoPhotoUrl'] ?? '',
      position: (json['position'] ?? 0) as int,
      played: (json['played'] ?? 0) as int,
      won: (json['won'] ?? 0) as int,
      drawn: (json['drawn'] ?? 0) as int,
      lost: (json['lost'] ?? 0) as int,
      goalDifference: (json['goalDifference'] ?? 0) as int,
      points: (json['points'] ?? 0) as int,
    );
  }
}
