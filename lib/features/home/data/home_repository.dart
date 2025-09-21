import '../../../core/network/network_result.dart';
import '../../league/models/match_model.dart' as league_match;
import '../../league/models/standing_model.dart' as league_standing;
import '../../league/models/league_model.dart' as league_model;

/// Contracts for Home feature data access.
abstract class HomeRepository {
  NetworkResult<List<league_match.Match>> getAllMatches();

  NetworkResult<List<league_standing.Standing>> getAllStandings();

  NetworkResult<List<league_model.League>> getAllLeagues();
}
