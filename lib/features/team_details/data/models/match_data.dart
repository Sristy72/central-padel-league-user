class MatchData {
  final String date, team1, team2;
  bool isStarred;

  MatchData({
    required this.date,
    required this.team1,
    required this.team2,
    this.isStarred = false,
  });
}
