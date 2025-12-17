import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import 'manage_room_page.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';

class GroupChatPage extends StatelessWidget {
  final Map roomDetail;

  const GroupChatPage({
    super.key,
    required this.roomDetail,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController(roomDetail));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          roomDetail['name'] ?? "Room",
          style: const TextStyle(
            fontFamily: "Times New Roman",
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          Obx(() {
            if (!controller.isOwner) return const SizedBox();
            return IconButton(
              icon: Icon(
                controller.isAdminMode.value
                    ? Icons.toggle_on
                    : Icons.toggle_off,
                size: 32,
              ),
              onPressed: controller.toggleAdminMode,
            );
          }),

          Obx(() {
            if (!controller.isOwner || !controller.isAdminMode.value) {
              return const SizedBox();
            }
            return IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ManageRoomPage(roomDetail: roomDetail),
                  ),
                );
              },
            );
          }),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              controller: controller.scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: controller.messages.length,
              itemBuilder: (_, index) {
                final msg = controller.messages[index];
                final isMe =
                    msg['sender']?['id'] == controller.myUserId;

                return ChatBubble(
                  isMe: isMe,
                  username: msg['sender']?['name'] ?? "User",
                  message: msg['message'] ?? "",
                  time: msg['createdAt'],
                );
              },
            )),
          ),

          ChatInput(
            controller: controller.messageController,
            onSend: controller.sendMessage,
          ),
        ],
      ),
    );
  }
}
