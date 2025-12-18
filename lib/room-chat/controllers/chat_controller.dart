import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/chat_service.dart';
import '../services/chat_socket_service.dart';

class ChatController extends GetxController {
  final Map roomDetail;

  ChatController(this.roomDetail);

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final messages = <dynamic>[].obs;
  final isAdminMode = false.obs;
  final isOwner = false.obs; // ✅ SEKARANG Rx

  String get roomId => roomDetail['id'];
  String? get myUserId => roomDetail['myUserId'];

  @override
  void onInit() {
    super.onInit();
    _initOwner();
    loadChatHistory();
    connectSocket();
  }

  void _initOwner() {
    final createdBy = roomDetail['createdBy'];
    if (createdBy != null && myUserId != null) {
      isOwner.value = createdBy['id'] == myUserId;
    }
  }

  void connectSocket() {
    ChatSocketService.connect(
      roomId: roomId,
      onReceive: (data) {
        if (data['sender']?['id'] == myUserId) return;
        messages.add(data);
        _scrollToBottom();
      },
    );
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messages.add({
      'message': text,
      'sender': {
        'id': myUserId,
        'name': 'You',
      },
      'createdAt': DateTime.now().toIso8601String(),
    });

    ChatSocketService.sendMessage(
      roomId: roomId,
      message: text,
    );

    messageController.clear();
    _scrollToBottom();
  }

  Future<void> loadChatHistory() async {
    final history = await ChatService.getRoomChats(roomId);
    messages.assignAll(history);
    _scrollToBottom();
  }

  void toggleAdminMode() {
    isAdminMode.value = !isAdminMode.value;
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    ChatSocketService.disconnect();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
