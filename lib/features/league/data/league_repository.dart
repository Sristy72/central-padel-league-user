import '../../../core/network/network_result.dart';
import '../models/league_model.dart';

abstract class LeagueRepository {
  NetworkResult<List<League>> getAllLeagues();
}
