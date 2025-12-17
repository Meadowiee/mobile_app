import 'dart:convert';
import '../services//api_service.dart';

class RoomDetailService {
  /// GET ROOM DETAIL
  static Future<Map<String, dynamic>> getRoomDetail(String roomId) async {
    final res = await ApiService.get("/rooms/detail/$roomId");

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to fetch room detail");
    }
  }
}
