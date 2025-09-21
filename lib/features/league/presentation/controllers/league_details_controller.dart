import 'package:get/get.dart';
import '../../data/league_repository.dart';
import '../../models/match_model.dart';

class LeagueDetailsController extends GetxController {
  final LeagueRepository repository;
  final String leagueId;

  LeagueDetailsController({required this.repository, required this.leagueId});

  final matches = <Match>[].obs;
  final isLoadingMatches = false.obs;
  final matchesError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      isLoadingMatches.value = true;
      final res = await repository.getMatchesByLeague(leagueId);
      isLoadingMatches.value = false;
      res.fold(
        (failure) {
          matchesError.value = failure.message;
        },
        (success) {
          final data = success.data;
          // filter by league id (match.leagueId)
          final filtered = data.where((m) => m.leagueId == leagueId).toList();
          if (filtered.isEmpty) {
            matchesError.value = 'No matches returned for this league';
          } else {
            matches.assignAll(filtered);
            matchesError.value = '';
          }
        },
      );
    } catch (e) {
      matchesError.value = e.toString();
      matches.clear();
      isLoadingMatches.value = false;
    }
  }
}
