import 'package:dio/dio.dart';

import 'package:karlfive/core/network/constants/api_constants.dart';
import 'package:karlfive/core/network/network_result.dart';

import '../../../../../core/network/api_client.dart';
import '../../../domain/repo/team_repo.dart';

import '../../model/join_response_model.dart';
import '../../model/league_reponse_model.dart';

// class JoinLeagueRepository {
//   final String baseUrl = "https://api.example.com"; // replace

//   Future<JoinLeagueResponse> submitApplication(JoinLeagueRequest request) async {
//     final uri = Uri.parse("$baseUrl/join-league");

//     final multipartRequest = http.MultipartRequest("POST", uri)
//       ..fields.addAll(request.toFields());

//     if (request.logoPath != null) {
//       multipartRequest.files.add(
//         await http.MultipartFile.fromPath("logo", request.logoPath!),
//       );
//     }

//     final streamed = await multipartRequest.send();
//     final response = await http.Response.fromStream(streamed);

//     if (response.statusCode == 200) {
//       return JoinLeagueResponse.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception("Failed to submit application");
//     }
//   }
// }

class JoinLeagueRepositoryImpl implements JoinLeagueRepository {
  final ApiClient _apiClient;

  JoinLeagueRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<JoinResponseModel> createTeam(FormData formData) {
    return _apiClient.post<JoinResponseModel>(
      ApiConstants.team.create,
      data: formData,
      fromJsonT: (json) => JoinResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<List<LeagueResponeModel>> getAllLeague() {
    return _apiClient.get<List<LeagueResponeModel>>(
      ApiConstants.league.getAllLeagues,
      fromJsonT: (json) => (json as List)
          .map((item) => LeagueResponeModel.fromJson(item))
          .toList(),
    );
  }
}
