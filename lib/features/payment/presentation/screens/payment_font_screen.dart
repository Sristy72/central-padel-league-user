import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/model/create_payment_requesr.dart';
import '../../domain/payment_repo.dart';
import 'payment_screen.dart';

class PaymentDialog extends StatefulWidget {
  final String userID;
  final String leagueID;
  final String teamID;
  final String amount;
  const PaymentDialog({
    super.key,
    required this.userID,
    required this.leagueID,
    required this.teamID,
    required this.amount,
  });

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
      userId: widget.userID,
      league: widget.leagueID,
      // amount:6;
      amount: double.tryParse(widget.amount) ?? 0.0,
      team: widget.teamID,
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
        final clientSecret =
            (success.data.clientSecret == null ||
                success.data.clientSecret!.isEmpty)
            ? tx
            : success.data.clientSecret;

        setState(() {
          _transactionId = tx;
          _isProcessing = false;
        });

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      width: 60,
                      height: 33,
                      errorBuilder: (_, __, ___) => const Icon(Icons.payment),
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
