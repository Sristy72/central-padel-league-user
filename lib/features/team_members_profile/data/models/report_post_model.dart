class ReportData {
  final String user;
  final String even; // note: API key is "even". If it's a typo, rename to "event"
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
