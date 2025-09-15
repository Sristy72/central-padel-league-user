import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstTime', false);
      Get.to(LoginScreen());
      // if (token != null) {
      //   //Get.offAll(() => HomeScreen());
      // } else {
      //   Get.offAll(() => LoginScreen());
      // }
    });
  }
}