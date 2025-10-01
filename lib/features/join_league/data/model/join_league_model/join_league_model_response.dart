class JoinLeagueResponse {
  final bool success;
  final String message;

  JoinLeagueResponse({
    required this.success,
    required this.message,
  });

  factory JoinLeagueResponse.fromJson(Map<String, dynamic> json) {
    return JoinLeagueResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown error',
    );
  }
}
