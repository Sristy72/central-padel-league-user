import 'package:get/get.dart';

class CreateLeagueController extends GetxController {
  var isLoading = false.obs;

  Future<bool> createLeagueDummy() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    return true;
  }
}
