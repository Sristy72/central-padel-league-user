// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:get/get.dart';

// class PaymentController extends GetxController {
//   var isLoading = false.obs;

//   Future<void> makeTestPayment({
//     required String amount,
//     required String Currency,
//   }) async {
//     try {
//       isLoading.value = true;

//       // ⚠️ Replace with your PaymentIntent client_secret from Stripe Dashboard
//       const clientSecret =
//           "Bearer sk_test_51S8xuVJIhH0D9e0PFnJCn8SVf4rnEIdRTLqLQi8RKpiUlCpDcI6CXAOptwebUGUEHGuA9X1cEFanevcPTeEjEyVe00z9Bhhg6d";

//       // 1️⃣ Initialize Payment Sheet
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: clientSecret,
//           merchantDisplayName: "KarlFive",
//           style: ThemeMode.dark,
//         ),
//       );

//       // 2️⃣ Present Payment Sheet
//       await Stripe.instance.presentPaymentSheet();

//       Get.snackbar(
//         "Success",
//         "Payment completed ✅",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;

  Future<void> makeTestPayment({
    required String amount,
    required String currency,
  }) async {
    try {
      isLoading.value = true;

      // In production, replace with actual server-side integration to fetch paymentIntent client secret
      const clientSecret =
          "pk_test_51RXwQACcgOOj8cVfdYyp6jF1oOS1Qg6PHycZbBrPSQ0wuXrCKyEjAA8XSmIl802REjz3qZj5VpWF0XXwVxC7buU5007AlTzQJ1"; // Mocked for testing

      // Initialize Stripe Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "KarlFive",
          style: ThemeMode.dark,
        ),
      );

      // Show the payment sheet
      await Stripe.instance.presentPaymentSheet();

      // On success
      Get.snackbar(
        "Payment Success",
        "Payment completed ✅",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // On failure
      Get.snackbar(
        "Payment Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
