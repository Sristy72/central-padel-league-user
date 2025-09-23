import 'package:get/get.dart';
import 'package:karlfive/features/payment/presentation/controller/payement_controller_stripe.dart';
import 'package:karlfive/features/payment/domain/payment_repo_stripe.dart';

import 'package:karlfive/features/EntireScreen/controller/user_info_controller.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';

import '../../features/join_league/presentation/controller/join_league_controller/join_league_controller.dart';

void setupController() {
  // Auth Controller
  Get.lazyPut<AuthController>(() => AuthController(Get.find(), Get.find()));
  Get.lazyPut<UserInfoController>(() => UserInfoController(Get.find()));
  Get.lazyPut<JoinLeagueController>(() => JoinLeagueController(Get.find()));

  // Ensure repository is registered first (setup_repository must run before this)
  Get.lazyPut<PaymentController>(() => PaymentController(Get.find()));
}
