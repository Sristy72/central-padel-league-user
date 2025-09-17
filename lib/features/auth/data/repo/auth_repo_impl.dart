import 'dart:convert';

import 'package:karlfive/features/auth/data/models/auth_response_model.dart';
import 'package:karlfive/features/auth/data/models/login_request_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/auth_repo.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/reset_password_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<AuthResponseData> login(LoginRequestModel request) {
    return _apiClient.post<AuthResponseData>(
      ApiConstants.auth.login,
      data: request.toJson(),
      fromJsonT: (json) => AuthResponseData.fromJson(json),
      // isFormData: true
    );
  }


  @override
  NetworkResult<RegisterResponseModel> register(RegisterRequestModel request) {
    return _apiClient.post<RegisterResponseModel>(
      ApiConstants.auth.register,
      data: request.toJson(),
      fromJsonT: (json) => RegisterResponseModel.fromJson(json),
    );
  }


  @override
  NetworkResult<ResetPasswordResponseModel> resetPassword(
    ResetPasswordRequestModel request,
  ) {
    return _apiClient.post(
      ApiConstants.auth.resetPass,
      data: request.toJson(),
      fromJsonT: (json) => ResetPasswordResponseModel.fromJson(json),
    );
  }
}
