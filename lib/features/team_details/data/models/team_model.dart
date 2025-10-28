class TeamModel {
  final String id;
  final UserModel? user;
  final String teamName;
  final String captainName;
  final String partnerName;
  final String playerLevels;
  final String email;
  final String contactNumber;
  final String logoPhotoUrl;
  final bool agreedToRules;
  final bool confirmedAvailability;
  final String applicationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LeagueModel? league;

  TeamModel({
    required this.id,
    this.user,
    required this.teamName,
    required this.captainName,
    required this.partnerName,
    required this.playerLevels,
    required this.email,
    required this.contactNumber,
    required this.logoPhotoUrl,
    required this.agreedToRules,
    required this.confirmedAvailability,
    required this.applicationStatus,
    required this.createdAt,
    required this.updatedAt,
    this.league,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['_id'] as String,
      user: json['user'] is String
          ? UserModel(id: json['user'] as String)
          : (json['user'] != null ? UserModel.fromJson(json['user'] as Map<String, dynamic>) : null),
      teamName: json['teamName'] as String? ?? '',
      captainName: json['captainName'] as String? ?? '',
      partnerName: json['partnerName'] as String? ?? '',
      playerLevels: json['playerLevels'] as String? ?? '',
      email: json['email'] as String? ?? '',
      contactNumber: json['contactNumber'] as String? ?? '',
      logoPhotoUrl: json['logoPhotoUrl'] as String? ?? '',
      agreedToRules: json['agreedToRules'] as bool? ?? false,
      confirmedAvailability: json['confirmedAvailability'] as bool? ?? false,
      applicationStatus: json['applicationStatus'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      league: json['league'] != null ? LeagueModel.fromJson(json['league'] as Map<String, dynamic>) : null,
    );
  }
}

class LeagueModel {
  final String id;
  final String leagueName;
  final String leagueLogo;
  final String location;

  LeagueModel({required this.id, required this.leagueName, required this.leagueLogo, required this.location});

  factory LeagueModel.fromJson(Map<String, dynamic> json) {
    return LeagueModel(
      id: json['_id'] as String,
      leagueName: json['leagueName'] as String? ?? '',
      leagueLogo: json['leagueLogo'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }
}

class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? role;
  final String? phoneNumber;
  final String? playingLevel;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.profileImage,
    this.role,
    this.phoneNumber,
    this.playingLevel,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      role: json['role'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      playingLevel: json['playingLevel']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'] as String) : null,
    );
  }
}
