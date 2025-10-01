// features/league/presentation/controllers/league_controller.dart

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
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeagues();
  }

  void fetchLeagues() async {
    try {
      isLoading(true);
      errorMessage('');

      final Either<NetworkFailure, NetworkSuccess<List<League>>> result =
          await repository.getAllLeagues();

      result.fold(
        (failure) {
          errorMessage(failure.message);
        },
        (success) {
          leagues.assignAll(success.data);
        },
      );
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
