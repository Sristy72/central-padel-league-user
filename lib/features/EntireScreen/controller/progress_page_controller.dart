import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';

class ProgressPageController extends BaseController {
  var currentPage = 0.0.obs;

  void updateProgress(double progress) {
    currentPage.value = progress;
  }
}
