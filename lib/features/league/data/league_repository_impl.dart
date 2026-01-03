import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';

import '../../../core/network/network_result.dart';
import '../../create_league/models/create_league_response.dart';
import '../models/league_model.dart';
import '../models/match_model.dart';
import '../models/standing_model.dart';
import 'league_repository.dart';

class LeagueRepositoryImpl implements LeagueRepository {
  final ApiClient _apiClient;

  LeagueRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<List<League>> getAllLeagues({String? leagueType, int? limit}) {
    // Build query parameters
    final Map<String, dynamic> queryParams = {};
    
    // Handle leagueType mapping: 'my' -> 'me' for API
    if (leagueType != null) {
      if (leagueType.toLowerCase() == 'my') {
        queryParams['leagueType'] = 'me';
      } else {
        queryParams['leagueType'] = leagueType;
      }
    }
    
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }

    print('🔶 Repository: Built query params -> $queryParams');
    print('🔶 Repository: Passing to ApiClient -> ${queryParams.isNotEmpty ? queryParams : null}');

    return _apiClient.get<List<League>>(
      ApiConstants.league.getAllLeagues,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      fromJsonT: (json) {
        print('🔵 Repository fromJsonT: Received json type: ${json.runtimeType}');
        print('🔵 Repository fromJsonT: Received json: $json');
        
        if (json is! List) {
          print('❌ Repository ERROR: Expected List but got ${json.runtimeType}');
          throw Exception('Expected List but got ${json.runtimeType}');
        }
        
        final result = (json)
            .map((item) {
              print('🟢 Repository: Parsing league item: ${item['leagueName'] ?? 'Unknown'}');
              return League.fromJson(item);
            })
            .toList();
        
        print('🟢 Repository: Successfully parsed ${result.length} leagues');
        return result;
      },
    );
  }

  @override
  NetworkResult<List<Match>> getMatchesByLeague(String leagueId) {
    // full endpoint: {baseUrl}/match/all-match
    final endpoint = '${ApiConstants.baseUrl}/match/all-match';
    return _apiClient.get<List<Match>>(
      endpoint,
      fromJsonT: (json) {
        final list = (json as List)
            .map((e) => Match.fromJson(e as Map<String, dynamic>))
            .toList();
        // Try to filter by nested league id if present on match json
        return list;
      },
    );
  }

  @override
  NetworkResult<List<Standing>> getStandingsAll() {
    final endpoint = '${ApiConstants.baseUrl}/standing/all';
    return _apiClient.get<List<Standing>>(
      endpoint,
      fromJsonT: (json) => (json as List)
          .map((e) => Standing.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  NetworkResult<CreateLeagueResponse> createLeague({
    required Map<String, dynamic> leagueData,
  }) {
    return _apiClient.post<CreateLeagueResponse>(
      ApiConstants.league.create,
      data: leagueData,
      fromJsonT: (json) => CreateLeagueResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<Match> updateMatchScore({
    required String matchId,
    required Map<String, dynamic> scoreData,
  }) {
    print('🔵 Repository: Updating match score for matchId=$matchId');
    print('🔵 Repository: Score data = $scoreData');
    
    return _apiClient.patch<Match>(
      ApiConstants.match.updateScore(matchId),
      data: scoreData,
      fromJsonT: (json) {
        print('🟢 Repository: Match score updated successfully');
        return Match.fromJson(json as Map<String, dynamic>);
      },
    );
  }
}
