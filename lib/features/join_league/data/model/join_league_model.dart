class JoinLeagueRequest {
  final String teamName;
  final String captainName;
  final String partnerName;
  final PlayerLevel playerLevel;
  final String email;
  final String contactNumber;
  final String? logoUrl;
  final String league;
  final bool agreeToRules;
  final bool confirmAvailability;

  JoinLeagueRequest({
    required this.teamName,
    required this.captainName,
    required this.partnerName,
    required this.playerLevel,
    required this.email,
    required this.contactNumber,
    this.logoUrl,
    required this.league,
    required this.agreeToRules,
    required this.confirmAvailability,
  });

  Map<String, dynamic> toJson() => {
    'team_name': teamName,
    'captain_name': captainName,
    'partner_name': partnerName,
    'player_level': playerLevel.value,
    'email': email,
    'contact_number': contactNumber,
    'logo_url': logoUrl,
    'league': league,
    'agree_to_rules': agreeToRules,
    'confirm_availability': confirmAvailability,
  };
}

class JoinLeagueResponse {
  final bool success;
  final String message;
  final String? applicationId;

  JoinLeagueResponse({
    required this.success,
    required this.message,
    this.applicationId,
  });

  factory JoinLeagueResponse.fromJson(Map<String, dynamic> json) {
    return JoinLeagueResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      applicationId: json['application_id'],
    );
  }
}

enum PlayerLevel {
  beginner('Beginner'),
  intermediate('Intermediate'),
  intermediateHigh('Intermediate high'),
  advance('Advance'),
  pro('Pro');

  final String value;
  const PlayerLevel(this.value);

  static PlayerLevel fromString(String value) {
    return PlayerLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => PlayerLevel.beginner,
    );
  }
}
