import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repo/contact_us_repo.dart';
import '../models/contact_us_request_model.dart';
import '../models/contact_us_response_model.dart';
import '../models/report_post_model.dart';

class ContactUsRepoImpl implements ContactUsRepo {
  final ApiClient _apiClient;
  
  ContactUsRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;
  
  @override
  NetworkResult<ContactUsResponseModel> createContact(ContactUsRequestModel request) {
    return _apiClient.post<ContactUsResponseModel>(
        ApiConstants.contact.createContact,
        data: request.toJson(),
        fromJsonT: (json) => ContactUsResponseModel.fromJson(json)
    );
  }

  @override
  NetworkResult<ReportData> report(FormData formData) {
    return _apiClient.post<ReportData>(
        ApiConstants.contact.createContact,
        formData: formData,
        fromJsonT: (json) => ReportData.fromJson(json)
    );
  }
}