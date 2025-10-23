import 'package:dio/dio.dart';
import 'package:karlfive/core/network/network_result.dart';
import 'package:karlfive/features/EntireScreen/data/model/user_info_response_model.dart';

abstract class UserInfoRepo {
  NetworkResult<UserInfoResponseModel> updateprofile(FormData formData);
}
