class NotificationModel {
  final String? id;
  final String? title;
  final String? message;
  final bool isRead;
  final String? timeAgo;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.isRead = false,
    this.timeAgo,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      isRead: isRead ?? this.isRead,
      timeAgo: timeAgo,
    );
  }
}
