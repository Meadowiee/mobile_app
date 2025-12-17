import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../services/profile_api_service.dart';

class ProfileController extends GetxController {
  final ProfileApiService apiService = ProfileApiService();

  var validation = RxMap<String, String>({});
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
  Future<void> updateProfile(Profile newProfile, {String? profileImage}) async {
    validation.clear();
    isLoading.value = true;
    try {
      await apiService.updateProfile(
        activeUserId,
        newProfile,
        profileImage: profileImage,
      );
      await loadProfile();
      Get.back();
      Get.snackbar("Success", "Profile updated");
    } catch (e) {
      print(e);
      if (e is Map<String, dynamic> &&
          e['statusCode'] == 422 &&
          e['data'] != null) {
        print(e);
        final data = e['data'] as Map<String, dynamic>;

        data.forEach((fieldKey, errorDetail) {
          if (errorDetail is Map<String, dynamic> &&
              errorDetail['message'] != null) {
            validation[fieldKey] = errorDetail['message'];
          }
        });
        print(validation);
      } else if (e is Map<String, dynamic> && e['message'] != null) {
        Get.snackbar("Error", e['message']);
      } else {
        Get.snackbar("Error", "An unexpected error occurred.");
      }
    } finally {
      isLoading.value = false;
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
    validation.clear();
    isLoading.value = true;

    try {
      await apiService.changePassword(
        userId: activeUserId,
        oldPassword: oldPass,
        newPassword: newPass,
      );
      Get.back();
      Get.snackbar("Success", "Password updated successfully!");
    } catch (e) {
      if (e is Map<String, dynamic> &&
          e['statusCode'] == 422 &&
          e['data'] != null) {
        final data = e['data'] as Map<String, dynamic>;

        data.forEach((fieldKey, errorDetail) {
          if (errorDetail is Map<String, dynamic> &&
              errorDetail['message'] != null) {
            validation[fieldKey] = errorDetail['message'];
          }
        });
      } else if (e is Map<String, dynamic> && e['message'] != null) {
        Get.snackbar("Error", e['message']);
      } else {
        // Handle network or other unexpected errors
        Get.snackbar("Error", "An unexpected error occurred.");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
