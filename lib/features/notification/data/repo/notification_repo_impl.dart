

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/notification_repo.dart';
import '../model/notification_request_model.dart';
import '../model/notification_response_model.dart';

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

  @override
  NetworkResult<List<NotificationResponseModel>> getNotificationsByUserId(String userId) {
    return _apiClient.get<List<NotificationResponseModel>>(
      ApiConstants.notification.getNotificationsByUserId(userId),
      fromJsonT: (json) {
        // json is already the 'data' array from the BaseResponse
        final dataList = json as List<dynamic>? ?? [];
        return dataList
            .map((item) => NotificationResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
