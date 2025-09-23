import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'dart:convert';
import '../../data/model/create_pay_response_stripe.dart';
import '../../data/model/create_payment_requesr.dart';
import '../../domain/payment_repo.dart';
import '../controller/payment_controller.dart'; // PaymentApiController
import '../controller/payement_controller_stripe.dart'; // Stripe PaymentController
import 'payment_screen.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  bool _isProcessing = false;
  String _transactionId = '';
  String _selectedMethod = 'PayPal';

  late final PaymentApiRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = Get.find<PaymentApiRepository>();
  }

  Future<void> _onPayNow() async {
    setState(() {
      _isProcessing = true;
      _transactionId = '';
    });

    final req = CreatePaymentRequest(
      userId: '68a9310b60a8cc4db5a8b6cf',
      league: '68a93e86620256fd9d6fe200',
      amount: 25,
      team: '68cba254cf156326215b0d7a',
    );

    final result = await _repo.createPayment(req);

    result.fold(
      (fail) {
        setState(() {
          _isProcessing = false;
        });

        if (kDebugMode) {
          debugPrint('CreatePayment failed: ${fail.message}');
          debugPrint('CreatePayment failure object: $fail');
        }

        Get.snackbar(
          'Payment Error',
          fail.message.isNotEmpty
              ? fail.message
              : 'Failed to create payment on server',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      },
      (success) {
        final tx = success.data.transactionId;
        // createPayment response now includes clientSecret (nullable)
        // If backend didn't return a clientSecret, use transaction id as fallback
        final clientSecret =
            (success.data.clientSecret == null ||
                success.data.clientSecret!.isEmpty)
            ? tx
            : success.data.clientSecret;

        setState(() {
          _transactionId = tx;
          _isProcessing = false;
        });

        // Navigate to PaymentScreen with server transaction id and client secret
        Get.to(
          () => PaymentScreen(
            transactionId: tx,
            amount: req.amount.toDouble(),
            clientSecret: clientSecret,
          ),
          transition: Transition.rightToLeft,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title + Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Payment Method",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Simple method selector
            GestureDetector(
              onTap: () => setState(() => _selectedMethod = 'PayPal'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedMethod == 'PayPal'
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/paypal.png",
                      width: 32,
                      height: 20,
                      errorBuilder: (_, __, ___) => const Icon(Icons.payment),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'PayPal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedMethod == 'PayPal')
                      const Icon(Icons.check, color: Colors.blue),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (_isProcessing) const CircularProgressIndicator(),
            if (!_isProcessing)
              SizedBox(
                width: 129,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onPayNow,
                  child: const Text('Pay Now'),
                ),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
