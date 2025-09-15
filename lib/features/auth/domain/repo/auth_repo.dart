import 'package:karlfive/features/auth/data/models/auth_response_model.dart';
import 'package:karlfive/features/auth/data/models/login_request_model.dart';

import '../../../../core/network/network_result.dart';

abstract class AuthRepository {
  NetworkResult<AuthResponseData> login(LoginRequestModel request);
}
