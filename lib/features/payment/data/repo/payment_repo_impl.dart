import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/network_result.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';
import '../../domain/payment_repo_stripe.dart';
import '../model/create_pay_response_stripe.dart';

class PaymentRepositoryStripeImpl implements PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepositoryStripeImpl(this._apiClient);

  @override
  NetworkResult<PaymentResponse> createPaymentIntent({
    required String userId,
    String? ticketId,
    String? reserveBusId,
    required double amount,
  }) {
    final data = {
      'userId': userId,
      'ticketId': ticketId,
      'reserveBusId': reserveBusId,
      'amount': amount,
    };

    return _apiClient.post<PaymentResponse>(
      ApiConstants.payment.createPayment,
      data: data,
      fromJsonT: (json) =>
          PaymentResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<bool> confirmPayment(String paymentIntentId) {
    return _apiClient.post<bool>(
      ApiConstants.payment.confirmPayment,
      data: {'paymentIntentId': paymentIntentId},
      fromJsonT: (json) {
        try {
          // Common server patterns
          if (json is bool) return json;
          if (json is Map<String, dynamic>) {
            if (json.containsKey('success')) return json['success'] == true;
            if (json.containsKey('data') &&
                json['data'] is Map &&
                (json['data'] as Map).containsKey('transactionId')) {
              return true;
            }
            if (json.containsKey('message')) {
              // Some backends return { message: "...", success: true/false }
              if ((json['success'] ?? false) == true) return true;
            }
          }
        } catch (_) {}
        // fallback
        return json == true;
      },
    );
  }

  @override
  NetworkResult<PaymentIntent> processPayment({
    required String clientSecret,
  }) async {
    return _apiClient.post<PaymentIntent>(
      '${ApiConstants.payment.createPayment}/process',
      data: {'clientSecret': clientSecret},
      fromJsonT: (json) =>
          throw UnsupportedError('processPayment: implement mapping'),
    );
  }
}
