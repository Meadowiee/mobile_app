import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/register_service.dart';

class RegisterController extends GetxController {
  final RegisterService _registerService = RegisterService();

  // --- Text Controllers ---
  final nameC = TextEditingController();
  final usernameC = TextEditingController();
  final emailC = TextEditingController();
  final regionC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();

  // --- Reactive State Variables ---
  var isObscure = true.obs;
  var isObscureConfirm = true.obs;
  var isLoading = false.obs;

  // Data Selection
  var selectedSex = Rx<String?>(null);
  final List<String> sexOptions = ['male', 'female'];
  var selectedImage = Rx<File?>(null);

  // Error Handling State
  var validationErrors = <String, dynamic>{}.obs;

  @override
  void onClose() {
    // Bersihkan controller saat halaman ditutup untuk hemat memori
    nameC.dispose();
    usernameC.dispose();
    emailC.dispose();
    regionC.dispose();
    passC.dispose();
    confirmPassC.dispose();
    super.onClose();
  }

  // --- Logic Functions ---

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      // Hapus error visual jika user sudah memilih gambar
      if (validationErrors.containsKey('profileImage')) {
        validationErrors.remove('profileImage');
      }
    }
  }

  void register() async {
    if (nameC.text.isEmpty ||
        usernameC.text.isEmpty ||
        emailC.text.isEmpty ||
        regionC.text.isEmpty ||
        passC.text.isEmpty ||
        confirmPassC.text.isEmpty ||
        selectedSex.value == null) {
      Get.snackbar(
        "Peringatan",
        "Semua data wajib diisi!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
if (passC.text != confirmPassC.text) {
      Get.snackbar(
        "Error",
        "Password confirmation does not match",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    validationErrors.clear();

    // 4. Panggil Service
    var result = await _registerService.register(
      name: nameC.text,
      username: usernameC.text,
      email: emailC.text,
      password: passC.text,
      region: regionC.text,
      sex: selectedSex.value,
      imageFile: selectedImage.value,
    );

    isLoading.value = false;

    // 5. Handle Response
    if (result['success']) {
      Get.snackbar("Success", "Account created successfully!");
      Get.offAllNamed('/login');
    } else {
      if (result['errors'] != null) {
        validationErrors.value = result['errors'];
        Get.snackbar(
          "Registration Failed",
          "Please check your input",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          result['message'] ?? "Unknown Error",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
