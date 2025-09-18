import 'package:get/get.dart';
import 'package:karlfive/features/league/presentation/screens/leagues_screen.dart';
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
        // Get.snackbar("Success", response.message);

        // ✅ Navigate to next screen
        Get.to(LeaguesScreen());
      } else {
        // Get.snackbar("Error", response.message);
        Get.to(LeaguesScreen());
      }
    } catch (e) {
      // Get.snackbar("Error", e.toString());
      Get.to(LeaguesScreen());
    } finally {
      isLoading.value = false;
    }
  }
}
