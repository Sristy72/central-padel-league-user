import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/services/auth_storage_service.dart';
// import '../data/message_repository.dart';  // TODO: Uncomment when API is ready
import '../data/models/message_model.dart';

class MessageController extends GetxController {
  // final MessageRepository _repository = MessageRepository();  // TODO: Uncomment when API is ready
  final AuthStorageService _authStorageService = AuthStorageService();
  late String currentUserId;

  var messages = <MessageModel>[].obs;
  var messageInput = ''.obs;
  var isSending = false.obs;
  late String chatId;

  /// Scroll controller for auto-scroll
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    // Get user ID from secure storage
    final userId = await _authStorageService.getUserId();
    currentUserId = userId ?? 'default_user_id';
  }

  Future<void> init(String id) async {
    chatId = id;

    // Load current user ID first
    await _loadCurrentUserId();

    // Clear messages for fresh load
    messages.clear();

    loadMessages();
  }

  void reloadMessages() {
    print('🔄 Reloading messages for chat: $chatId');
    loadMessages(); // Refresh messages from the API
  }

  void loadMessages() async {
    print('📡 Fetching messages for chat: $chatId');
    // TODO: Uncomment when API is ready
    // final result = await _repository.fetchMessages(chatId);
    // result.fold(
    //   (failure) {
    //     print('❌ Failed to fetch messages: ${failure.message ?? 'Unknown error'}');
    //     Get.snackbar("Error", failure.message ?? 'Failed to load messages');
    //   },
    //   (data) {
    //     print('✅ Loaded ${data.length} messages');
    //     messages.assignAll(data);
    //     _scrollToBottom();
    //   },
    // );
  }

  void sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    isSending.value = true;

    // TODO: Uncomment when API is ready
    // final result = await _repository.sendMessage(
    //   chatId: chatId,
    //   message: message.trim(),
    // );
    // result.fold(
    //   (failure) => Get.snackbar("Error", failure.message ?? 'Failed to send message'),
    //   (data) {
    //     messages.assignAll(data);
    //     messageInput.value = '';
    //     _scrollToBottom();
    //   },
    // );

    isSending.value = false;
  }

  void _cacheMessages() {
    // Caching is skipped for now; implement if needed
  }

  // TODO: Use this when API is implemented
  // void _scrollToBottom() {
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     if (scrollController.hasClients) {
  //       scrollController.jumpTo(scrollController.position.minScrollExtent);
  //     }
  //   });
  // }

  @override
  void onClose() {
    _cacheMessages();
    scrollController.dispose();
    super.onClose();
  }
}
