import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/chat_repository.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';
import '../widgets/message_bubble.dart';

class ChatMessageScreen extends StatefulWidget {
  final String participantName;
  final String? participantImage;
  final ChatModel? chatModel;
  final String? currentUserId;

  const ChatMessageScreen({
    super.key,
    required this.participantName,
    this.participantImage,
    this.chatModel,
    this.currentUserId,
  });

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  late TextEditingController _messageController;
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  late ChatRepository _chatRepository;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _chatRepository = ChatRepository();
    _initializeMessages();
  }

  void _initializeMessages() {
    // Load messages from ChatModel if provided
    if (widget.chatModel != null && widget.chatModel!.messages.isNotEmpty) {
      // Convert ChatMessageModel to MessageModel
      final convertedMessages = widget.chatModel!.messages.map((msg) {
        return MessageModel(
          id: msg.id,
          text: msg.text,
          userId: msg.user.id,
          date: msg.date,
          read: msg.read,
          user: ChatUser(
            id: msg.user.id,
            name: msg.user.name,
            role: msg.user.role,
            avatar: Avatar(publicId: '', url: ''),
          ),
        );
      }).toList();
      messages.assignAll(convertedMessages);
    }
    Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSending) return;
    if (widget.chatModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Chat not initialized'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final result = await _chatRepository.sendMessage(
        chatId: widget.chatModel!.id,
        message: _messageController.text.trim(),
      );

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send message: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        (messageData) {
          // Convert the API response to MessageModel and add to list
          final newMessage = MessageModel(
            id: messageData.id,
            text: messageData.text,
            userId: messageData.user.id,
            date: messageData.date,
            read: messageData.read,
            user: ChatUser(
              id: messageData.user.id,
              name: messageData.user.name,
              role: messageData.user.role,
              avatar: Avatar(publicId: '', url: ''),
            ),
          );
          
          messages.add(newMessage);
          _messageController.clear();
          
          // Use Future.delayed to ensure ListView has been rebuilt with new message
          Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.participantImage != null &&
                      widget.participantImage!.isNotEmpty
                  ? NetworkImage(widget.participantImage!)
                  : const AssetImage('assets/images/profile.png') as ImageProvider,
              backgroundColor: Colors.grey[800],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.participantName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Obx(() {
              if (messages.isEmpty) {
                return const Center(
                  child: Text(
                    'No messages yet. Start the conversation!',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final msg = messages[index];
                  // Check if message belongs to current user by comparing user ID
                  final isMe = widget.currentUserId != null && msg.userId == widget.currentUserId;
                  return MessageBubble(message: msg, isMe: isMe);
                },
              );
            }),
          ),
          // Message input
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            color: Colors.black,
            child: Row(
              children: [
                // Add button
                
                const SizedBox(width: 8),
                // Message input field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send button
                Container(
                  decoration: BoxDecoration(
                    color: _isSending ? Colors.grey : AppColors.notificationColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _isSending ? null : _sendMessage,
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonText),
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: AppColors.buttonText,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
