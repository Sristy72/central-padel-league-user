class OtpResponse {
  final bool success;
  final String message;
  final String? token;

  OtpResponse({
    required this.success,
    required this.message,
    this.token,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }
}
