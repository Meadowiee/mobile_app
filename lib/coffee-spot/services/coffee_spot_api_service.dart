import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_spot_model.dart';
import '../models/spot_check_model.dart';

class CoffeeSpotApiService {
  final String baseUrl = 'http://18.143.199.169:3000';

  Future<List<CoffeeSpot>> getCoffeeSpots(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/coffee-spot'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CoffeeSpot.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load coffee spots. Status: ${response.statusCode}',
      );
    }
  }

  Future<CoffeeSpot> getCoffeeSpotById(String token, String spotId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/coffee-spot/$spotId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return CoffeeSpot.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load coffee spot. Status: ${response.statusCode}',
      );
    }
  }

  Future<SpotCheck> addFavoriteSpot({
    required String userId,
    required String token,
    required String spotId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/coffee-spot/favorite'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'userId': userId, 'spotId': spotId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SpotCheck.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to add favorite spot. Status: ${response.statusCode}',
      );
    }
  }

  Future<List<SpotCheck>> getFavoriteSpots(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/coffee-spot/favorite/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => SpotCheck.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load favorite spots. Status: ${response.statusCode}',
      );
    }
  }

  Future<SpotCheck> editSpotCheck({
    required String token,
    required String spotCheckId,
    required SpotCheckUpdateInput input,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/coffee-spot/favorite/$spotCheckId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(input.toJson()),
    );

    if (response.statusCode == 200) {
      return SpotCheck.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to edit spot check. Status: ${response.statusCode}',
      );
    }
  }

  Future<void> deleteSpotCheck(String token, String spotCheckId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/coffee-spot/favorite/$spotCheckId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete spot check. Status: ${response.statusCode}',
      );
    }
  }
}
