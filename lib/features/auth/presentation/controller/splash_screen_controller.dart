import 'package:get/get.dart';
import 'package:karlfive/core/network/services/auth_storage_service.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/pre_home/screens/pre_home_screen.dart';

import '../../../home/presentation/screens/home_screen.dart';

class SplashController extends GetxController {
  final _authController = Get.find<AuthController>();
  final _authStorageService = Get.find<AuthStorageService>();

  @override
  void onInit() {
    super.onInit();
    _checkStartupFlow();
  }

  Future<void> _checkStartupFlow() async {
    await Future.delayed(const Duration(seconds: 2));

    // Check if tokens exist and are valid
    final accessToken = await _authStorageService.getAccessToken();
    final refreshToken = await _authStorageService.getRefreshToken();
    
    if (accessToken != null && accessToken.isNotEmpty && 
        refreshToken != null && refreshToken.isNotEmpty) {
      // Tokens exist, verify they're still valid
      final isValid = await _authController.checkAuthStatus();
      
      if (isValid) {
        // Valid tokens - go to home screen
        Get.offAll(() => HomeScreen());
      } else {
        // Tokens expired - clear and go to guest home
        await _authStorageService.clearAuthData();
        Get.offAll(() => PreHomeScreen());
      }
    } else {
      // No tokens - go to guest home screen
      Get.offAll(() => PreHomeScreen());
    }
  }
}
