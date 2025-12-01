import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/message_model.dart';
import '../widgets/message_bubble.dart';

class ChatMessageScreen extends StatefulWidget {
  final String participantName;
  final String? participantImage;

  const ChatMessageScreen({
    super.key,
    required this.participantName,
    this.participantImage,
  });

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  late TextEditingController _messageController;
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final ScrollController _scrollController = ScrollController();

  // Demo user ID (replace with actual user ID later)
  static const String _currentUserId = 'user_123';

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _loadDemoMessages();
  }

  void _loadDemoMessages() {
    // Demo messages for now
    final demoMessages = [
      MessageModel(
        id: '1',
        text: 'Hey! How are you?',
        userId: 'other_user_456',
        date: DateTime.now().subtract(const Duration(hours: 2)).toString(),
        read: true,
        user: ChatUser(
          id: 'other_user_456',
          name: widget.participantName,
          role: 'Member',
          avatar: Avatar(publicId: '', url: widget.participantImage ?? ''),
        ),
      ),
      MessageModel(
        id: '2',
        text: 'I\'m doing great! How about you?',
        userId: _currentUserId,
        date: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)).toString(),
        read: true,
        user: ChatUser(
          id: _currentUserId,
          name: 'You',
          role: 'Member',
          avatar: Avatar(publicId: '', url: ''),
        ),
      ),
      MessageModel(
        id: '3',
        text: 'Pretty good! Looking forward to the next match 🎯',
        userId: 'other_user_456',
        date: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)).toString(),
        read: true,
        user: ChatUser(
          id: 'other_user_456',
          name: widget.participantName,
          role: 'Member',
          avatar: Avatar(publicId: '', url: widget.participantImage ?? ''),
        ),
      ),
      MessageModel(
        id: '4',
        text: 'Same! Let\'s practice together sometime',
        userId: _currentUserId,
        date: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)).toString(),
        read: true,
        user: ChatUser(
          id: _currentUserId,
          name: 'You',
          role: 'Member',
          avatar: Avatar(publicId: '', url: ''),
        ),
      ),
    ];

    messages.assignAll(demoMessages);
    Future.delayed(const Duration(milliseconds: 300), _scrollToBottom);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = MessageModel(
      id: DateTime.now().toString(),
      text: _messageController.text.trim(),
      userId: _currentUserId,
      date: DateTime.now().toString(),
      read: false,
      user: ChatUser(
        id: _currentUserId,
        name: 'You',
        role: 'Member',
        avatar: Avatar(publicId: '', url: ''),
      ),
    );

    messages.add(newMessage);
    _messageController.clear();
    _scrollToBottom();
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
                  final isMe = msg.userId == _currentUserId;
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
                    color: AppColors.notificationColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
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
