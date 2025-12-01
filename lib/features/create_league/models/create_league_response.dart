class CreateLeagueResponse {
  final String id;
  final String leagueName;
  final String description;
  final String leagueCode;
  final String leagueType;
  final DateTime startDate;
  final DateTime? endDate;
  final String location;
  final int totalGameWeeks;
  final String type;
  final String matchFormat;
  final String tiebreakOption;
  final bool allowSubstitutes;

  CreateLeagueResponse({
    required this.id,
    required this.leagueName,
    required this.description,
    required this.leagueCode,
    required this.leagueType,
    required this.startDate,
    this.endDate,
    required this.location,
    required this.totalGameWeeks,
    required this.type,
    required this.matchFormat,
    required this.tiebreakOption,
    required this.allowSubstitutes,
  });

  factory CreateLeagueResponse.fromJson(Map<String, dynamic> json) {
    DateTime? tryParseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return null;
      }
    }

    return CreateLeagueResponse(
      id: json['_id'] ?? '',
      leagueName: json['leagueName'] ?? '',
      description: json['description'] ?? '',
      leagueCode: json['leagueCode'] ?? '',
      leagueType: json['leagueType'] ?? '',
      startDate: tryParseDate(json['startDate']) ?? DateTime.now(),
      endDate: tryParseDate(json['endDate']),
      location: json['location'] ?? '',
      totalGameWeeks: json['totalGameWeeks'] ?? 0,
      type: json['type'] ?? '',
      matchFormat: json['matchFormat'] ?? '',
      tiebreakOption: json['tiebreakOption'] ?? '',
      allowSubstitutes: json['allowSubstitutes'] ?? false,
    );
  }
}