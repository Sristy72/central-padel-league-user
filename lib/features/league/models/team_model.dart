class Team {
  final String teamLogoPath;
  final String teamName;

  const Team({required this.teamLogoPath, required this.teamName});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamLogoPath: json['teamLogoPath'] as String,
      teamName: json['teamName'] as String,
    );
  }
}
