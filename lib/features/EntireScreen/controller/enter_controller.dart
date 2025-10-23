import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/features/EntireScreen/screens/playing_level_screen.dart';

class EnterController extends BaseController {
  /// Example action when user presses "Continue"
  Future<void> onContinue() async {
    Get.to(PlayingLevelScreen());
    setLoading(true);
  }
}
