// features/league/data/league_remote_data_source.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:karlfive/core/network/constants/api_constants.dart';

abstract class LeagueRemoteDataSource {
  Future<List<dynamic>> fetchLeagues();
}

class LeagueRemoteDataSourceImpl implements LeagueRemoteDataSource {
  static const String baseUrl = ApiConstants.baseUrl;
  @override
  Future<List<dynamic>> fetchLeagues() async {
    final response = await http.get(Uri.parse("$baseUrl"));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      //* Case 1: response is a Map with "data"
      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        return decoded['data'];
      }

      //* Case 2: response is already a List
      if (decoded is List) {
        return decoded;
      }

      throw Exception("Unexpected response format: $decoded");
    } else {
      throw Exception("Failed to fetch leagues!!!");
    }
  }
}
