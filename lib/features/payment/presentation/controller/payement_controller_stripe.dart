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
      // Require a valid-looking client_secret
      final secretCandidate = (clientSecret == null || clientSecret.isEmpty)
          ? externalTransactionId
          : clientSecret;

      if (!secretCandidate.contains('_secret_') &&
          !secretCandidate.startsWith('pi_')) {
        errorMessage.value = 'Invalid payment client secret';
        DPrint.error('Invalid client_secret provided: $secretCandidate');
        return false;
      }

      final secret = secretCandidate;

      // initialize & present Stripe PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: secret,
          merchantDisplayName: 'KarlFive',
          style: ThemeMode.dark,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      final paymentIntentIdForServer = secret.contains('_secret_')
          ? secret.split('_secret_')[0]
          : secret;

      // Call server confirm endpoint
      final confirmResult = await _paymentRepository.confirmPayment(
        paymentIntentIdForServer,
      );
      confirmResult.fold(
        (fail) {
          // log failure details but do not block navigation
          DPrint.error('Server confirm failed: ${fail.message}');
          DPrint.error('Server confirm failure object: $fail');
        },
        (succ) {
          // log success payload
          DPrint.info('Server confirm response: ${succ.data}');
        },
      );

      // Proceed regardless of server confirm result
      paymentIntentId.value = paymentIntentIdForServer;
      DPrint.info(
        'Proceeding to Confirm screen for: $paymentIntentIdForServer',
      );
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
}
