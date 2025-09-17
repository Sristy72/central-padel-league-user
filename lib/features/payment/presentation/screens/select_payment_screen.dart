import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import 'package:karlfive/core/theme/app_colors.dart';

class SelectPaymentScreen extends StatelessWidget {
  const SelectPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => _buildAlertPaymentDialog(context),
            );
          },
          child: const Text('Show Payment Dialog'),
        ),
      ),
    );
  }

  Widget _buildAlertPaymentDialog(BuildContext context) {
    // Example list of payment methods - you can make this dynamic
    final List<Map<String, dynamic>> paymentMethods = [
      {
        'name': 'PayPal',
        'icon': Icons.payment,
        'selected': true,
      },
      {
        'name': 'Credit Card',
        'icon': Icons.credit_card,
        'selected': false,
      },
      {
        'name': 'Google Pay',
        'icon': Icons.account_balance_wallet,
        'selected': false,
      },
      {
        'name': 'Apple Pay',
        'icon': Icons.phone_iphone,
        'selected': false,
      },
    ];

    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
          minWidth: 300,
          maxHeight: MediaQuery.of(context).size.height * 0.8, 
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView( 
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Payment Method",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // X button for close
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Payment methods list - height grows with number of items
              Column(
                mainAxisSize: MainAxisSize.min,
                children: paymentMethods.map((method) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: method['selected'] ? Colors.grey[50] : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: method['selected'] ? Colors.blue : Colors.grey,
                          width: method['selected'] ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            method['icon'],
                            color: method['selected'] ? Colors.blue : Colors.grey[600],
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            method['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: method['selected'] ? Colors.black87 : Colors.grey[700],
                            ),
                          ),
                          const Spacer(),
                          if (method['selected'])
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Pay Now Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: "Pay Now",
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}