import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/core/utils/debug_print.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';

class EnterController extends BaseController {
  /// Example action when user presses "Continue"
  Future<void> onContinue() async {
    Get.to(LoginScreen());
    setLoading(true);

    // try {
    //   // simulate network call
    //   await Future.delayed(const Duration(seconds: 3));

    //   DPrint.log("User pressed Continue on Enter Screen");

    //   // You could do navigation here with GetX
    //   // Get.offAllNamed('/home');
    // } catch (e) {
    //   setError("Something went wrong");
    //   DPrint.error(e);
    // } finally {
    //   setLoading(false);
    // }
  }
}
