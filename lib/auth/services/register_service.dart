import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/register_model.dart';

class RegisterService {
  static const String baseUrl = "http://18.143.199.169:3000";

  Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String email,
    required String password,
    String? region,
    String? sex,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$baseUrl/register');
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = name;
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;

    if (region != null && region.isNotEmpty) {
      request.fields['region'] = region;
    }

    if (sex != null && sex.isNotEmpty) {
      request.fields['sex'] = sex;
    }

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profileImage', imageFile.path),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      Map<String, dynamic> body;
      try {
        body = jsonDecode(response.body);
      } catch (_) {
        return {"success": false, "message": "Response is not valid JSON"};
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "data": Register.fromJson(body)};
      }

      if (response.statusCode == 400) {
        return {
          "success": false,
          "errors": body['errors'] ?? {"global": "Validation error"},
        };
      }

      return {"success": false, "message": body['message'] ?? "Server Error"};
    } catch (e) {
      return {"success": false, "message": "Connection Error: $e"};
    }
  }
}
