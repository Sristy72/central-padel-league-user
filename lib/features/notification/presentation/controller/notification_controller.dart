import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/features/notification/data/model/notification_request_model.dart';
import 'package:karlfive/features/notification/domain/repo/notification_repo.dart';

import '../../../../core/utils/debug_print.dart';

class NotificationController extends BaseController {
  final NotificationRepo _notificationRepository;

  NotificationController(this._notificationRepository);

  Future<void> getNotifications(String id, String message, String type) async {
    setLoading(true);

    //Create a request model if needed
    final request = NotificationRequestModel(
      userId: id,
      message: message,
      type: type,
    );

    final result = await _notificationRepository.getnotifications(request);

    result.fold(
      (fail) {
        DPrint.log("Notification success result : ${fail.message}");
        setLoading(false);
      },
      (succees) {
        DPrint.log("Notification success result : ${succees.data.id}");
        setLoading(false);
      },
    );
  }
}
