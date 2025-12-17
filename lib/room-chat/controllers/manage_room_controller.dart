import 'package:get/get.dart';
import '../services/room_service.dart';
import 'room_chat_controller.dart';

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

  Future<void> fetchManageRoom() async {
    try {
      loading.value = true;

      final requests = await RoomService.getJoinRequests(roomId);
      final detail = await RoomService.getRoomDetail(roomId);

      joinRequests.assignAll(requests);
      members.assignAll(detail['participants'] ?? []);
    } catch (_) {
      Get.snackbar("Error", "Failed to load room data");
    } finally {
      loading.value = false;
    }
  }

  /* ================= JOIN REQUEST ================= */

  Future<void> approve(String requestId) async {
    await RoomService.approveJoinRequest(requestId);
    fetchManageRoom();
  }

  Future<void> reject(String requestId) async {
    await RoomService.rejectJoinRequest(requestId);
    fetchManageRoom();
  }

  /* ================= REALTIME REMOVE MEMBER ================= */

  Future<void> removeMember(String participantId) async {
    // backup untuk rollback
    final backupMembers = List.from(members);

    // 1️⃣ REALTIME UI → langsung hapus dari list
    members.removeWhere((m) => m['id'] == participantId);

    try {
      // 2️⃣ HIT API
      await RoomService.removeMember(participantId);

      // 3️⃣ JIKA MEMBER HABIS → DELETE ROOM
      if (members.isEmpty) {
        await RoomService.deleteRoom(roomId);

        // hapus room dari list utama (REALTIME)
        final roomChatController = Get.find<RoomChatController>();
        roomChatController.myRooms
            .removeWhere((r) => r['id'] == roomId);

        // tutup halaman
        Get.back(); // ManageRoomPage
        Get.back(); // GroupChatPage

        Get.snackbar(
          "Room Deleted",
          "Room deleted because no members left",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // 4️⃣ ROLLBACK JIKA ERROR
      members.assignAll(backupMembers);

      Get.snackbar(
        "Error",
        "Failed to remove member",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /* ================= DELETE ROOM MANUAL ================= */

  Future<void> deleteRoom() async {
    await RoomService.deleteRoom(roomId);

    // realtime hapus dari list
    Get.find<RoomChatController>()
        .myRooms
        .removeWhere((r) => r['id'] == roomId);

    Get.back(); // ManageRoomPage
    Get.back(); // GroupChatPage
  }
}
