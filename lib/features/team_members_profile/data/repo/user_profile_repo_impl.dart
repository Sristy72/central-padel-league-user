import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';
import 'package:karlfive/core/network/network_result.dart';
import '../../data/models/user_profile_model.dart';
import '../../domain/repo/user_profile_repo.dart';

class UserProfileRepoImpl implements UserProfileRepo {
  final ApiClient _apiClient;

  UserProfileRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<UserProfileModel> getProfile() {
    return _apiClient.get<UserProfileModel>(
      ApiConstants.user.getUserProfile,
      fromJsonT: (json) => UserProfileModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
