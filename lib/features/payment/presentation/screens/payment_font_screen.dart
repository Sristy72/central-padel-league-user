import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/payment/presentation/screens/payment_screen.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  String selectedMethod = "PayPal";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white, // White background like Figma
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Payment Method",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Title should be black
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // PayPal Option
            GestureDetector(
              onTap: () {
                setState(() => selectedMethod = "PayPal");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedMethod == "PayPal"
                        ? Colors.blue
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Instead of text, use your PayPal full image (logo + text)
                    Image.asset(AppImages.paypalImage, height: 30),
                    const Spacer(),
                    Radio<String>(
                      value: "PayPal",
                      groupValue: selectedMethod,
                      onChanged: (value) {
                        setState(() => selectedMethod = value!);
                      },
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Pay Now Button
            Center(
              child: SizedBox(
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
                  onPressed: () {
                    Get.back();
                    Get.to(() => PaymentScreen());
                  },
                  child: const Text(
                    "Pay Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // button text white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:karlfive/core/common/constants/app_images.dart';
// import 'package:karlfive/core/theme/app_colors.dart';
// import 'package:karlfive/features/payment/presentation/screens/payment_screen.dart';
// import 'package:karlfive/features/payment/presentation/controller/payement_controller.dart';

// class PaymentDialog extends StatefulWidget {
//   const PaymentDialog({super.key});

//   @override
//   State<PaymentDialog> createState() => _PaymentDialogState();
// }

// class _PaymentDialogState extends State<PaymentDialog> {
//   String selectedMethod = "PayPal";
//   final PaymentController controller = Get.put(PaymentController());

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title + Close Button
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Select Payment Method",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close, size: 20, color: Colors.black),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // PayPal Option
//             GestureDetector(
//               onTap: () {
//                 setState(() => selectedMethod = "PayPal");
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: selectedMethod == "PayPal"
//                         ? Colors.blue
//                         : Colors.grey.shade300,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     Image.asset(
//                       AppImages.paypalImage,
//                       height: 30,
//                     ), // Assuming you have a PayPal logo image
//                     const Spacer(),
//                     Radio<String>(
//                       value: "PayPal",
//                       groupValue: selectedMethod,
//                       onChanged: (value) {
//                         setState(() => selectedMethod = value!);
//                       },
//                       activeColor: Colors.blue,
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Pay Now Button
//             Center(
//               child: SizedBox(
//                 width: 129,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.paypalColor,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   onPressed: () {
//                     Get.back(); // Close the dialog
//                     controller.makeTestPayment(
//                       amount: "35900",
//                       currency: "USD",
//                     );
//                   },
//                   child: const Text(
//                     "Pay Now",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
