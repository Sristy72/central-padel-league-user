import 'package:dio/dio.dart';

import '../../../../core/network/network_result.dart';
import '../../data/model/join_response_model.dart';
import '../../data/model/league_reponse_model.dart';

abstract class JoinLeagueRepository {
  NetworkResult<List<LeagueResponeModel>> getAllLeague({String? leagueType, int? limit});
  NetworkResult<JoinResponseModel> createTeam(FormData formData);
}
