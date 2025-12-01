import 'package:get/get.dart';

import '../../../league/data/league_repository.dart';
import '../../models/create_league_response.dart';

class CreateLeagueController extends GetxController {
  var isLoading = false.obs;
  var leagueCode = ''.obs;
  var errorMessage = ''.obs;
  
  late final LeagueRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<LeagueRepository>();
  }

  Future<bool> createLeagueDummy() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    return true;
  }

  Future<CreateLeagueResponse?> createLeague({
    required String leagueName,
    required String description,
    required String startDate,
    required String location,
    required int totalGameWeeks,
    required String type,
    required String leagueType,
    required String matchFormat,
    required String tiebreakOption,
    required bool allowSubstitutes,
    String? entryFee,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final leagueData = {
        'leagueName': leagueName,
        'description': description,
        'startDate': startDate,
        'location': location,
        'totalGameWeeks': totalGameWeeks,
        'type': type,
        'leagueType': leagueType,
        'matchFormat': matchFormat,
        'tiebreakOption': tiebreakOption,
        'allowSubstitutes': allowSubstitutes,
        if (entryFee?.isNotEmpty == true) 'entryFee': entryFee,
      };

      print('🔵 CreateLeagueController: Creating league with data: $leagueData');
      
      final result = await _repository.createLeague(leagueData: leagueData);
      
      return result.fold(
        (failure) {
          print('🔴 CreateLeagueController: Create failed - ${failure.message}');
          errorMessage.value = failure.message;
          return null;
        },
        (success) {
          print('🟢 CreateLeagueController: Create success - League ID: ${success.data.id}, Code: ${success.data.leagueCode}');
          leagueCode.value = success.data.leagueCode;
          return success.data;
        },
      );
    } catch (e) {
      print('🔴 CreateLeagueController: Exception during create - $e');
      errorMessage.value = 'Failed to create league: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
