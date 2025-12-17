import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/create_room_service.dart';

class CreateRoomController extends GetxController {
  final roomNameController = TextEditingController();
  final descController = TextEditingController();
  final maxMemberController = TextEditingController(text: "10");

  final ImagePicker _picker = ImagePicker();
  final selectedImage = Rx<File?>(null);

  var isLoading = false.obs;

  Future<void> pickImage() async {
    final XFile? picked =
    await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  Future<void> submit() async {
    if (roomNameController.text.isEmpty ||
        descController.text.isEmpty ||
        maxMemberController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    isLoading.value = true;

    try {
      final success = await CreateRoomService.createRoom(
        name: roomNameController.text,
        description: descController.text,
        maxMember: int.parse(maxMemberController.text),
        image: selectedImage.value,
      );

      if (success) {
        Get.back(result: true);
        Get.snackbar("Success", "Room created successfully");
      }
    } catch (e) {
      Get.snackbar("Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    roomNameController.dispose();
    descController.dispose();
    maxMemberController.dispose();
    super.onClose();
  }
}
