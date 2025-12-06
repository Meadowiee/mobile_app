import 'package:get/get.dart';
import '../models/coffee_spot_model.dart';
import '../services/api_service.dart';

class CoffeeSpotController extends GetxController {
  final ApiService apiService = ApiService();

  var coffeeSpotList = <CoffeeSpot>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchAllCoffeeSpots();
    super.onInit();
  }

  void fetchAllCoffeeSpots() async {
    try {
      isLoading.value = true;
      final data = await apiService.fetchCoffeeSpots();
      coffeeSpotList.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void addCoffeeSpot(CoffeeSpot coffeeSpot) async {
    try {
      await apiService.createCoffeeSpot(coffeeSpot);
      fetchAllCoffeeSpots();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void editCoffeeSpot(int id, CoffeeSpot coffeeSpot) async {
    try {
      await apiService.updateCoffeeSpot(id, coffeeSpot);
      fetchAllCoffeeSpots();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void removeCoffeeSpot(String id) async {
    try {
      await apiService.deleteCoffeeSpot(id);
      fetchAllCoffeeSpots();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
