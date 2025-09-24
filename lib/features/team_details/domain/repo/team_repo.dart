import 'package:karlfive/core/network/network_result.dart';
import '../../data/models/team_model.dart';

abstract class TeamRepo {
  NetworkResult<TeamModel> getTeamById(String id);
}
