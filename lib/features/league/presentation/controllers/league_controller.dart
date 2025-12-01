import 'package:get/get.dart';
import 'package:dartz/dartz.dart';

import '../../data/league_repository.dart';
import '../../models/league_model.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/models/network_success.dart';

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
          print('� LeagueController: API returned ${fetchedLeagues.length} leagues');
          
          // CLIENT-SIDE FILTERING: Ensure we only show the correct type
          // This is a backup in case backend filtering doesn't work properly
          if (type != null && type.isNotEmpty) {
            final beforeFilter = fetchedLeagues.length;
            fetchedLeagues = fetchedLeagues.where((league) {
              final leagueTypeMatches = league.leagueType.toLowerCase() == type.toLowerCase();
              if (!leagueTypeMatches) {
                print('🔶 Filtered out: "${league.leagueName}" (type: ${league.leagueType}, wanted: $type)');
              }
              return leagueTypeMatches;
            }).toList();
            print('🟢 LeagueController: Client-side filter: $beforeFilter → ${fetchedLeagues.length} leagues (type=$type)');
          }
          
          leagues.assignAll(fetchedLeagues);
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
