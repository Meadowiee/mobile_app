import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';

class ProfileApiService {
  final String baseUrl = "http://13.251.130.212:3000";

  final token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIyNTQ0ZWRjLWEzOTItNDEwZS05NmQ3LTU4ZDJkMzc3NGQ5ZiIsImVtYWlsIjoic2hhZmluYWFyZGVsaWEwQGdtYWlsLmNvbSIsImlhdCI6MTc2NTEyNjk3MSwiZXhwIjoxNzY3NzE4OTcxfQ.Rn31Mvmz37rGLP1ojc89BsPX27x_AsWFmvRvoSOuas0';
  final user_Id = 'b2544edc-a392-410e-96d7-58d2d3774d9f';

  // GET detail user
  Future<Profile> fetchProfileById(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/detail/$user_Id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load profile");
    }
  }

  // UPDATE profile
  Future<bool> updateProfile(String userId, Profile profile) async {
    final url = Uri.parse("$baseUrl/users/detail/$user_Id");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to update profile");
    }
  }

  // Future<void> updateProfileImage(int userId, String filePath) async {
  //   final uri = Uri.parse("$baseUrl/profile/upload_image/$user_Id");

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
    final url = Uri.parse("$baseUrl/users/change-password/$user_Id");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
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

  // UPDATE image profile
}
