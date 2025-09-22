// lib/features/payment/controller/payement_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:karlfive/features/payment/data/data_source/stripe_service.dart';
import 'package:karlfive/features/payment/data/model/create_pay_request.dart';
import 'package:karlfive/features/payment/data/model/create_pay_response.dart';

class PaymentController extends GetxController {
  final RxBool isProcessing = false.obs;
  final RxString paymentIntentId = ''.obs;
  final RxString errorMessage = ''.obs;

  /// Creates a PaymentIntent on Stripe, initializes and presents the Payment Sheet.
  /// Verifies status from Stripe and returns true only if final status is "succeeded".
  Future<bool> processStripePayment({
    required double amount,
    required String currency,
  }) async {
    bool success = false;
    isProcessing.value = true;
    errorMessage.value = '';
    paymentIntentId.value = '';

    final int amountInCents = (amount * 100).round();
    final String transactionId = DateTime.now().millisecondsSinceEpoch
        .toString();

    final req = PaymentRequest(
      amount: amountInCents,
      currency: currency,
      transactionId: transactionId,
    );

    try {
      // call service with the PaymentRequest model
      final Map<String, dynamic> intentJson = await StripeService.instance
          .createPaymentIntent(req);

      final PaymentResponse resp = PaymentResponse.fromJson(intentJson);
      final String clientSecret = resp.clientSecret;
      final String intentId = resp.id;

      if (kDebugMode) {
        debugPrint(
          'Stripe Intent created: id=$intentId clientSecret=${clientSecret.isNotEmpty}',
        );
      }

      if (clientSecret.isEmpty) {
        throw Exception('Missing client_secret from Stripe response');
      }

      paymentIntentId.value = intentId;

      // init and present sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'KarlFive',
          style: ThemeMode.dark,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // After successful presentation, verify PaymentIntent status from Stripe
      try {
        if (intentId.isEmpty) {
          throw Exception('No payment intent id to verify');
        }
        final Map<String, dynamic> fetched = await StripeService.instance
            .fetchPaymentIntent(intentId);
        final String status = (fetched['status'] ?? '').toString();
        if (kDebugMode) debugPrint('Verified PaymentIntent status: $status');
        if (status == 'succeeded') {
          success = true;
        } else {
          success = false;
          errorMessage.value = 'Payment not completed. Status: $status';
        }
      } catch (verifyErr) {
        // If verification request fails, treat as failure and report message
        if (kDebugMode)
          debugPrint('Failed to verify PaymentIntent: $verifyErr');
        success = false;
        errorMessage.value = 'Payment verification failed: $verifyErr';
      }
    } on StripeException catch (se) {
      if (kDebugMode)
        debugPrint('StripeException: ${se.error.localizedMessage}');
      errorMessage.value = se.error.localizedMessage ?? 'Stripe error';
      success = false;
    } catch (e) {
      if (kDebugMode) debugPrint('Payment error: $e');
      errorMessage.value = e.toString();
      success = false;
    } finally {
      isProcessing.value = false;
    }

    return success;
  }
}
