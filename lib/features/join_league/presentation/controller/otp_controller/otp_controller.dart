// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:karlfive/features/join_league/presentation/widgets/select_payment_dialog.dart';
// import 'package:karlfive/features/league/presentation/screens/leagues_screen.dart';
// import '../../../data/repositories/otp_repo/otp.dart';

// class OtpController extends GetxController {
//   final OtpRepository _repository = OtpRepository();

//   var isLoading = false.obs;
//   var otpCode = "".obs;

//   Future<void> verifyOtp() async {
//     try {
//       isLoading.value = true;

//       // Simulate API call delay
//       await Future.delayed(Duration(milliseconds: 1000));

//       // Show payment dialog on successful verification
//       _showPaymentDialog();

//       // For actual API integration later, uncomment this:
//       final response = await _repository.verifyOtp(otpCode.value);

//       if (response.success) {
//         Get.snackbar("Success", response.message);
//         _showPaymentDialog();

//         // Get.snackbar("Success", response.message);

//         // ✅ Navigate to next screen
//         Get.to(LeaguesScreen());
//       }
//     } catch (e) {
//       // Get.snackbar("Error", e.toString());
//       Get.to(LeaguesScreen());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Method to show payment dialog
//   void _showPaymentDialog() {
//     showDialog(
//       context: Get.context!,
//       builder: (context) => SelectPaymentDialog(),
//       barrierDismissible: false,
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// // import 'package:get/get.dart';
// // import 'package:karlfive/features/join_league/presentation/widgets/select_payment_dialog.dart';
// // import 'package:karlfive/features/league/presentation/screens/leagues_screen.dart';
// // import '../../../data/repositories/otp_repo/otp.dart';

// // class OtpController extends GetxController {
// //   final OtpRepository _repository = OtpRepository();

// //   var isLoading = false.obs;
// //   var otpCode = "".obs;

// //   Future<void> verifyOtp() async {
// //     try {
// //       isLoading.value = true;

// //       // Simulate API call delay
// //       await Future.delayed(Duration(milliseconds: 1000));

// //       // Show payment dialog on successful verification
// //       _showPaymentDialog();

// //       // For actual API integration later, uncomment this:
// //       final response = await _repository.verifyOtp(otpCode.value);

// //       if (response.success) {
// //         Get.snackbar("Success", response.message);
// //         _showPaymentDialog();

// //         // Get.snackbar("Success", response.message);

// //         // ✅ Navigate to next screen
// //         Get.to(LeaguesScreen());
// //       }
// //     } catch (e) {
// //       // Get.snackbar("Error", e.toString());
// //       Get.to(LeaguesScreen());
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }

// //   // Method to show payment dialog
// //   void _showPaymentDialog() {
// //     showDialog(
// //       context: Get.context!,
// //       builder: (context) => SelectPaymentDialog(),
// //       barrierDismissible: false,
// //     );
// //   }
// // }
