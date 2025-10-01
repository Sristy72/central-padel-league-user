class JoinLeagueRequest {
  final String teamName;
  final String captainName;
  final String partnerName;
  final String email;
  final String contactNumber;
  final String league;
  final int playerLevel;
  final String? logoPath;

  JoinLeagueRequest({
    required this.teamName,
    required this.captainName,
    required this.partnerName,
    required this.email,
    required this.contactNumber,
    required this.league,
    required this.playerLevel,
    this.logoPath,
  });

  Map<String, String> toFields() {
    return {
      'team_name': teamName,
      'captain_name': captainName,
      'partner_name': partnerName,
      'email': email,
      'contact_number': contactNumber,
      'league': league,
      'player_level': playerLevel.toString(),
    };
  }
}
