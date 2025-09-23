import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:karlfive/core/utils/debug_print.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/network/network_result.dart';
import '../../data/model/create_pay_response_stripe.dart';
import '../../domain/payment_repo_stripe.dart';

class PaymentController extends BaseController {
  final PaymentRepository _paymentRepository;

  PaymentController(this._paymentRepository);

  final RxString paymentIntentId = ''.obs;
  final RxString errorMessage = ''.obs;


  Future<bool> processStripePayment({
    required double amount,
    required String currency,
    required String externalTransactionId,
    String? clientSecret, 
  }) async {
    setLoading(true);
    errorMessage.value = '';
    try {
      final secret = (clientSecret == null || clientSecret.isEmpty)
          ? externalTransactionId
          : clientSecret;

      DPrint.info(
        'processStripePayment tx=$externalTransactionId amount=$amount using secret=$secret',
      );

      paymentIntentId.value = externalTransactionId;

      // Initialize PaymentSheet with provided/fallback secret
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: secret,
          merchantDisplayName: 'KarlFive',
          style: ThemeMode.dark,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return true;
    } on StripeException catch (e) {
      DPrint.error('Stripe Exception: ${e.error.localizedMessage}');
      errorMessage.value = e.error.localizedMessage ?? 'Payment failed';
      return false;
    } catch (e, st) {
      DPrint.error('Stripe error: $e\n$st');
      errorMessage.value = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  NetworkResult<PaymentResponse> createPaymentIntent({
    required String userId,
    required String ticketId,
    required String reserveBusId,
    required double amount,
  }) async {
    setLoading(true);
    try {
      final result = await _paymentRepository.createPaymentIntent(
        userId: userId,
        ticketId: ticketId,
        reserveBusId: reserveBusId,
        amount: amount,
      );

      if (result.isLeft()) {
        setError("An error occurred while creating payment intent");
      }

      DPrint.info("Create Payment Intent result: ${result}");
      return result;
    } finally {
      setLoading(false);
    }
  }

  NetworkResult<PaymentIntent> processPayment({
    required String clientSecret,
  }) async {
    setLoading(true);
    try {
      final result = await _paymentRepository.processPayment(
        clientSecret: clientSecret,
      );

      DPrint.info("Process Payment result: $result");
      return result;
    } finally {
      setLoading(false);
    }
  }

  NetworkResult<bool> confirmPayment(String paymentIntentId) async {
    setLoading(true);
    try {
      final result = await _paymentRepository.confirmPayment(paymentIntentId);

      DPrint.info("Confirm Payment result: $result");
      return result;
    } finally {
      setLoading(false);
    }
  }
}
