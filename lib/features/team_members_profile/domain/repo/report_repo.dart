import 'package:dio/dio.dart';
import '../../../../core/network/network_result.dart';
import '../../data/models/report_post_model.dart';

abstract class ReportRepo {
  NetworkResult<ReportData> report(FormData formData);
}
