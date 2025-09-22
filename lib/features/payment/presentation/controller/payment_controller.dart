import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../data/model/create_payment_requesr.dart';
import '../../domain/payment_repo.dart';

class PaymentApiController extends GetxController {
  final PaymentApiRepository _repo = Get.find();

  /// Calls backend /payment/create-payment and returns transactionId on success.
  Future<String?> createPayment(CreatePaymentRequest req) async {
    final res = await _repo.createPayment(req);
    String? transactionId;
    final id = res.fold(
      (fail) {
        if (kDebugMode) debugPrint('CreatePayment failed: ${fail.message}');
      },
      (success) {
        // success.data is CreatePaymentApiResponse

        return success.data.transactionId;
      },
    );
    transactionId = id;

    return transactionId;
  }
}
