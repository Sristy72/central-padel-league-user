import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';

class PlayingLevelController extends BaseController {
  var selectedLevel = ''.obs;

  final levels = ["Beginner", "Intermediate", "Advanced", "Professional"];
}
