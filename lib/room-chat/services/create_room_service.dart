import 'dart:io';
import 'package:http/http.dart' as http;
import '../../utils/session_manager.dart';

class CreateRoomService {
  static const String baseUrl = "http://18.143.199.169:3000";

  /// CREATE ROOM (WITH IMAGE)
  static Future<bool> createRoom({
    required String name,
    required String description,
    required int maxMember,
    File? image,
  }) async {
    final token = await SessionManager().getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final uri = Uri.parse("$baseUrl/rooms");
    final request = http.MultipartRequest("POST", uri);

    request.headers["Authorization"] = "Bearer $token";

    request.fields["name"] = name;
    request.fields["description"] = description;
    request.fields["maxMember"] = maxMember.toString();

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "profileImage",
          image.path,
        ),
      );
    }

    final response = await request.send();

    return response.statusCode == 201;
  }
}
