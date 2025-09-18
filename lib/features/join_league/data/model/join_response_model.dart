class JoinResponseModel {
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
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  JoinResponseModel({
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
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory JoinResponseModel.fromJson(Map<String, dynamic> json) {
    return JoinResponseModel(
      user: json['user'] as String,
      teamName: json['teamName'] as String,
      captainName: json['captainName'] as String,
      partnerName: json['partnerName'] as String,
      playerLevels: json['playerLevels'] as String,
      email: json['email'] as String,
      contactNumber: json['contactNumber'] as String,
      logoPhotoUrl: json['logoPhotoUrl'] as String,
      league: json['league'] as String,
      agreedToRules: json['agreedToRules'] as bool,
      confirmedAvailability: json['confirmedAvailability'] as bool,
      applicationStatus: json['applicationStatus'] as String,
      id: json['_id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
    );
  }
}
