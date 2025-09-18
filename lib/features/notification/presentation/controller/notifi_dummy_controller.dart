import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/features/notification/data/model/notification_dummy_model.dart';

class NotificationController extends BaseController {
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    notifications.value = [
      NotificationModel(
        title: "",
        message:
            "Reminder: Your match vs. Smash Bros is  tomorrow at 6:00 PM on Court 3.",
        timeAgo: "2 hours ago",
        isUnread: true,
      ),
      NotificationModel(
        title: "",
        message:
            "Don’t forget! You’re scheduled to play at Padel Arena, 5:30 PM check-in.",
        timeAgo: "2 hours ago",
        isUnread: true,
      ),
      NotificationModel(
        title: "",
        message: "Receive announcements from Admin",
        timeAgo: "2 hours ago",
        isUnread: true,
      ),
      NotificationModel(
        title: "",
        message:
            "Tough luck! You lost 0–2 vs. Court Kings. Keep pushing for the next match!",
        timeAgo: "3 hours ago",
      ),
      NotificationModel(
        title: "",
        message: "Standings updated: Your team is now ranked #2 in the league.",
        timeAgo: "3 hours ago",
      ),
      NotificationModel(
        title: "",
        message: "Your team has been confirmed for the Padel Premier League.",
        timeAgo: "3 hours ago",
      ),
      NotificationModel(
        title: "",
        message:
            "New tournament announced! Register now before \n slots fill up.",
        timeAgo: "3 hours ago",
      ),
      NotificationModel(
        title: "",
        message: "Standings updated: Your team is now ranked #2 in the league.",
        timeAgo: "3 hours ago",
      ),
      NotificationModel(
        title: "",
        message: "New tournament announced! Register now before slots fill up.",
        timeAgo: "3 hours ago",
      ),
    ];
  }

  void markAllAsRead() {
    notifications.value = notifications.map((n) {
      return NotificationModel(
        title: n.title,
        message: n.message,
        timeAgo: n.timeAgo,
        isUnread: false,
      );
    }).toList();
  }
}
