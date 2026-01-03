import 'package:dartz/dartz.dart';
import 'package:karlfive/core/network/api_client.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';
import 'package:karlfive/core/network/models/network_failure.dart';
import 'package:karlfive/core/network/models/network_success.dart';

import 'models/chat_model.dart';

class ChatApi {
  final ApiClient _apiClient = ApiClient();

  /// 🔹 Fetch All Chats for Logged-In User
  Future<Either<NetworkFailure, NetworkSuccess<List<ChatModel>>>> getAllChats() async {
    final result = await _apiClient.get<List<ChatModel>>(
      ApiConstants.chat.getAllChats,
      fromJsonT: (json) {
        if (json is List) {
          return json.map((e) => ChatModel.fromJson(e)).toList();
        }
        return <ChatModel>[];
      },
    );
    return result;
  }

  /// 🔹 Fetch Single Chat by ID
  Future<Either<NetworkFailure, NetworkSuccess<ChatModel>>> getSingleChat(String chatId) async {
    final result = await _apiClient.get<ChatModel>(
      ApiConstants.chat.getSingleChat(chatId),
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return ChatModel.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );
    return result;
  }

  /// 🔹 Send Message to Chat
  /// [chatId] is the chat ID to send message to
  /// [message] is the message text
  Future<Either<NetworkFailure, NetworkSuccess<ChatMessageModel>>> sendMessage({
    required String chatId,
    required String message,
  }) async {
    final data = {
      'chatId': chatId,
      'message': message,
    };

    final result = await _apiClient.post<ChatMessageModel>(
      ApiConstants.chat.sendMessage,
      data: data,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return ChatMessageModel.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );
    return result;
  }

  /// 🔹 Create New Chat with Seller
  /// [sellerId] is the team 1 ID (seller)
  /// [userId] is the team 2 ID (user)
  Future<Either<NetworkFailure, NetworkSuccess<ChatModel>>> createChat({
    required String sellerId,
    required String userId,
  }) async {
    final data = {
      'sellerId': sellerId,
      'userId': userId,
    };

    final result = await _apiClient.post<ChatModel>(
      ApiConstants.chat.createChat,
      data: data,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return ChatModel.fromJson(json);
        }
        throw Exception('Invalid response format');
      },
    );
    return result;
  }
}
