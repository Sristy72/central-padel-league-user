

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:karlfive/features/payment/presentation/screens/payment_font_screen.dart';
// import '../../../../core/theme/app_buttoms.dart';
// import '../../../../core/theme/app_colors.dart';


// class SelectPaymentDialog extends StatelessWidget {
//   const SelectPaymentDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> paymentMethods = [
//       {'name': 'PayPal', 'icon': Icons.payment, 'selected': true},
//     ];

//     return Dialog(
//       backgroundColor: AppColors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: 500,
//           minWidth: 300,
//           maxHeight: MediaQuery.of(context).size.height * 0.8,
//         ),
//         padding: const EdgeInsets.all(24),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 "Select Payment Method",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),

//               const SizedBox(height: 20),

//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: paymentMethods.map((method) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: method['selected']
//                             ? Colors.grey[50]
//                             : Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: method['selected'] ? Colors.blue : Colors.grey,
//                           width: method['selected'] ? 2 : 1,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             method['icon'],
//                             color: method['selected']
//                                 ? Colors.blue
//                                 : Colors.grey[600],
//                             size: 24,
//                           ),
//                           const SizedBox(width: 12),
//                           Text(
//                             method['name'],
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: method['selected']
//                                   ? Colors.black87
//                                   : Colors.grey[700],
//                             ),
//                           ),
//                           const Spacer(),
//                           if (method['selected'])
//                             Container(
//                               width: 20,
//                               height: 20,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.blue,
//                               ),
//                               child: const Icon(
//                                 Icons.check,
//                                 size: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),

//               const SizedBox(height: 24),

//               SizedBox(
//                 width: double.infinity,
//                 child: PrimaryButton(
//                   onPressed: () {
//                     // Close this selection dialog then open the server payment dialog
//                     Navigator.of(context).pop();
//                     // Show PaymentDialog which calls createPayment -> then navigates to PaymentScreen
//                     showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (_) => const PaymentDialog(userID: '', leagueID: '', teamID: '',),
//                     );
//                   },
//                   text: "Pay Now",
//                   backgroundColor: Colors.blue,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
