import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_model.dart'; // Pastikan model Login kamu ada di sini

class AuthService {
  // IP Server kamu (sesuai snippet yang kamu kirim)
  static const String baseUrl = "http://18.143.199.169:3000";

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    var uri = Uri.parse('$baseUrl/auth');

    try {
      var response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username, // 2. Kirim key 'username' ke backend
          "password": password,
        }),
      );

      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "data": LoginResponse.fromJson(body)};
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        return {
          "success": false,
          "message": body['message'] ?? "Username atau Password salah",
        };
      } else {
        return {
          "success": false,
          "message": body['message'] ?? "Terjadi kesalahan server",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Koneksi Error: $e"};
    }
  }
}
