import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),

                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Obx(
                            () => Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      secondaryColor, // Menggunakan Secondary
                                  width: 2,
                                ),
                                color: Colors.grey[200],
                                image: controller.selectedImage.value != null
                                    ? DecorationImage(
                                        image: FileImage(
                                          controller.selectedImage.value!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: controller.selectedImage.value == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => controller.pickImage(),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      secondaryColor, // Menggunakan Secondary (Tombol Kamera)
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () =>
                            controller.validationErrors['profileImage'] != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  controller.validationErrors['profileImage'],
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // --- 2. FORM FIELDS ---
                // Name
                Obx(
                  () => TextField(
                    controller: controller.nameC,
                    decoration: _inputDecoration(
                      context, // Pass context
                      'Full Name',
                      Icons.person_outline,
                      'name',
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Username
                Obx(
                  () => TextField(
                    controller: controller.usernameC,
                    decoration: _inputDecoration(
                      context, // Pass context
                      'Username',
                      Icons.alternate_email,
                      'username',
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Email
                Obx(
                  () => TextField(
                    controller: controller.emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      context, // Pass context
                      'Email',
                      Icons.email_outlined,
                      'email',
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Region
                Obx(
                  () => TextField(
                    controller: controller.regionC,
                    decoration: _inputDecoration(
                      context, // Pass context
                      'Region',
                      Icons.map_outlined,
                      'region',
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sex (Dropdown)
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedSex.value,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    hint: const Text("Select Gender"),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    items: controller.sexOptions.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) => controller.selectedSex.value = value,
                    decoration: _inputDecoration(
                      context,
                      'Sex',
                      Icons.wc,
                      'sex',
                    ), // Pass context
                  ),
                ),
                const SizedBox(height: 20),

                // Password
                Obx(
                  () => TextField(
                    controller: controller.passC,
                    obscureText: controller.isObscure.value,
                    decoration:
                        _inputDecoration(
                          context, // Pass context
                          'Password',
                          Icons.lock_outline,
                          'password',
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => controller.isObscure.toggle(),
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Password
                Obx(
                  () => TextField(
                    controller: controller.confirmPassC,
                    obscureText: controller.isObscureConfirm.value,
                    decoration:
                        _inputDecoration(
                          context, // Pass context
                          'Confirm Password',
                          Icons.lock_outline,
                          'confirmPassword',
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isObscureConfirm.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                controller.isObscureConfirm.toggle(),
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- 3. SUBMIT BUTTON ---
                Obx(
                  () => SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.register(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            secondaryColor, // Menggunakan Secondary
                        foregroundColor: Colors.white, // Text tombol putih
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- 4. LOGIN LINK ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        "Login here",
                        style: TextStyle(
                          color: secondaryColor, // Menggunakan Secondary
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- UI HELPER ---
  // Saya menambahkan parameter 'BuildContext context' agar bisa akses Theme
  InputDecoration _inputDecoration(
    BuildContext context, // <--- Tambahan
    String label,
    IconData icon,
    String errorKey,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      // Integrasi Error dari Controller
      errorText: controller.validationErrors[errorKey],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          // Menggunakan Secondary saat diklik (Focus)
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      fillColor: Colors.white,
      filled: true,
    );
  }
}
