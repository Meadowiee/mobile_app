import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../services/profile_api_service.dart';

class ProfileController extends GetxController {
  final ProfileApiService apiService = ProfileApiService();

  var profile = Rx<Profile?>(null);
  var isLoading = false.obs;

  // Versi 1: tanpa login (dummy)
  final String dummyUserId = "b2544edc-a392-410e-96d7-58d2d3774d9f";

  // Versi 2: kalau sudah login via token
  String? loggedInUserId;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  // Memilih mana yang dipakai: login / dummy
  String get activeUserId => loggedInUserId ?? dummyUserId;

  // Load profile
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final data = await apiService.fetchProfileById(activeUserId);
      profile.value = data;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile
  Future<void> updateProfile(Profile newProfile) async {
    try {
      await apiService.updateProfile(activeUserId, newProfile);
      loadProfile(); // refresh
      Get.snackbar("Success", "Profile updated");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Future<void> updateProfileImage(String filePath) async {
  //   try {
  //     await apiService.updateProfileImage(activeUserId, filePath);
  //     await loadProfile();
  //     Get.snackbar("Success", "Profile image updated");
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   }
  // }

  // Change password
  Future<void> changePassword(String oldPass, String newPass) async {
    try {
      await apiService.changePassword(
        userId: activeUserId,
        oldPassword: oldPass,
        newPassword: newPass,
      );
      Get.snackbar("Success", "Password updated");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
