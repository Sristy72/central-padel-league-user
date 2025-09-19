import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';
import 'package:karlfive/core/network/network_result.dart';
import 'package:karlfive/features/notification/data/model/notification_request_model.dart';
import 'package:karlfive/features/notification/data/model/notification_response_model.dart';
import 'package:karlfive/features/notification/domain/repo/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo {
  final ApiClient _apiClient;

  NotificationRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<NotificationResponseModel> getnotifications(
    NotificationRequestModel request,
  ) {
    return _apiClient.get<NotificationResponseModel>(
      ApiConstants.notification.getnotifications,
      queryParameters: request.toJson(),
      fromJsonT: (json) => NotificationResponseModel.fromJson(json),
      // isFormData: true
    );
  }

  @override
  NetworkResult<NotificationResponseModel> markAsRead(
    NotificationRequestModel request,
  ) {
    return _apiClient.get<NotificationResponseModel>(
      ApiConstants.notification.getnotifications,
      queryParameters: request.toJson(),
      fromJsonT: (json) => NotificationResponseModel.fromJson(json),
      // isFormData: true
    );
  }
}
