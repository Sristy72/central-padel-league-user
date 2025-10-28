import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';
import 'package:karlfive/core/network/network_result.dart';

import '../../domain/repo/team_repo.dart';
import '../models/team_model.dart';

class TeamRepoImpl implements TeamRepo {
  final ApiClient _apiClient;
  TeamRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<TeamModel> getTeamById(String id) {
    final path = '${ApiConstants.baseUrl}/team/$id';
    return _apiClient.get<TeamModel>(
      path,
      fromJsonT: (json) => TeamModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<List<TeamModel>> getAllTeams() {
    final path = '${ApiConstants.baseUrl}/team/all-team';
    return _apiClient.get<List<TeamModel>>(
      path,
      fromJsonT: (json) => (json as List)
          .map((item) => TeamModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
