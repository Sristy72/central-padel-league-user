class Team {
  final String id;
  final String userId;
  final String teamName;
  final String captainName;
  final String partnerName;
  final String playerLevels;
  final String email;
  final String contactNumber;
  final String logoPhotoUrl;
  final String leagueId;
  final bool agreedToRules;
  final bool confirmedAvailability;
  final String applicationStatus;

  Team({
    required this.id,
    required this.userId,
    required this.teamName,
    required this.captainName,
    required this.partnerName,
    required this.playerLevels,
    required this.email,
    required this.contactNumber,
    required this.logoPhotoUrl,
    required this.leagueId,
    required this.agreedToRules,
    required this.confirmedAvailability,
    required this.applicationStatus,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['_id'] ?? '',
      userId: json['user'] ?? '',
      teamName: json['teamName'] ?? '',
      captainName: json['captainName'] ?? '',
      partnerName: json['partnerName'] ?? '',
      playerLevels: json['playerLevels'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      logoPhotoUrl: json['logoPhotoUrl'] ?? '',
      leagueId: json['league'] ?? '',
      agreedToRules: json['agreedToRules'] ?? false,
      confirmedAvailability: json['confirmedAvailability'] ?? false,
      applicationStatus: json['applicationStatus'] ?? '',
    );
  }
}