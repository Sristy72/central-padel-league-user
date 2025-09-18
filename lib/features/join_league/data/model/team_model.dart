class Team {
  final String id;
  final String user;
  final String teamName;
  final String captainName;
  final String partnerName;
  final String playerLevels;
  final String email;
  final String contactNumber;
  final String logoPhotoUrl;
  final String league;
  final bool agreedToRules;
  final bool confirmedAvailability;
  final String applicationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Team({
    required this.id,
    required this.user,
    required this.teamName,
    required this.captainName,
    required this.partnerName,
    required this.playerLevels,
    required this.email,
    required this.contactNumber,
    required this.logoPhotoUrl,
    required this.league,
    required this.agreedToRules,
    required this.confirmedAvailability,
    required this.applicationStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      teamName: json['teamName'] ?? '',
      captainName: json['captainName'] ?? '',
      partnerName: json['partnerName'] ?? '',
      playerLevels: json['playerLevels'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      logoPhotoUrl: json['logoPhotoUrl'] ?? '',
      league: json['league'] ?? '',
      agreedToRules: json['agreedToRules'] ?? false,
      confirmedAvailability: json['confirmedAvailability'] ?? false,
      applicationStatus: json['applicationStatus'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': user,
    'teamName': teamName,
    'captainName': captainName,
    'partnerName': partnerName,
    'playerLevels': playerLevels,
    'email': email,
    'contactNumber': contactNumber,
    'logoPhotoUrl': logoPhotoUrl,
    'league': league,
    'agreedToRules': agreedToRules,
    'confirmedAvailability': confirmedAvailability,
    'applicationStatus': applicationStatus,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}
