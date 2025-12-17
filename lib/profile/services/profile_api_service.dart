import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';

class ProfileApiService {
  final String baseUrl = "http://18.143.199.169:3000";

  // GET detail user
  Future<Profile> fetchProfileById(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/detail/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['profileImage'] != null &&
          json['profileImage'].toString().startsWith('/')) {
        json['profileImage'] = baseUrl + json['profileImage'];
      }
      return Profile.fromJson(json);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  // UPDATE profile
  Future<bool> updateProfile(
    String userId,
    String token,
    Profile profile, {
    String? profileImage,
  }) async {
    final url = Uri.parse("$baseUrl/users/detail/$userId");
    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';
    if (profile.name != null) request.fields['name'] = profile.name!;
    if (profile.username.isNotEmpty)
      request.fields['username'] = profile.username;
    if (profile.email != null) request.fields['email'] = profile.email!;
    if (profile.region != null) request.fields['region'] = profile.region!;
    if (profile.sex != null) request.fields['sex'] = profile.sex!;

    if (profileImage != null && profileImage.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('profileImage', profileImage),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return true;
    } else {
      final errorBody = jsonDecode(response.body);
      throw errorBody;
    }
  }

  // CHANGE password
  Future<bool> changePassword({
    required String userId,
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse("$baseUrl/users/change-password/$userId");
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
      final errorBody = jsonDecode(response.body);
      throw errorBody;
    }
  }
}
