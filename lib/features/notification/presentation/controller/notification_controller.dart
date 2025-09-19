// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:karlfive/core/base/base_controller.dart';
// import 'package:karlfive/features/notification/data/model/notification_request_model.dart';
// import 'package:karlfive/features/notification/domain/repo/notification_repo.dart';

// import '../../../../core/utils/debug_print.dart';

// class NotificationController extends BaseController {
//   final NotificationRepo _notificationRepository;

//   final RxList<dynamic> notifications = <dynamic>[].obs;

//   // Demo loading state
//   final RxBool isLoading = false.obs;

//   NotificationController(this._notificationRepository);

//   // Future<void> getNotifications(String id, String message, String type) async {
//   //   setLoading(true);

//   //   //Create a request model if needed
//   //   final request = NotificationRequestModel(
//   //     userId: id,
//   //     message: message,
//   //     type: type,
//   //   );

//   //   final result = await _notificationRepository.getnotifications(request);

//   //   result.fold(
//   //     (fail) {
//   //       DPrint.log("Notification success result : ${fail.message}");
//   //       setLoading(false);
//   //     },
//   //     (succees) {
//   //       DPrint.log("Notification success result : ${succees.data.id}");
//   //       setLoading(false);
//   //     },
//   //   );
//   // }

//   // Future<void> makeAsRead() async {
//   //   final result = await _notificationRepository.markAsRead(String id, String message, String type);
//   //   final request = NotificationRequestModel(
//   //     userId: id,
//   //     message: message,
//   //     type: type,
//   //   );

//   //   result.fold((fail) {}, (success) {
//   //     DPrint.log("Mark as read success result : ${success.data}");
//   //   });
//   // }

//   Future<void> getNotifications(String id, String message, String type) async {
//     isLoading.value = true;

//     // TODO: Replace with real API call
//     await Future.delayed(const Duration(seconds: 1));

//     // Demo fake notifications
//     notifications.assignAll([
//       {
//         "title": "Welcome!",
//         "message": "Thanks for joining our platform 🎉",
//         "timeAgo": "2m ago",
//         "isRead": false,
//       },
//       {
//         "title": "Match Update",
//         "message": "Your favorite team just won the match 🏆",
//         "timeAgo": "10m ago",
//         "isRead": true,
//       },
//     ]);

//     isLoading.value = false;
//   }

//   /// 🔹 Demo "Mark All As Read"
//   void markAllAsRead() {
//     for (var n in notifications) {
//       n["isRead"] = true;
//     }
//     notifications.refresh(); // 👈 updates UI
//   }
// }
