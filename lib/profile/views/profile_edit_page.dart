import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameC;
  late TextEditingController usernameC;
  late TextEditingController emailC;
  late TextEditingController genderC;
  late TextEditingController regionC;

  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    final profile = Get.find<ProfileController>().profile.value;

    nameC = TextEditingController(text: profile?.name ?? "");
    usernameC = TextEditingController(text: profile?.username ?? "");
    emailC = TextEditingController(text: profile?.email ?? "");
    genderC = TextEditingController(text: profile?.sex ?? "");
    regionC = TextEditingController(text: profile?.region ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Form(
            key: _formKey,
            child: Obx(() {
              final error = controller.validation;
              String? getError(String field) => error[field];
              return Column(
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? img = await picker.pickImage(
                        source: ImageSource.gallery,
                      );

                      if (img != null) {
                        setState(() {
                          _selectedImagePath = img.path;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _selectedImagePath != null
                          ? FileImage(File(_selectedImagePath!))
                          : controller.profile.value?.profileImage != null
                          ? NetworkImage(
                              controller.profile.value!.profileImage!,
                            )
                          : null,
                      child:
                          controller.profile.value?.profileImage == null &&
                              _selectedImagePath == null
                          ? const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 25),

                  buildField(
                    "Name",
                    Icons.person_outline,
                    nameC,
                    getError("name"),
                  ),
                  const SizedBox(height: 15),
                  buildField(
                    "Username",
                    Icons.alternate_email,
                    usernameC,
                    getError("username"),
                  ),
                  const SizedBox(height: 15),
                  buildField(
                    "E-mail",
                    Icons.email_outlined,
                    emailC,
                    getError("email"),
                  ),
                  const SizedBox(height: 15),
                  buildGenderDropdown(),
                  const SizedBox(height: 15),
                  buildField(
                    "Region",
                    Icons.location_on,
                    regionC,
                    getError("region"),
                  ),
                  const SizedBox(height: 30),

                  // SAVE BUTTON
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final new_profile = controller.profile.value!.copyWith(
                          name: nameC.text,
                          username: usernameC.text,
                          email: emailC.text,
                          sex: genderC.text,
                          region: regionC.text,
                        );
                        await controller.updateProfile(
                          new_profile,
                          profileImage: _selectedImagePath,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Save Changes"),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    IconData icon,
    TextEditingController c,
    String? errorText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: c,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }

  Widget buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value:
              genderC.text.isEmpty ||
                  (genderC.text != 'female' && genderC.text != 'male')
              ? null
              : genderC.text,
          items: const [
            DropdownMenuItem(value: "male", child: Text("Male")),
            DropdownMenuItem(value: "female", child: Text("Female")),
          ],
          onChanged: (value) {
            genderC.text = value?.toLowerCase() ?? "";
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.transgender),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
