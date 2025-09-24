// post_create_payment_response_model.dart
class PostCreatePaymentResponseModel {
  final bool? success;
  final String? clientSecret;
  final String? message;

  PostCreatePaymentResponseModel({
    this.success,
    this.clientSecret,
    this.message,
  });

  factory PostCreatePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PostCreatePaymentResponseModel(
      success: json['success'] as bool?,
      clientSecret: json['clientSecret'] as String?,
      message: json['message'] as String?,
    );
  }
}
