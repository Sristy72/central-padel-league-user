class ApiConstants {
  /// [Base Configuration]
  static const String baseDomain = 'https://karlfive223-backend.onrender.com';
  // static const String baseDomain = 'http://72.61.161.196';
  static const String baseUrl = '$baseDomain/api/v1';

  /// soykot ip

  // static const String baseDomain = 'http://10.10.5.88:5002';

  /// [Headers]
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
    // Content-Type will be set automatically for multipart
  };

  /// [Endpoint Groups]
  static AuthEndpoints get auth => AuthEndpoints();

  static UserEndpoints get user => UserEndpoints();
  static NotificationEndpoints get notification => NotificationEndpoints();

  static TeamEndpointcs get team => TeamEndpointcs();
  static LeagueEndpoints get league => LeagueEndpoints();
  static MatchEndpoints get match => MatchEndpoints();

  static ContactEndpoints get contact => ContactEndpoints();
  static ChatEndpoints get chat => ChatEndpoints();

  static PaymentEndpoints get payment => PaymentEndpoints();
  static ReportEndpoints get report => ReportEndpoints();
}

/// [Authentication Endpoints]
class AuthEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/auth';

  final String login = '$_base/login';
  final String register = '$_base/register';
  final String resetPass = '$_base/send-reset-otp';
  final String refreshToken = '$_base/refresh-token';
  final String otpVerify = '$_base/verify-reset-otp';
  final String otpVerifyRegister = '$_base/verify-otp';
  final String setNewPass = '$_base/reset-password';
}

class UserEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/user';
  final String updateProfile = '$_base/update-profile';
  final String getUserProfile = '$_base/profile';

  // final String create = '$_base/create';
}

class NotificationEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/notification';

  final String getnotifications = '$_base/getnotifications';

  String getNotificationsByUserId(String userId) => '$_base/$userId';
}

class TeamEndpointcs {
  static const String _base = '${ApiConstants.baseUrl}/team';

  final String create = '$_base/create';
  final String getAll = '$_base/all-team';
}

class LeagueEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/league';

  final String getAllLeagues = '$_base/all-league';
  final String create = '$_base/create';
}

class MatchEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/match';

  String updateScore(String matchId) => '$_base/$matchId';
}

class ContactEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/contact';
  final String createContact = '$_base/create';
}

class ChatEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/chat';

  final String createChat = '$_base/create-chat';
  final String getAllChats = '$_base/get-chats';
  final String sendMessage = '$_base/send-message';
  
  String getSingleChat(String chatId) => '$_base/$chatId';
}

// New payment endpoints
class PaymentEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/payment';

  final String createPayment = '$_base/create-payment';

  final String confirmPayment = '$_base/confirm-payment';
}

class ReportEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/report';

  /// Create a report (POST)
  final String createReport = '$_base/create';

  /// Optional — in case backend supports fetching user reports later
  final String getReports = '$_base/all';
}
