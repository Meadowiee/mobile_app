import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/room_chat_controller.dart';

class RecommendedRoomDetailPage extends StatelessWidget {
  final String roomId;

  const RecommendedRoomDetailPage({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RoomChatController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Room Detail")),
      body: Obx(() {
        final room = controller.recommendedRooms
            .firstWhere((r) => r['id'] == roomId);

        final isPending = room['status'] == 'pending';

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                room['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),

              Text(
                room['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                room['desc'],
                style: TextStyle(color: Colors.grey.shade700),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isPending
                      ? null
                      : () => controller.requestJoinDummy(roomId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isPending ? Colors.grey : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    isPending ? "Pending" : "Request to Join",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
