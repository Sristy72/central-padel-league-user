import '../../../core/network/api_client.dart';
import '../../../core/network/constants/api_constants.dart';
import '../../../core/network/network_result.dart';
import '../../league/models/match_model.dart' as league_match;
import '../../league/models/standing_model.dart' as league_standing;
import '../../league/models/league_model.dart' as league_model;

import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient apiClient;

  HomeRepositoryImpl({required this.apiClient});

  @override
  NetworkResult<List<league_match.Match>> getAllMatches() {
    final endpoint = '${ApiConstants.baseUrl}/match/all-match';
    return apiClient.get<List<league_match.Match>>(
      endpoint,
      fromJsonT: (json) {
        return (json as List)
            .map((e) => league_match.Match.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  NetworkResult<List<league_standing.Standing>> getAllStandings() {
    final endpoint = '${ApiConstants.baseUrl}/standing/all';
    return apiClient.get<List<league_standing.Standing>>(
      endpoint,
      fromJsonT: (json) {
        return (json as List)
            .map(
              (e) =>
                  league_standing.Standing.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      },
    );
  }

  @override
  NetworkResult<List<league_model.League>> getAllLeagues({String? leagueType, int? limit}) {
    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    if (leagueType != null) {
      queryParams['leagueType'] = leagueType;
    }
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }

    print('🔶 HomeRepository: Fetching leagues with type=$leagueType, limit=$limit');

    return apiClient.get<List<league_model.League>>(
      ApiConstants.league.getAllLeagues,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJsonT: (json) {
        var leagues = (json as List).map((e) => league_model.League.fromJson(e)).toList();
        
        // CLIENT-SIDE FILTERING: Backup filter to ensure correct league type
        if (leagueType != null && leagueType.isNotEmpty) {
          final beforeFilter = leagues.length;
          leagues = leagues.where((league) {
            final matches = league.leagueType.toLowerCase() == leagueType.toLowerCase();
            if (!matches) {
              print('🔶 HomeRepository: Filtered out "${league.leagueName}" (type: ${league.leagueType}, wanted: $leagueType)');
            }
            return matches;
          }).toList();
          print('🟢 HomeRepository: Client-side filter: $beforeFilter → ${leagues.length} leagues (type=$leagueType)');
        }
        
        return leagues;
      },
    );
  }
}
