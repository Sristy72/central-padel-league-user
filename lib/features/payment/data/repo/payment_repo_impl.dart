import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/network_result.dart';
import '../../../../core/network/constants/api_constants.dart';
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
      '${ApiConstants.payment.createPayment}/confirm', 
      data: {'paymentIntentId': paymentIntentId},
      fromJsonT: (json) => json == true ? true : (json as bool),
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
