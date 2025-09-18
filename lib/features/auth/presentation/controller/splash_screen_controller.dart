import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';

import '../screens/home_screen.dart';


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
