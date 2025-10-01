import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/payment_repo.dart';
import 'create_payment_requesr.dart';
import 'create_payment_response.dart'; 


class PaymentApiRepositoryImpl implements PaymentApiRepository {
  final ApiClient _apiClient;

  PaymentApiRepositoryImpl(this._apiClient);

  @override
  NetworkResult<CreatePaymentApiResponse> createPayment(
    CreatePaymentRequest request,
  ) {
    return _apiClient.post<CreatePaymentApiResponse>(
      ApiConstants.payment.createPayment,
      data: request.toJson(),
      fromJsonT: (json) =>
          CreatePaymentApiResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}

class PaymentResponse {
  final String id; 
  final String clientSecret;

  PaymentResponse({required this.id, required this.clientSecret});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      id: json['id'] as String? ?? '',
      clientSecret: json['client_secret'] as String? ?? '',
    );
  }
}
