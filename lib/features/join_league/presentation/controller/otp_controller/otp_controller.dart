import 'package:get/get.dart';
import '../../../data/repositories/otp_repo/otp.dart';
class OtpController extends GetxController {
  final OtpRepository _repository = OtpRepository();

  var isLoading = false.obs;
  var otpCode = "".obs;

  Future<void> verifyOtp() async {
    try {
      isLoading.value = true;

      final response = await _repository.verifyOtp(otpCode.value);

      if (response.success) {
        Get.snackbar("Success", response.message);
        // ✅ Navigate to next screen
        // Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.snackbar("Error", response.message);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
