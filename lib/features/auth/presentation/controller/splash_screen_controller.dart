import 'package:get/get.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../screens/login_screen.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {
  final _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () async {
      final success = await _authController.refreshToken();

      if (success) {
        Get.offAll(() => HomeScreen()); // clears stack
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }
}
