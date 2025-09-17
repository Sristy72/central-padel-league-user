import 'package:karlfive/features/auth/data/models/auth_response_model.dart';
import 'package:karlfive/features/auth/data/models/login_request_model.dart';
import 'package:karlfive/features/auth/data/models/register_request_model.dart';
import 'package:karlfive/features/auth/data/models/reset_password_request_model.dart';
import 'package:karlfive/features/auth/data/models/reset_password_response_model.dart';

import '../../../../core/network/network_result.dart';
import '../../data/models/register_response_model.dart';

abstract class AuthRepository {
  NetworkResult<AuthResponseData> login(LoginRequestModel request);
  NetworkResult<RegisterResponseModel> register(RegisterRequestModel request);
  NetworkResult<ResetPasswordResponseModel> resetPassword(ResetPasswordRequestModel request);
}
