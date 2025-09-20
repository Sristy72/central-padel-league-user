import 'package:get/get.dart';
import 'package:karlfive/features/EntireScreen/controller/user_info_controller.dart';
import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
import 'package:karlfive/features/team_members_profile/presentation/controllers/report_controller.dart';

import '../../features/join_league/presentation/controller/join_league_controller/join_league_controller.dart';
import '../../features/team_members_profile/presentation/controllers/contact_us_controller.dart';

void setupController() {
  // Auth Controller
  Get.lazyPut<AuthController>(() => AuthController(Get.find(), Get.find()));
  Get.lazyPut<UserInfoController>(() => UserInfoController(Get.find()));
  Get.lazyPut<JoinLeagueController>(() => JoinLeagueController(Get.find()));
  Get.lazyPut<ContactUsController>(fenix: true, () => ContactUsController(Get.find()));
  Get.lazyPut<ReportController>(fenix: true, () => ReportController(Get.find()));


}
