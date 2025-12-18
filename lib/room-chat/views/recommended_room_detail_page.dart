import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/room_chat_controller.dart';

import 'room_chat_page.dart'; // for baseUrl

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
            .firstWhere((r) => r['id'] == roomId, orElse: () => {});

        if (room.isEmpty) {
          return const Center(child: Text("Room not found"));
        }

        final isPending = room['status'] == 'pending';
        final imagePath = room['image'];

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade200,
                  image: imagePath != null
                      ? DecorationImage(
                    image: NetworkImage("$baseUrl$imagePath"),
                    fit: BoxFit.cover,
                  )
                      : const DecorationImage(
                    image: AssetImage("assets/images/download (5).jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                room['name'] ?? "Unknown Room",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                "${room['participantsCount']} Members",
                style: TextStyle(
                  color: Get.theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                room['desc'] ?? "No description available.",
                style: TextStyle(color: Colors.grey.shade700, height: 1.5),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isPending
                      ? null
                      : () => controller.requestJoin(roomId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isPending ? Colors.grey : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isPending ? "Request Pending" : "Request to Join",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
