import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/profile_model.dart';
import '../services/profile_api_service.dart';
import '../../utils/session_manager.dart';

class ProfileController extends GetxController {
  final ProfileApiService apiService = ProfileApiService();
  final SessionManager sessionManager = SessionManager();

  var profile = Rx<Profile?>(null);
  var isLoading = false.obs;
  var validation = RxMap<String, String>({});

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  // Load profile
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      String? token = await sessionManager.getToken();
      String? userId = await sessionManager.getUserId();

      if (token != null && userId != null) {
        final data = await apiService.fetchProfileById(userId, token);
        profile.value = data;
      } else {
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load profile",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile
  Future<void> updateProfile(Profile newProfile, {String? profileImage}) async {
    validation.clear();
    isLoading.value = true;
    try {
      String? token = await sessionManager.getToken();
      String? userId = await sessionManager.getUserId();

      if (token != null && userId != null) {
        await apiService.updateProfile(
          userId,
          token,
          newProfile,
          profileImage: profileImage,
        );
        await loadProfile();
        Get.back();
        Get.snackbar(
          "Success",
          "Profile updated",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
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
        Get.snackbar(
          "Error",
          "Sorry, we couldn't update your profile at the moment.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "An unexpected error occurred.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Change password
  Future<void> changePassword(String oldPass, String newPass) async {
    validation.clear();
    isLoading.value = true;

    try {
      String? token = await sessionManager.getToken();
      String? userId = await sessionManager.getUserId();
      if (token != null && userId != null) {
        await apiService.changePassword(
          userId: userId,
          token: token,
          oldPassword: oldPass,
          newPassword: newPass,
        );
        Get.back();
        Get.snackbar(
          "Success",
          "Password updated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
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
        Get.snackbar(
          "Error",
          "Sorry, we couldn't change your password at the moment.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "An unexpected error occurred.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await SessionManager().clearSession();
    Get.offAllNamed('/login');
  }
}
