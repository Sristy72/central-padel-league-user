import 'package:get/get.dart';
import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/network_result.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../domain/payment_repo.dart';
import '../model/create_payment_requesr.dart';
import '../model/create_payment_response.dart';

class PaymentApiRepositoryImpl implements PaymentApiRepository {
  final ApiClient _apiClient;

  PaymentApiRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<CreatePaymentApiResponse> createPayment(
    CreatePaymentRequest request,
  ) {
    return _apiClient.post<CreatePaymentApiResponse>(
      ApiConstants.payment.createPayment,
      data: request.toJson(),
      fromJsonT: (json) =>
          CreatePaymentApiResponse.fromJson(json),
    );
  }
}
