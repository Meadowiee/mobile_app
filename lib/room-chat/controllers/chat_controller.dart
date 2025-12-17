import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/chat_service.dart';
import '../services/chat_socket_service.dart';

class ChatController extends GetxController {
  final Map roomDetail;

  ChatController(this.roomDetail);

  // ================= CONTROLLERS =================
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // ================= STATE =================
  final RxList<dynamic> messages = <dynamic>[].obs;
  final RxBool isAdminMode = false.obs;

  // ================= GETTERS =================
  String get roomId => roomDetail['id'];
  String? get myUserId => roomDetail['myUserId'];

  bool get isOwner {
    final createdBy = roomDetail['createdBy'];
    if (createdBy == null || myUserId == null) return false;
    return createdBy['id'] == myUserId;
  }

  // ================= LIFECYCLE =================
  @override
  void onInit() {
    super.onInit();
    loadChatHistory();
    connectSocket();
  }

  // ================= SOCKET =================
  void connectSocket() {
    ChatSocketService.connect(
      roomId: roomId,
      onReceive: (data) {
        if (data == null) return;

        final senderId = data['sender']?['id'];

        // cegah duplicate message dari diri sendiri
        if (senderId == myUserId) return;

        messages.add(data);
        scrollToBottom();
      },
    );
  }

  // ================= CHAT =================
  Future<void> loadChatHistory() async {
    try {
      final history = await ChatService.getRoomChats(roomId);
      messages.assignAll(history);
      scrollToBottom();
    } catch (e) {
      debugPrint("Load chat history error: $e");
    }
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // optimistic UI
    final tempMessage = {
      'message': text,
      'sender': {
        'id': myUserId,
        'name': 'You',
      },
      'createdAt': DateTime.now().toIso8601String(),
    };

    messages.add(tempMessage);

    ChatSocketService.sendMessage(
      roomId: roomId,
      message: text,
    );

    messageController.clear();
    scrollToBottom();
  }

  // ================= ADMIN =================
  void toggleAdminMode() {
    isAdminMode.value = !isAdminMode.value;
  }

  // ================= UI HELPERS =================
  void scrollToBottom() {
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

  // ================= CLEANUP =================
  @override
  void onClose() {
    ChatSocketService.disconnect();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
