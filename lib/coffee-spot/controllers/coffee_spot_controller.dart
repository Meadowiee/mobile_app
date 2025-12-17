import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/coffee_spot_api_service.dart';
import '../models/coffee_spot_model.dart';
import '../models/spot_check_model.dart';
import '../../utils/session_manager.dart';

class CoffeeSpotController extends GetxController {
  final CoffeeSpotApiService _apiService = CoffeeSpotApiService();
  final SessionManager sessionManager = SessionManager();

  var allCoffeeSpotList = <CoffeeSpot>[].obs;
  var filteredCoffeeSpotList = <CoffeeSpot>[].obs;
  var favoriteSpotList = <SpotCheck>[].obs;
  var recentSpotList = <SpotCheck>[].obs;

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var placeholderImage = 'assets/images/coffee-placeholder.jpg';

  @override
  void onInit() {
    fetchAllData();
    super.onInit();
  }

  Future<void> fetchAllData() async {
    isLoading = true.obs;
    errorMessage('');
    try {
      String? token = await sessionManager.getToken();
      print('Im here after $token');

      if (token != null) {
        final spots = await _apiService.getCoffeeSpots(token);
        allCoffeeSpotList.assignAll(spots);
        filteredCoffeeSpotList.assignAll(spots);
        await getFavoriteCoffeeSpots();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Sorry, something went wrong.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false.obs;
    }
  }

  // filter coffee spots by name or address
  void filterCoffeeSpots(String query) {
    if (query.isEmpty) {
      filteredCoffeeSpotList.assignAll(allCoffeeSpotList);
    } else {
      // sort by alphabetical order
      allCoffeeSpotList.sort((a, b) => a.name.compareTo(b.name));
      final lowerCaseQuery = query.toLowerCase();
      final filtered = allCoffeeSpotList.where((spot) {
        return spot.name.toLowerCase().contains(lowerCaseQuery) ||
            (spot.address?.toLowerCase().contains(lowerCaseQuery) ?? false);
      }).toList();
      filteredCoffeeSpotList.assignAll(filtered);
    }
  }

  // get favorite coffee spots for current user
  Future<void> getFavoriteCoffeeSpots() async {
    try {
      String? userId = await sessionManager.getUserId();
      String? token = await sessionManager.getToken();

      if (userId != null && token != null) {
        final favorites = await _apiService.getFavoriteSpots(userId, token);
        favoriteSpotList.assignAll(favorites);
        getRecentCoffeeSpots();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Sorry, something went wrong.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // get recent coffee spots sorted by visitCount (highest to lowest)
  void getRecentCoffeeSpots() {
    final sortedList = [...favoriteSpotList];
    sortedList.sort((a, b) => b.visitCount.compareTo(a.visitCount));

    recentSpotList.assignAll(sortedList.take(5));
  }

  // check in to a coffee spot
  Future<void> checkInToSpot(String spotId) async {
    try {
      final existingSpotCheck = favoriteSpotList.firstWhereOrNull(
        (spotCheck) => spotCheck.spotId == spotId,
      );

      String? token = await sessionManager.getToken();
      String? userId = await sessionManager.getUserId();

      SpotCheck updatedSpotCheck;

      if (existingSpotCheck != null && token != null) {
        final newVisitCount = existingSpotCheck.visitCount + 1;
        final updateInput = SpotCheckUpdateInput(
          lastVisit: DateTime.now(),
          visitCount: newVisitCount,
        );

        updatedSpotCheck = await _apiService.editSpotCheck(
          token: token,
          spotCheckId: existingSpotCheck.id,
          input: updateInput,
        );
      } else if (userId != null && token != null) {
        updatedSpotCheck = await _apiService.addFavoriteSpot(
          token: token,
          userId: userId,
          spotId: spotId,
        );

        final newSpotDetail = allCoffeeSpotList.firstWhereOrNull(
          (spot) => spot.id == spotId,
        );

        final fullSpotCheck = SpotCheck.fromJson({
          ...updatedSpotCheck.toJson(),
          'spot': newSpotDetail?.toJson(),
        });

        favoriteSpotList.add(fullSpotCheck);
      }

      getFavoriteCoffeeSpots();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Sorry, something went wrong.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // delete a spot check
  Future<void> deleteCheckIn(String spotCheckId) async {
    try {
      String? token = await sessionManager.getToken();
      String? userId = await sessionManager.getUserId();

      if (token != null || userId != null) {
        await _apiService.deleteSpotCheck(token!, spotCheckId);

        favoriteSpotList.removeWhere(
          (spotCheck) => spotCheck.id == spotCheckId,
        );

        getRecentCoffeeSpots();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Sorry, something went wrong.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
