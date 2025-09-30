import 'package:get/get.dart';
import 'package:karlfive/features/home/controller/home_controller.dart';
import 'package:karlfive/features/league/presentation/controllers/league_controller.dart';
import 'package:karlfive/features/payment/presentation/controller/payement_controller_stripe.dart';
import 'package:karlfive/features/payment/domain/payment_repo_stripe.dart';

import 'package:karlfive/features/EntireScreen/controller/user_info_controller.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/team_members_profile/presentation/controllers/report_controller.dart';

import '../../features/join_league/presentation/controller/join_league_controller/join_league_controller.dart';
import '../../features/team_members_profile/presentation/controllers/contact_us_controller.dart';

void setupController() {
  // Auth Controller
  Get.lazyPut<AuthController>(
    fenix: true,
    () => AuthController(Get.find(), Get.find()),
  );
  Get.lazyPut<UserInfoController>(
    fenix: true,
    () => UserInfoController(Get.find()),
  );
  Get.lazyPut<JoinLeagueController>(
    fenix: true,
    () => JoinLeagueController(Get.find()),
  );
  Get.lazyPut<ContactUsController>(
    fenix: true,
    () => ContactUsController(Get.find()),
  );
  Get.lazyPut<ReportController>(
    fenix: true,
    () => ReportController(Get.find()),
  );

  // Ensure repository is registered first (setup_repository must run before this)
  Get.lazyPut<PaymentController>(
    fenix: true,
    () => PaymentController(Get.find()),
  );
  Get.lazyPut<HomeController>(fenix: true, () => HomeController());
  Get.lazyPut<LeagueController>(
    fenix: true,
    () => LeagueController(repository: Get.find()),
  );
}
