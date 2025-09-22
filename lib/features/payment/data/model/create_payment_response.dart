class CreatePaymentApiResponse {
  final String transactionId;

  CreatePaymentApiResponse({required this.transactionId});

  factory CreatePaymentApiResponse.fromJson(Map<String, dynamic> json) {
    return CreatePaymentApiResponse(
      transactionId: json['transactionId'] as String? ?? '',
    );
  }
}
