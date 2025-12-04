import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/report_repo.dart';
import '../models/report_post_model.dart';

class ReportRepoImpl implements ReportRepo {
  final ApiClient _apiClient;
  ReportRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<ReportData> report(FormData formData) {
    return _apiClient.post<ReportData>(
      ApiConstants.report.createReport,
      formData: formData,
      isFormData: true,
      fromJsonT: (json) => ReportData.fromJson(json),
    );
  }
}
