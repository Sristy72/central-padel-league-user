import 'package:get/get.dart';
import 'package:karlfive/features/league/models/league_model.dart';
import 'package:karlfive/features/pre_home/data/guest_league_repository.dart';

/// Controller for managing guest mode public leagues
class GuestLeagueController extends GetxController {
  final GuestLeagueRepository _repository;

  GuestLeagueController({GuestLeagueRepository? repository})
      : _repository = repository ?? GuestLeagueRepository();

  // Observable states
  var isLoading = true.obs;
  var publicLeagues = <League>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPublicLeagues();
  }

  /// Fetch public leagues for guest users
  Future<void> fetchPublicLeagues() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final leagues = await _repository.fetchPublicLeagues(limit: 1000);
      
      print('Total leagues fetched: ${leagues.length}');
      
      // Filter to only show public leagues
      publicLeagues.value = leagues
          .where((league) {
            print('League: ${league.leagueName}, Type: ${league.leagueType}');
            return league.leagueType.toLowerCase() == 'public';
          })
          .toList();

      print('Public leagues after filter: ${publicLeagues.length}');
      isLoading.value = false;
    } catch (e) {
      print('Error fetching public leagues: $e');
      errorMessage.value = 'Failed to load public leagues: ${e.toString()}';
      isLoading.value = false;
    }
  }

  /// Refresh leagues
  Future<void> refreshLeagues() async {
    await fetchPublicLeagues();
  }
}
