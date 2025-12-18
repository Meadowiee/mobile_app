import 'package:get/get.dart';
import '../services/room_service.dart';
import '../controllers/room_chat_controller.dart';
import 'package:flutter/material.dart';

class ManageRoomController extends GetxController {
  final String roomId;

  ManageRoomController(this.roomId);

  var loading = true.obs;
  var joinRequests = <dynamic>[].obs;
  var members = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchManageRoom();
  }

  /// ================= LOAD DATA =================
  Future<void> fetchManageRoom() async {
    try {
      loading.value = true;

      final requests = await RoomService.getJoinRequests(roomId);
      final detail = await RoomService.getRoomDetail(roomId);

      joinRequests.assignAll(requests);
      members.assignAll(detail['participants'] ?? []);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load manage room data",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      loading.value = false;
    }
  }

  /// ================= REQUEST =================

  /// APPROVE JOIN REQUEST (PAKAI requestId)
  Future<void> approve(String requestId) async {
    try {
      await RoomService.approveJoinRequest(requestId);
      fetchManageRoom();
    } catch (e) {
      Get.snackbar("Error", "Failed to approve request");
    }
  }

  /// REJECT JOIN REQUEST (PAKAI requestId)
  Future<void> reject(String requestId) async {
    try {
      await RoomService.rejectJoinRequest(requestId);
      fetchManageRoom();
    } catch (e) {
      Get.snackbar("Error", "Failed to reject request");
    }
  }

  /// ================= MEMBERS =================

  /// REMOVE MEMBER (PAKAI participantId)
  Future<void> removeMember(String participantId) async {
    try {
      await RoomService.removeMember(participantId);
      fetchManageRoom();
    } catch (e) {
      Get.snackbar("Error", "Failed to remove member");
    }
  }

  /// ================= DELETE ROOM =================
  Future<void> deleteRoom() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete Room"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await RoomService.deleteRoom(roomId);

      /// refresh room list
      if (Get.isRegistered<RoomChatController>()) {
        Get.find<RoomChatController>().fetchMyRooms();
      }

      Get.back(); // close ManageRoomPage
      Get.back(); // close GroupChatPage
    } catch (e) {
      Get.snackbar("Error", "Failed to delete room");
    }
  }
}
