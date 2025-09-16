import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/otp_model/otp_model.dart';

class OtpRepository {
  final String baseUrl = "https://yourapi.com"; // change this

  Future<OtpResponse> verifyOtp(String otp) async {
    final url = Uri.parse("$baseUrl/verify-otp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"otp": otp}),
    );

    if (response.statusCode == 200) {
      return OtpResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to verify OTP");
    }
  }
}
