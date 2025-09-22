import 'package:karlfive/core/network/network_result.dart';

import '../data/model/create_payment_requesr.dart';
import '../data/model/create_payment_response.dart';

abstract class PaymentApiRepository {
  NetworkResult<CreatePaymentApiResponse> createPayment(
    CreatePaymentRequest request,
  );
}
