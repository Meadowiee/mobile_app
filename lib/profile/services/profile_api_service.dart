import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';

class ProfileApiService {
  final String baseUrl = "http://192.168.64.74:3000";
  final String endPoint = "/users";

  // get profile by id
  Future<Profile> fetchProfileById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl$endPoint/$id'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Profile.fromJson(data);
    } else {
      throw Exception('Failed load Profile');
    }
  }

  // update profile
  Future<void> updateProfile(String id, Profile profile) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endPoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile.toJson()),
    );
    if (response.statusCode != 200) throw Exception('Gagal update Profile');
  }
}
