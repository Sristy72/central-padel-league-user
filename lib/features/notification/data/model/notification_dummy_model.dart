// class NotificationModel {
//   final String? id;
//   final String? title;
//   final String? message;
//   final bool isRead;
//   final String? timeAgo;

//   NotificationModel({
//     this.id,
//     this.title,
//     this.message,
//     this.isRead = false,
//     this.timeAgo,
//   });

//   NotificationModel copyWith({bool? isRead}) {
//     return NotificationModel(
//       id: id,
//       title: title,
//       message: message,
//       isRead: isRead ?? this.isRead,
//       timeAgo: timeAgo,
//     );
//   }
// }

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
