import 'package:get/get.dart';
import 'package:karlfive/features/EntireScreen/data/repo/user_info_repo_impl.dart';
import 'package:karlfive/features/EntireScreen/domain/repo/user_info_repo.dart';
import 'package:karlfive/features/auth/data/repo/auth_repo_impl.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';
import 'package:karlfive/features/join_league/data/repositories/join_league/join_league.dart';

import 'package:karlfive/features/join_league/domain/repo/team_repo.dart';
import 'package:karlfive/features/league/data/league_repository.dart';
import 'package:karlfive/features/league/data/league_repository_impl.dart';
import 'package:karlfive/features/home/data/home_repository_impl.dart';
import 'package:karlfive/features/home/data/home_repository.dart';

void setupRepository() {
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(apiClient: Get.find()));

  Get.lazyPut<UserInfoRepo>(() => UserInfoRepoImpl(apiClient: Get.find()));

  Get.lazyPut<JoinLeagueRepository>(
    () => JoinLeagueRepositoryImpl(apiClient: Get.find()),
  );

  Get.lazyPut<LeagueRepository>(
    () => LeagueRepositoryImpl(apiClient: Get.find()),
  );

  // Home repository for fetching matches/standings/leagues used by home screen
  Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(apiClient: Get.find()));
}
