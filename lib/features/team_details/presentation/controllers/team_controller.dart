import 'package:get/get.dart';
import '../../data/models/team_model.dart';
import '../../domain/repo/team_repo.dart';

class TeamController extends GetxController {
  final TeamRepo _repo;
  TeamController({required TeamRepo repo}) : _repo = repo;

  final Rxn<TeamModel> team = Rxn<TeamModel>();
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  Future<void> fetchTeam(String id) async {
    try {
      isLoading.value = true;
      final result = await _repo.getTeamById(id);
      result.fold((failure) {
        error.value = failure.message;
      }, (success) {
        team.value = success.data;
      });
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
