class CreatePaymentApiResponse {
  final String transactionId;
  final String? clientSecret; // added optional client secret

  CreatePaymentApiResponse({required this.transactionId, this.clientSecret});

  factory CreatePaymentApiResponse.fromJson(Map<String, dynamic> json) {
    return CreatePaymentApiResponse(
      transactionId:
          (json['transactionId'] as String?) ??
          (json['transaction_id'] as String?) ??
          (json['id'] as String?) ??
          '',
      clientSecret:
          (json['clientSecret'] as String?) ??
          (json['client_secret'] as String?) ??
          (json['client_secret_value'] as String?),
    );
  }
}
