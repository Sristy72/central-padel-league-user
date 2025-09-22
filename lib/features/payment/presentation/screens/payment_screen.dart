import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/home/presentation/screens/home_screen.dart';
import 'package:karlfive/features/payment/presentation/screens/confirm_payment_screen.dart';
import '../controller/payement_controller_stripe.dart';

class PaymentScreen extends StatefulWidget {
  final String? transactionId;
  final double amount;

  const PaymentScreen({super.key, this.transactionId, this.amount = 359.00});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final PaymentController paymentController;

  @override
  void initState() {
    super.initState();
    paymentController = Get.put(PaymentController());
    // Start stripe flow after first frame so UI exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.transactionId != null && widget.transactionId!.isNotEmpty) {
        _startStripeFlow();
      } else {
        debugPrint('No transactionId provided to PaymentScreen');
      }
    });
  }

  Future<void> _startStripeFlow() async {
    final tx = widget.transactionId!;
    debugPrint(
      'PaymentScreen: starting Stripe with transactionId: $tx, amount: ${widget.amount}',
    );

    final success = await paymentController.processStripePayment(
      amount: widget.amount,
      currency: 'usd',
      externalTransactionId: tx,
    );

    debugPrint(
      'PaymentScreen: stripe success=$success intentId=${paymentController.paymentIntentId.value} error=${paymentController.errorMessage.value}',
    );

    if (success) {
      Get.snackbar(
        'Payment Completed',
        'Payment succeeded! Transaction ID: ${paymentController.paymentIntentId.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Optionally navigate to home after successful payment
      Future.delayed(Duration(seconds: 2), () {
        Get.offAll(() => ConfirmPaymentScreen());
      });
    } else {
      Get.snackbar(
        'Payment Error',
        paymentController.errorMessage.value.isNotEmpty
            ? paymentController.errorMessage.value
            : 'Payment failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Compare plans and choose the one that best \nfits your hiring or job-seeking needs.",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            const SizedBox(height: 28),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Recurring Payment Terms:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 7.5),
                    Text(
                      "  •  Charges includes Applicable VAT/GST and/or Sale Taxes ",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffACACAC),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Divider(color: Color(0xff282828)),
                    InkWell(
                      onTap: () {
                        Get.offAll(() => HomeScreen());
                      },
                      child: Row(
                        children: [
                          Text(
                            "Total:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "\$${widget.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Color(0xff282828)),
                    const SizedBox(height: 30),
                    Text(
                      "Safe & secure payment :",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "By clicking the Pay button, you are agreeing to our Terms of Service and Privacy Statement. You are also authorizing us to charge your credit/debit card at the price above now and before each new subscription term. For any questions please contact support@tipnenka.com",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffACACAC),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Loading indicator
                    if (paymentController.isProcessing.value)
                      const Center(child: CircularProgressIndicator()),

                    const Spacer(),

                    // Manual retry button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: paymentController.isProcessing.value
                            ? null
                            : () {
                                if (widget.transactionId != null &&
                                    widget.transactionId!.isNotEmpty) {
                                  _startStripeFlow();
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'Missing transaction ID',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                        child: paymentController.isProcessing.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Pay Now",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}
