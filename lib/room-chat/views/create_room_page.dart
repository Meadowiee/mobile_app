import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_room_controller.dart';

class CreateRoomPage extends StatelessWidget {
  const CreateRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateRoomController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Create Your Room",
          style: TextStyle(
            fontFamily: "Times New Roman",
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: controller.pickImage,
                child: Obx(() {
                  final image = controller.selectedImage.value;
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                      image: image != null
                          ? DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: image == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt,
                            size: 32, color: Colors.grey),
                        SizedBox(height: 6),
                        Text("Upload Photo",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    )
                        : null,
                  );
                }),
              ),
            ),
            const SizedBox(height: 32),
            _label("Room Name"),
            _inputField(
              controller: controller.roomNameController,
              hint: "e.g. Brew Escape Chat",
            ),
            const SizedBox(height: 24),
            _label("Description"),
            _inputField(
              controller: controller.descController,
              hint: "Tell people what this room is about",
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            _label("Max Member"),
            _inputField(
              controller: controller.maxMemberController,
              hint: "e.g. 10",
            ),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                controller.isLoading.value ? null : controller.submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Create Room",
                  style: TextStyle(
                    fontFamily: "Georgia",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: "Georgia",
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
