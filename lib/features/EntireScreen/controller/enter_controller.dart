import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/core/utils/debug_print.dart';
import 'package:karlfive/features/EntireScreen/screens/playing_level_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';

class EnterController extends BaseController {
  /// Example action when user presses "Continue"
  Future<void> onContinue() async {
    Get.to(PlayingLevelScreen());
    setLoading(true);
  }
}
