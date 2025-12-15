import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';
import 'dart:io';

class ProfileApiService {
  static const bool local = true;
  final String baseUrl = local
      ? "http://192.168.18.23:3000"
      : "http://13.251.130.212:3000";

  final token = local
      ? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjJkZjE3MzhlLWE5YTQtNDQ0Zi04NWY2LTRjOWVmZDFiM2MwYSIsImVtYWlsIjoieWVsbG93QGdtYWlsLmNvbSIsImlhdCI6MTc2NTc2NjU5NywiZXhwIjoxNzY4MzU4NTk3fQ.XVpvf760LO52gVhLHkUBCU8l6aHZGtmh_gbiLVKHcKU'
      : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIyNTQ0ZWRjLWEzOTItNDEwZS05NmQ3LTU4ZDJkMzc3NGQ5ZiIsImVtYWlsIjoic2hhZmluYWFyZGVsaWEwQGdtYWlsLmNvbSIsImlhdCI6MTc2NTEyNjk3MSwiZXhwIjoxNzY3NzE4OTcxfQ.Rn31Mvmz37rGLP1ojc89BsPX27x_AsWFmvRvoSOuas0';
  final user_Id = local
      ? '2df1738e-a9a4-444f-85f6-4c9efd1b3c0a'
      : 'b2544edc-a392-410e-96d7-58d2d3774d9f';

  // GET detail user
  Future<Profile> fetchProfileById(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/detail/$user_Id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['profileImage'] != null &&
          json['profileImage'].toString().startsWith('/')) {
        json['profileImage'] = baseUrl + json['profileImage'];
      }
      print('here is the image ${json['profileImage']}');
      return Profile.fromJson(json);
    } else {
      throw Exception("Failed to load profile");
    }
  }

  // UPDATE profile
  Future<bool> updateProfile(
    String userId,
    Profile profile, {
    String? profileImage,
  }) async {
    final url = Uri.parse("$baseUrl/users/detail/$user_Id");
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
      final errorBody = jsonDecode(response.body);
      throw errorBody;
    }
  }

  // UPDATE image profile
}
