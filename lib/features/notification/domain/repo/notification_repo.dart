

import '../../../../core/network/network_result.dart';
import '../../data/model/notification_request_model.dart';
import '../../data/model/notification_response_model.dart';

abstract class NotificationRepo {
  NetworkResult<NotificationResponseModel> getnotifications(
    NotificationRequestModel request,
  );

  NetworkResult<NotificationResponseModel> markAsRead(
    NotificationRequestModel request,
  );
  
  NetworkResult<List<NotificationResponseModel>> getNotificationsByUserId(String userId);
}
