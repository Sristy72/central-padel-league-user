import 'package:dio/dio.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';
import 'package:karlfive/features/league/models/league_model.dart';

/// Repository for fetching public leagues without authentication (guest mode)
class GuestLeagueRepository {
  final Dio _dio;

  GuestLeagueRepository({Dio? dio}) : _dio = dio ?? Dio();

  /// Fetch all public leagues (no auth required)
  /// Endpoint: GET /api/v1/league/hh/all-league?limit=1000
  Future<List<League>> fetchPublicLeagues({int limit = 1000}) async {
    try {
      final url = '${ApiConstants.baseUrl}/league/hh/all-league';
      print('Fetching public leagues from: $url');
      
      final response = await _dio.get(
        url,
        queryParameters: {'limit': limit},
        options: Options(
          headers: ApiConstants.defaultHeaders,
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data type: ${response.data.runtimeType}');
      print('Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        // Check if response is directly a list or wrapped in an object
        List<dynamic> data;
        
        if (response.data is List) {
          data = response.data as List<dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          // Try common wrapper keys
          final map = response.data as Map<String, dynamic>;
          if (map.containsKey('data')) {
            data = map['data'] as List<dynamic>;
          } else if (map.containsKey('leagues')) {
            data = map['leagues'] as List<dynamic>;
          } else if (map.containsKey('results')) {
            data = map['results'] as List<dynamic>;
          } else {
            print('Unknown response structure. Keys: ${map.keys.toList()}');
            return [];
          }
        } else {
          print('Unexpected response type');
          return [];
        }
        
        print('Number of leagues in response: ${data.length}');
        
        return data
            .map((json) => League.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response: ${e.response?.data}');
      if (e.response?.statusCode == 404) {
        // No leagues found
        return [];
      }
      rethrow;
    } catch (e) {
      print('General error: $e');
      rethrow;
    }
  }
}
