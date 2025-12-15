import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_spot_model.dart';
import '../models/spot_check_model.dart';

class CoffeeSpotApiService {
  final String baseUrl = 'http://13.251.130.212:3000';
  final token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIyNTQ0ZWRjLWEzOTItNDEwZS05NmQ3LTU4ZDJkMzc3NGQ5ZiIsImVtYWlsIjoic2hhZmluYWFyZGVsaWEwQGdtYWlsLmNvbSIsImlhdCI6MTc2NTEyNjk3MSwiZXhwIjoxNzY3NzE4OTcxfQ.Rn31Mvmz37rGLP1ojc89BsPX27x_AsWFmvRvoSOuas0';
  final user_Id = 'b2544edc-a392-410e-96d7-58d2d3774d9f';

  Future<List<CoffeeSpot>> getCoffeeSpots() async {
    // put the bearer token in the header
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

  Future<CoffeeSpot> getCoffeeSpotById(String spotId) async {
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
    required String spotId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/coffee-spot/favorite'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'userId': user_Id, 'spotId': spotId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SpotCheck.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to add favorite spot. Status: ${response.statusCode}',
      );
    }
  }

  Future<List<SpotCheck>> getFavoriteSpots(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/coffee-spot/favorite/$user_Id'),
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

  Future<void> deleteSpotCheck(String spotCheckId) async {
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
