import 'package:get/get.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';

class SplashController extends GetxController {
  final _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _checkStartupFlow();
  }

  Future<void> _checkStartupFlow() async {
    await Future.delayed(const Duration(seconds: 2));

    final success = await _authController.checkAuthStatus();
    
    if (success) {
       Get.offAll(() => HomeScreen());
    } else {
       Get.offAll(() => LoginScreen());
    }
  }
}
