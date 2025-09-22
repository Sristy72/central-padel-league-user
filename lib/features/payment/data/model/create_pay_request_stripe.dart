// lib/payment/data/models/payment_request.dart
class PaymentRequest {
  final int amount; // in cents
  final String currency;
  final String transactionId;

  PaymentRequest({
    required this.amount,
    required this.currency,
    required this.transactionId,
  });

  /// Convert to form fields expected by Stripe (x-www-form-urlencoded)
  Map<String, String> toFormFields() {
    return {
      'amount': amount.toString(),
      'currency': currency,
      'payment_method_types[]': 'card',
      // put transaction id into metadata so Stripe keeps it with the Intent
      'metadata[transaction_id]': transactionId,
    };
  }
}
