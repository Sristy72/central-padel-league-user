// lib/payment/data/stripe_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:karlfive/core/common/constants/stripe_key.dart';
import 'package:karlfive/features/payment/data/model/create_pay_request.dart';

class StripeService {
  StripeService._internal() {
    // ensure SDK publishable key is set
    if ((Stripe.publishableKey ?? '').isEmpty) {
      Stripe.publishableKey = StripeKey.publishableKey;
    }
  }

  static final StripeService instance = StripeService._internal();

  Future<Map<String, dynamic>> createPaymentIntent(PaymentRequest req) async {
    final secret = StripeKey.privateKey.trim();
    if (secret.isEmpty) {
      throw Exception(
        'Stripe secret key is missing. Set it in stripe_key.dart',
      );
    }

    // Use the PaymentRequest model to build form fields
    final Map<String, String> body = req.toFormFields();

    if (kDebugMode) {
      debugPrint('Stripe createPaymentIntent body: $body');
    }

    final res = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer $secret',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (kDebugMode) {
      debugPrint('Stripe createPaymentIntent status: ${res.statusCode}');
      debugPrint('Stripe createPaymentIntent response: ${res.body}');
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(
        'Stripe createPaymentIntent failed: ${res.statusCode} - ${res.body}',
      );
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Fetch PaymentIntent by id using secret key (used for server-side verification).
  Future<Map<String, dynamic>> fetchPaymentIntent(
    String paymentIntentId,
  ) async {
    final secret = StripeKey.privateKey.trim();
    if (secret.isEmpty) {
      throw Exception(
        'Stripe secret key is missing. Set it in stripe_key.dart',
      );
    }

    if (paymentIntentId.isEmpty) {
      throw Exception('paymentIntentId is empty');
    }

    final uri = Uri.parse(
      'https://api.stripe.com/v1/payment_intents/$paymentIntentId',
    );

    if (kDebugMode) debugPrint('Fetching PaymentIntent: $paymentIntentId');

    final res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $secret',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (kDebugMode) {
      debugPrint('fetchPaymentIntent status: ${res.statusCode}');
      debugPrint('fetchPaymentIntent body: ${res.body}');
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(
        'fetchPaymentIntent failed: ${res.statusCode} - ${res.body}',
      );
    }

    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
