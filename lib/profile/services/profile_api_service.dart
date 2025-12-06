import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';

class ProfileApiService {
  final String baseUrl = "http://192.168.18.23:3000";

  // GET detail user
  Future<Profile> fetchProfileById(String userId) async {
    final url = Uri.parse("$baseUrl/users/detail/$userId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load profile");
    }
  }

  // UPDATE profile
  Future<bool> updateProfile(String userId, Profile profile) async {
    final url = Uri.parse("$baseUrl/users/detail/$userId");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to update profile");
    }
  }

  // Future<void> updateProfileImage(int userId, String filePath) async {
  //   final uri = Uri.parse("$baseUrl/profile/upload_image/$userId");

  //   var request = http.MultipartRequest('POST', uri);
  //   request.files.add(await http.MultipartFile.fromPath('file', filePath));

  //   final response = await request.send();

  //   if (response.statusCode != 200) {
  //     throw Exception("Failed to upload image");
  //   }
  // }

  // CHANGE password
  Future<bool> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse("$baseUrl/users/change-password/$userId");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to change password");
    }
  }
}
