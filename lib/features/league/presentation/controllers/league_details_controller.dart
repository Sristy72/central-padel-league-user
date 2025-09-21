import 'package:get/get.dart';
import '../../data/league_repository.dart';
import '../../models/match_model.dart';
import '../../models/standing_model.dart';

class LeagueDetailsController extends GetxController {
  final LeagueRepository repository;
  final String leagueId;

  LeagueDetailsController({required this.repository, required this.leagueId});

  final matches = <Match>[].obs;
  final isLoadingMatches = false.obs;
  final matchesError = ''.obs;

  final standings = <Standing>[].obs;
  final isLoadingStandings = false.obs;
  final standingsError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMatches();
    fetchStandings();
  }

  Future<void> fetchStandings() async {
    try {
      isLoadingStandings.value = true;
      final result = await repository.getStandingsAll();
      isLoadingStandings.value = false;
      result.fold(
        (failure) {
          standingsError.value = failure.message;
        },
        (success) {
          final data = success.data;
          final filtered = data.where((s) => s.leagueId == leagueId).toList();
          if (filtered.isEmpty) {
            standingsError.value = 'Nothing to show!';
          } else {
            standings.assignAll(filtered);
            standingsError.value = '';
          }
        },
      );
    } catch (e) {
      standingsError.value = e.toString();
      standings.clear();
      isLoadingStandings.value = false;
    }
  }

  Future<void> fetchMatches() async {
    try {
      isLoadingMatches.value = true;
      final result = await repository.getMatchesByLeague(leagueId);
      isLoadingMatches.value = false;
      result.fold(
        (failure) {
          matchesError.value = failure.message;
        },
        (success) {
          final data = success.data;
          //* <--- filter by league id (match.leagueId) --->
          final filtered = data.where((m) => m.leagueId == leagueId).toList();
          if (filtered.isEmpty) {
            matchesError.value = 'No matches to show!';
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
