class ReportResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ReportData data;

  ReportResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: ReportData.fromJson(json['data'] ?? {}),
    );
  }
}

class ReportData {
  final String user;
  final String even;
  final String description;
  final String? reportImage;
  final String id;
  final int v;

  ReportData({
    required this.user,
    required this.even,
    required this.description,
    this.reportImage,
    required this.id,
    required this.v,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      user: json['user'] ?? '',
      even: json['even'] ?? '',
      description: json['description'] ?? '',
      reportImage: json['reportImage'],
      id: json['_id'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}
