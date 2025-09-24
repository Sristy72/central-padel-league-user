import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../core/network/network_result.dart';
import '../data/model/create_pay_response_stripe.dart';

abstract class PaymentRepository {
  NetworkResult<PaymentResponse> createPaymentIntent({
    required String userId,
    String? ticketId,
    String? reserveBusId,
    required double amount,
  });

  // Confirm payment on server using paymentIntent id
  NetworkResult<bool> confirmPayment(String paymentIntentId);

  NetworkResult<PaymentIntent> processPayment({required String clientSecret});
}
