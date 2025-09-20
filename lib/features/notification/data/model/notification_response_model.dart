class NotificationResponseModel {
  final String id;
  final String userId;
  final String message;
  final String type;
  final bool isRead;
  final String? relatedId;
  final String title;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationResponseModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.type,
    required this.isRead,
    this.relatedId,
    required this.title,
    this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  /// --------- FROM JSON ---------
  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      id: (json['_id'] ?? '').toString(),
      userId: (json['to'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      type: (json['type'] ?? 'unknown').toString(),
      isRead: (json['isViewed'] ?? false) as bool,
      relatedId: json['id']?.toString(),
      title: (json['title'] ?? 'Notification').toString(),
      data: json['data'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  /// --------- TO JSON ---------
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "to": userId,
      "message": message,
      "type": type,
      "isViewed": isRead,
      "id": relatedId,
      "title": title,
      "data": data,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
