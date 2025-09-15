import 'package:get/get.dart';

import '../model/join_league_model.dart';

class JoinLeagueRepository extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://your-api-url.com/';
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30);
  }

  Future<JoinLeagueResponse> submitApplication(
    JoinLeagueRequest request,
  ) async {
    try {
      final response = await post('api/join-league', request.toJson());

      if (response.statusCode == 200) {
        return JoinLeagueResponse.fromJson(response.body);
      } else {
        throw Exception('Failed to submit application: ${response.statusText}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
