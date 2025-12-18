import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/room_service.dart';
import '../services/room_detail_service.dart';
import '../../utils/session_manager.dart';

class RoomChatController extends GetxController {
  /// ================= STATE =================
  var loadingMyRooms = true.obs;
  var loadingRecommended = true.obs;

  var myRooms = <Map<String, dynamic>>[].obs;
  var recommendedRooms = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyRooms();
    fetchRecommendedRooms();
  }

  /// ================= MY ROOMS =================
  Future<void> fetchMyRooms() async {
    try {
      loadingMyRooms.value = true;

      final rooms = await RoomService.getMyRooms();

      myRooms.assignAll(
        rooms.map<Map<String, dynamic>>((r) => {
          "id": r['id'],
          "name": r['name'],
          "description": r['description'] ?? '',
          "profileImage": r['profileImage'],
        }).toList(),
      );
    } catch (e) {
      debugPrint("FETCH MY ROOMS ERROR: $e");
    } finally {
      loadingMyRooms.value = false;
    }
  }

  /// ================= RECOMMENDED ROOMS =================
  Future<void> fetchRecommendedRooms() async {
    try {
      loadingRecommended.value = true;

      final allRooms = await RoomService.getAllRooms();
      final myRoomIds = myRooms.map((r) => r['id']).toSet();

      recommendedRooms.assignAll(
        allRooms
            .where((r) => !myRoomIds.contains(r['id']))
            .map<Map<String, dynamic>>((r) => {
          "id": r['id'],
          "name": r['name'],
          "description": r['description'] ?? "",
          "profileImage": r['profileImage'],
          "status": r['joinStatus'] ?? "join", // join | pending
        })
            .toList(),
      );
    } catch (e) {
      debugPrint("FETCH RECOMMENDED ERROR: $e");
    } finally {
      loadingRecommended.value = false;
    }
  }

  /// ================= REQUEST JOIN =================
  Future<void> requestJoin(String roomId) async {
    try {
      await RoomService.joinRoom(roomId);

      final index =
      recommendedRooms.indexWhere((r) => r['id'] == roomId);

      if (index != -1) {
        recommendedRooms[index]['status'] = 'pending';
        recommendedRooms.refresh();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to request join");
    }
  }

  /// ================= OPEN ROOM =================
  Future<Map<String, dynamic>> openRoom(String roomId) async {
    final detail = await RoomDetailService.getRoomDetail(roomId);
    final myUserId = await SessionManager().getUserId();

    return {
      ...detail,
      'myUserId': myUserId,
    };
  }
}
