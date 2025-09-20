import 'package:karlfive/core/network/network_result.dart';
import 'package:karlfive/features/notification/data/model/notification_request_model.dart';
import 'package:karlfive/features/notification/data/model/notification_response_model.dart';

abstract class NotificationRepo {
  NetworkResult<NotificationResponseModel> getnotifications(
    NotificationRequestModel request,
  );

  NetworkResult<NotificationResponseModel> markAsRead(
    NotificationRequestModel request,
  );
}
