
class NotificationModel {
  final String title;
  final String message;
  final String timeAgo;
  final bool isUnread;

  NotificationModel({
    required this.title,
    required this.message,
    required this.timeAgo,
    this.isUnread = false,
  });
}
