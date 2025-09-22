import 'package:get/get.dart';
import 'package:karlfive/features/EntireScreen/data/repo/user_info_repo_impl.dart';
import 'package:karlfive/features/EntireScreen/domain/repo/user_info_repo.dart';
import 'package:karlfive/features/auth/data/repo/auth_repo_impl.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
import 'package:karlfive/features/join_league/data/repositories/join_league/join_league.dart';
import 'package:karlfive/features/join_league/domain/repo/team_repo.dart';
import 'package:karlfive/features/team_members_profile/data/repo/contact_us_repo_impl.dart';
import '../../features/team_members_profile/domain/repo/contact_us_repo.dart';
import 'package:karlfive/features/team_members_profile/data/repo/user_profile_repo_impl.dart';
import 'package:karlfive/features/team_members_profile/domain/repo/user_profile_repo.dart';
import 'package:karlfive/features/team_members_profile/presentation/controllers/profile_controller.dart';

void setupRepository() {
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()));

  Get.lazyPut<UserInfoRepo>(() => UserInfoRepoImpl(apiClient: Get.find()));

  Get.lazyPut<JoinLeagueRepository>(
    () => JoinLeagueRepositoryImpl(apiClient: Get.find()),
  );

  Get.lazyPut<ContactUsRepo>(
        () => ContactUsRepoImpl(apiClient: Get.find()),
    fenix: true
  );

  // User profile repo & controller
  Get.lazyPut<UserProfileRepo>(
    () => UserProfileRepoImpl(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<ProfileController>(
    () => ProfileController(repository: Get.find()),
    fenix: true,
  );
}
