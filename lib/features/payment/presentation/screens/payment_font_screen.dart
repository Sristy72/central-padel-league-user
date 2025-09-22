import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/core/theme/app_colors.dart';
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

    // Call repository directly to inspect failure/success
    final result = await _repo.createPayment(req);

    result.fold(
      (fail) {
        setState(() {
          _isProcessing = false;
        });

        // Print full failure to console for debugging
        if (kDebugMode) {
          debugPrint('CreatePayment failed: ${fail.message}');
          debugPrint('CreatePayment failure object: $fail');
        }

        // Show server message if available
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
        if (kDebugMode) {
          debugPrint('CreatePayment success raw: ${success.data}');
          debugPrint('CreatePayment message: ${success.message}');
          debugPrint('CreatePayment transactionId: $tx');
        }

        setState(() {
          _transactionId = tx;
          _isProcessing = false;
        });

        Get.snackbar(
          'Success',
          'Server payment created. transactionId: $tx',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );

        // Navigate to PaymentScreen with server transaction id
        Get.to(
          () => PaymentScreen(transactionId: tx, amount: req.amount.toDouble()),
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
            GestureDetector(
              onTap: () => setState(() => _selectedMethod = 'PayPal'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedMethod == "PayPal"
                        ? Colors.blue
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset(AppImages.paypalImage, height: 30),
                    const Spacer(),
                    Radio<String>(
                      value: "PayPal",
                      groupValue: _selectedMethod,
                      onChanged: (v) => setState(() => _selectedMethod = v!),
                      activeColor: Colors.blue,
                    ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.paypalColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: _onPayNow,
                  child: const Text(
                    "Pay Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
