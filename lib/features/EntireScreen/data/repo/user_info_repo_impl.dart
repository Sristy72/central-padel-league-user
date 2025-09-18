import 'package:dio/dio.dart';
import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';
import 'package:karlfive/core/network/network_result.dart';
import 'package:karlfive/features/EntireScreen/data/model/user_info_request_model.dart';
import 'package:karlfive/features/EntireScreen/data/model/user_info_response_model.dart';
import 'package:karlfive/features/EntireScreen/domain/repo/user_info_repo.dart';

class UserInfoRepoImpl implements UserInfoRepo {
  final ApiClient _apiClient;

  UserInfoRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<UserInfoResponseModel> updateprofile(FormData formData) {
    return _apiClient.put<UserInfoResponseModel>(
      ApiConstants.user.updateProfile,
      data: formData,
      fromJsonT: (json) => UserInfoResponseModel.fromJson(json),
      // isFormData: true
    );
  }
}
