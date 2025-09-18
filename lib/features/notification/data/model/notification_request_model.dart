class NotificationRequestModel {
  final String userId;
  final String message;
  final String type;
  final bool isRead;
  final String? relatedId;
  final Map<String, dynamic>? data;

  NotificationRequestModel({
    required this.userId,
    required this.message,
    required this.type,
    this.isRead = false,
    this.relatedId,
    this.data,
  });

  /// --------- TO JSON ---------
  Map<String, dynamic> toJson() {
    return {
      "to": userId,
      "message": message,
      "type": type,
      "isViewed": isRead,
      if (relatedId != null) "id": relatedId,
      if (data != null) "data": data,
    };
  }
}
