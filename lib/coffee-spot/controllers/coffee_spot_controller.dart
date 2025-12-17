import 'package:get/get.dart';
import '../services/coffee_spot_api_service.dart';
import '../models/coffee_spot_model.dart';
import '../models/spot_check_model.dart';

const String currentUserId = "683f20f1-e97a-4483-af5c-bafeb3355d7a";

class CoffeeSpotController extends GetxController {
  final CoffeeSpotApiService _apiService = CoffeeSpotApiService();

  // Lists
  var allCoffeeSpotList = <CoffeeSpot>[].obs;
  var filteredCoffeeSpotList = <CoffeeSpot>[].obs;
  var favoriteSpotList = <SpotCheck>[].obs;
  var recentSpotList = <SpotCheck>[].obs;

  // States
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var placeholderImage = 'assets/images/coffee-placeholder.jpg';

  @override
  void onInit() {
    fetchAllData();
    super.onInit();
  }

  Future<void> fetchAllData() async {
    isLoading(true);
    errorMessage('');
    try {
      final spots = await _apiService.getCoffeeSpots();
      allCoffeeSpotList.assignAll(spots);
      filteredCoffeeSpotList.assignAll(spots);

      await getFavoriteCoffeeSpots();
    } catch (e) {
      errorMessage('Gagal mengambil data: $e');
      print('Error fetching data: $e');
    } finally {
      isLoading(false);
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
      final favorites = await _apiService.getFavoriteSpots(currentUserId);
      favoriteSpotList.assignAll(favorites);

      getRecentCoffeeSpots();
    } catch (e) {
      print('Error fetching favorite spots: $e');
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

      SpotCheck updatedSpotCheck;

      if (existingSpotCheck != null) {
        final newVisitCount = existingSpotCheck.visitCount + 1;
        final updateInput = SpotCheckUpdateInput(
          lastVisit: DateTime.now(),
          visitCount: newVisitCount,
        );

        updatedSpotCheck = await _apiService.editSpotCheck(
          spotCheckId: existingSpotCheck.id,
          input: updateInput,
        );
      } else {
        updatedSpotCheck = await _apiService.addFavoriteSpot(
          userId: currentUserId,
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
      print('Check-in error: $e');
    }
  }

  // delete a spot check
  Future<void> deleteCheckIn(String spotCheckId) async {
    try {
      await _apiService.deleteSpotCheck(spotCheckId);

      favoriteSpotList.removeWhere((spotCheck) => spotCheck.id == spotCheckId);

      getRecentCoffeeSpots();
    } catch (e) {
      print('Delete check-in error: $e');
    }
  }
}
