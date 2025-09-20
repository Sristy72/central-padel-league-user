import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';

import '../../../core/network/network_result.dart';
import '../models/league_model.dart';
import 'league_repository.dart';

class LeagueRepositoryImpl implements LeagueRepository {
  final ApiClient _apiClient;

  LeagueRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<List<League>> getAllLeagues() {
    return _apiClient.get<List<League>>(
      ApiConstants.league.getAllLeagues,
      fromJsonT: (json) =>
          (json as List).map((item) => League.fromJson(item)).toList(),
    );
  }
}
