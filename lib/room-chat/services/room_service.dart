import 'dart:convert';
import '../services/api_service.dart';

class RoomService {
  /// ================= ROOMS =================

  /// SEMUA ROOM (RECOMMENDED)
  static Future<List<dynamic>> getAllRooms() async {
    final res = await ApiService.get("/rooms");

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to fetch rooms");
    }
  }

  /// ROOM YANG DIIKUTI USER
  static Future<List<dynamic>> getMyRooms() async {
    final res = await ApiService.get("/rooms/my-rooms");

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to fetch my rooms");
    }
  }

  /// JOIN ROOM (REQUEST)
  static Future<void> joinRoom(String roomId) async {
    final res = await ApiService.post("/rooms/join/$roomId", {});

    if (res.statusCode != 201) {
      throw Exception("Failed to join room");
    }
  }

  /// DELETE ROOM (OWNER)
  static Future<void> deleteRoom(String roomId) async {
    final res = await ApiService.delete("/rooms/$roomId");

    if (res.statusCode != 200) {
      throw Exception("Failed to delete room");
    }
  }

  /// ================= REQUESTS =================

  /// GET JOIN REQUESTS (OWNER)
  static Future<List<dynamic>> getJoinRequests(String roomId) async {
    final res = await ApiService.get("/rooms/requests/$roomId");

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to fetch join requests");
    }
  }

  /// APPROVE JOIN REQUEST
  static Future<void> approveJoinRequest(String requestId) async {
    final res = await ApiService.put(
      "/rooms/requests/approve/$requestId",
      {},
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to approve join request");
    }
  }

  /// REJECT JOIN REQUEST (PENDING)
  static Future<void> rejectJoinRequest(String requestId) async {
    final res = await ApiService.delete(
      "/rooms/requests/reject/$requestId",
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to reject join request");
    }
  }

  /// ================= DETAIL =================

  static Future<Map<String, dynamic>> getRoomDetail(String roomId) async {
    final res = await ApiService.get("/rooms/detail/$roomId");

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to fetch room detail");
    }
  }

  /// ================= MEMBERS =================

  /// REMOVE MEMBER (KICK)
  static Future<void> removeMember(String participantId) async {
    final res = await ApiService.delete(
      "/rooms/remove-member/$participantId",
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to remove member");
    }
  }
}
