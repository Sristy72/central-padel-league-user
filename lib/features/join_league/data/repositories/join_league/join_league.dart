import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/join_league_model/join_league_model_request.dart';
import '../../model/join_league_model/join_league_model_response.dart';


class JoinLeagueRepository {
  final String baseUrl = "https://api.example.com"; // replace

  Future<JoinLeagueResponse> submitApplication(JoinLeagueRequest request) async {
    final uri = Uri.parse("$baseUrl/join-league");

    final multipartRequest = http.MultipartRequest("POST", uri)
      ..fields.addAll(request.toFields());

    if (request.logoPath != null) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath("logo", request.logoPath!),
      );
    }

    final streamed = await multipartRequest.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      return JoinLeagueResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to submit application");
    }
  }
}
