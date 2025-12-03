import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_spot_model.dart';

class ApiService {
  final String baseUrl = "http://192.168.64.74:3000";
  final String endPoint = "/coffee-spot";

  Future<List<CoffeeSpot>> fetchCoffeeSpots() async {
    final response = await http.get(Uri.parse('$baseUrl$endPoint'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => CoffeeSpot.fromJson(e)).toList();
    } else {
      throw Exception('Failed load Coffee Spots');
    }
  }

  Future<void> createCoffeeSpot(CoffeeSpot coffeeSpot) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endPoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(coffeeSpot.toJson()),
    );
    if (response.statusCode != 201)
      throw Exception('Gagal membuat Coffee Spot');
  }

  Future<void> updateCoffeeSpot(int id, CoffeeSpot coffeeSpot) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endPoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(coffeeSpot.toJson()),
    );
    if (response.statusCode != 200) throw Exception('Gagal update Coffee Spot');
  }

  Future<void> deleteCoffeeSpot(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl$endPoint/$id'));
    if (response.statusCode != 200) throw Exception('Gagal hapus Coffee Spot');
  }
}
