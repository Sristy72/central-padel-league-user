import 'package:get/get.dart';
import 'package:karlfive/features/EntireScreen/data/repo/user_info_repo_impl.dart';
import 'package:karlfive/features/EntireScreen/domain/repo/user_info_repo.dart';
import 'package:karlfive/features/auth/data/repo/auth_repo_impl.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
import 'package:karlfive/features/join_league/data/repositories/join_league/join_league.dart';

import 'package:karlfive/features/join_league/domain/repo/team_repo.dart';

void setupRepository() {
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()));

  Get.lazyPut<UserInfoRepo>(() => UserInfoRepoImpl(apiClient: Get.find()));

  Get.lazyPut<JoinLeagueRepository>(
    () => JoinLeagueRepositoryImpl(apiClient: Get.find()),
  );
}
