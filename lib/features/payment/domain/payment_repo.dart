import '../data/data_source/stripe_service.dart';
import '../data/model/create_pay_request.dart';
import '../data/model/create_pay_response.dart';

class PaymentRepository {
  final StripeService _service = StripeService.instance;

  Future<PaymentResponse> createPaymentIntent(PaymentRequest request) async {
    final json = await _service.createPaymentIntent(request);
    return PaymentResponse.fromJson(json);
  }
}
