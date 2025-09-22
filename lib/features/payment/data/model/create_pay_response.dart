// lib/payment/data/models/payment_response.dart
class PaymentResponse {
  final String id; // PaymentIntent id
  final String clientSecret;
  final Map<String, dynamic> raw;

  PaymentResponse({
    required this.id,
    required this.clientSecret,
    required this.raw,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      id: json['id'] as String,
      clientSecret: json['client_secret'] as String? ?? '',
      raw: json,
    );
  }
}
