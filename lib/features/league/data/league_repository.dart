import '../../../core/network/network_result.dart';
import '../../create_league/models/create_league_response.dart';
import '../models/league_model.dart';
import '../models/match_model.dart';
import '../models/standing_model.dart';

abstract class LeagueRepository {
  NetworkResult<List<League>> getAllLeagues({String? leagueType, int? limit});
  NetworkResult<List<Match>> getMatchesByLeague(String leagueId);
  NetworkResult<List<Standing>> getStandingsAll();
  NetworkResult<CreateLeagueResponse> createLeague({
    required Map<String, dynamic> leagueData,
  });
}
