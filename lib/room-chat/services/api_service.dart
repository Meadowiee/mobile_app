import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/utils/session_manager.dart';

class ApiService {
  static const String baseUrl = "http://18.143.199.169:3000";

  /// Ambil token dari SessionManager (AUTH TIM)
  static Future<Map<String, String>> _headers() async {
    final token = await SessionManager().getToken();

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<http.Response> get(String endpoint) async {
    return await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
    );
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    return await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
    );
  }
}
