class PaymentRequest {
  final int amount; // in cents
  final String currency;
  final String transactionId;

  PaymentRequest({
    required this.amount,
    required this.currency,
    required this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'transaction_id': transactionId,
    };
  }
}
