import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/auth_model.dart';
import '../../utils/session_manager.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  final usernameC = TextEditingController();
  final passC = TextEditingController();

  var isObscure = true.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    usernameC.dispose();
    passC.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (usernameC.text.isEmpty || passC.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Username dan Password harus diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    var result = await _authService.login(
      username: usernameC.text,
      password: passC.text,
    );

    isLoading.value = false;

    if (result['success']) {
      LoginResponse response = result['data'];

      if (response.user != null) {
        await SessionManager().saveAuth(
          response.user!.token,
          response.user!.id,
        );

        Get.snackbar(
          "Sukses",
          "Login Berhasil",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/dashboard');
      }
    } else {
      Get.snackbar(
        "Gagal",
        result['message'] ?? "Error",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> logout() async {
    await SessionManager().clearSession();
    Get.offAllNamed('/login');
  }
}
