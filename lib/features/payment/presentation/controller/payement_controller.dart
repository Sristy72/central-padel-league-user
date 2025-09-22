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
  Future<void> processStripePayment({
    required double amount, // dollars (e.g. 20.0)
    required String currency,
  }) async {
    isProcessing.value = true;
    errorMessage.value = '';
    paymentIntentId.value = '';

    // Convert to smallest currency unit (cents for USD)
    final int amountInCents = (amount * 100).round();

    final String transactionId = DateTime.now().millisecondsSinceEpoch
        .toString();

    final req = PaymentRequest(
      amount: amountInCents,
      currency: currency,
      transactionId: transactionId,
    );

    try {
      // Create PaymentIntent using the helper service
      final Map<String, dynamic> intentJson = await StripeService.instance
          .createPaymentIntent(req);

      // Convert to model (optional)
      final PaymentResponse resp = PaymentResponse.fromJson(intentJson);

      final String clientSecret = resp.clientSecret;
      final String intentId = resp.id;

      if (kDebugMode) {
        debugPrint(
          'Stripe Intent created: id=$intentId clientSecret=$clientSecret',
        );
      }

      if (clientSecret.isEmpty) {
        throw Exception('Missing client_secret from Stripe response');
      }

      paymentIntentId.value = intentId;

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'KarlFive',
          style: ThemeMode.dark,
          // You can add other optional parameters here (customerId, etc)
        ),
      );

      // Present the sheet
      await Stripe.instance.presentPaymentSheet();

      if (kDebugMode) debugPrint('Payment completed for Intent: $intentId');
    } on StripeException catch (se) {
      if (kDebugMode)
        debugPrint('StripeException: ${se.error.localizedMessage}');
      errorMessage.value = se.error.localizedMessage ?? 'Stripe error';
    } catch (e) {
      if (kDebugMode) debugPrint('Payment error: $e');
      errorMessage.value = e.toString();
    } finally {
      isProcessing.value = false;
    }
  }
}
