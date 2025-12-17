import 'dart:convert';
import '../services/api_service.dart';

class ChatService {
  /// GET CHAT HISTORY
  static Future<List<dynamic>> getRoomChats(
      String roomId, {
        int page = 1,
        int limit = 50,
      }) async {
    final response = await ApiService.get(
      "/chats/room/$roomId?page=$page&limit=$limit",
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data']; // backend: { meta, data }
    } else {
      throw Exception("Failed to fetch chat history");
    }
  }

  /// DELETE CHAT (OWNER)
  static Future<void> deleteChat(String chatId) async {
    final response = await ApiService.delete("/chats/$chatId");

    if (response.statusCode != 200) {
      throw Exception("Failed to delete chat");
    }
  }
}
