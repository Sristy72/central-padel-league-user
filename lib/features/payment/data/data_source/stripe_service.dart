// lib/payment/data/stripe_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:karlfive/core/common/constants/stripe_key.dart';
import '../model/create_pay_request.dart';

class StripeService {
  StripeService._();
  static final instance = StripeService._();

  /// Create a PaymentIntent on Stripe using secret key.
  /// Returns decoded json as Map.
  Future<Map<String, dynamic>> createPaymentIntent(PaymentRequest req) async {
    try {
      final body = req.toFormFields();
      final resp = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${StripeKey.privateKey}', 
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
        return decoded;
      } else {
        if (kDebugMode) {
          print(
            'Stripe create intent failed: ${resp.statusCode} -> ${resp.body}',
          );
        }
        throw Exception('Stripe API returned ${resp.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('StripeService.createPaymentIntent error: $e');
      rethrow;
    }
  }
}
