import 'package:get/get.dart';
import 'package:karlfive/features/team_details/data/models/team_model.dart';
import 'package:karlfive/features/team_details/domain/repo/team_repo.dart';

class AllTeamsController extends GetxController {
  final TeamRepo _repo;
  AllTeamsController({required TeamRepo repo}) : _repo = repo;

  final teams = <TeamModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchAllTeams();
  }

  Future<void> fetchAllTeams() async {
    try {
      isLoading.value = true;
      final res = await _repo.getAllTeams();
      res.fold((failure) {
        error.value = failure.message;
      }, (success) {
        teams.assignAll(success.data);
      });
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
