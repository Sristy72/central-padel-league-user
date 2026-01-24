import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';
import '../../data/league_repository.dart';
import '../../models/league_model.dart';

class LeagueController extends GetxController {
  final LeagueRepository repository;

  LeagueController({required this.repository});

  var leagues = <League>[].obs;
  var isLoading = false.obs; // Start with false since we don't auto-fetch
  var errorMessage = ''.obs;
  var leagueType = RxnString(); // Track current league type filter

  // No onInit needed - let the screen decide which filter to use

  void fetchLeagues({String? type, int? limit}) async {
    try {
      print('🔵 LeagueController: Fetching leagues with type=$type, limit=$limit');
      isLoading(true);
      errorMessage('');
      
      // Update current filter
      leagueType.value = type;

      final Either<NetworkFailure, NetworkSuccess<List<League>>> result =
          await repository.getAllLeagues(leagueType: type, limit: limit);

      result.fold(
        (failure) {
          print('🔴 LeagueController: Fetch failed - ${failure.message}');
          errorMessage(failure.message);
        },
        (success) {
          var fetchedLeagues = success.data;
          print('🟢 LeagueController: API returned ${fetchedLeagues.length} leagues');
          print('🟢 LeagueController: Full data: $fetchedLeagues');
          
          // No client-side filtering needed - backend already filters correctly
          // Just display all leagues from the API response
          
          leagues.assignAll(fetchedLeagues);
          print('🟢 LeagueController: leagues.obs now contains ${leagues.length} leagues');
          print('🟢 LeagueController: Final result - ${leagues.length} leagues displayed');
        },
      );
    } catch (e) {
      print('🔴 LeagueController: Exception - $e');
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Convenience methods for specific filters
  void fetchPublicLeagues({int limit = 200}) {
    fetchLeagues(type: 'public', limit: limit);
  }

  void fetchPrivateLeagues({int limit = 200}) {
    fetchLeagues(type: 'private', limit: limit);
  }
}
