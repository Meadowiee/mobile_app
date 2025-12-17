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
  late TextEditingController regionC;

  String? _selectedImagePath;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    final profile = Get.find<ProfileController>().profile.value;

    nameC = TextEditingController(text: profile?.name ?? "");
    usernameC = TextEditingController(text: profile?.username ?? "");
    emailC = TextEditingController(text: profile?.email ?? "");
    regionC = TextEditingController(text: profile?.region ?? "");
    selectedGender = profile?.sex;
  }

  @override
  void dispose() {
    nameC.dispose();
    usernameC.dispose();
    emailC.dispose();
    regionC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Obx(() {
              final error = controller.validation;
              String? getError(String field) => error[field];
              return Column(
                children: [
                  buildAvatar(controller),
                  const SizedBox(height: 40),

                  buildField(
                    "Name",
                    Icons.person_outline,
                    nameC,
                    getError("name"),
                  ),
                  const SizedBox(height: 20),
                  buildField(
                    "Username",
                    Icons.alternate_email,
                    usernameC,
                    getError("username"),
                  ),
                  const SizedBox(height: 20),
                  buildField(
                    "E-mail",
                    Icons.email_outlined,
                    emailC,
                    getError("email"),
                  ),
                  const SizedBox(height: 20),
                  buildGenderDropdown(),
                  const SizedBox(height: 20),
                  buildField(
                    "Region",
                    Icons.location_on,
                    regionC,
                    getError("region"),
                  ),
                  const SizedBox(height: 40),

                  // SAVE BUTTON
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final new_profile = controller.profile.value!.copyWith(
                          name: nameC.text,
                          username: usernameC.text,
                          email: emailC.text,
                          sex: selectedGender,
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
    return TextFormField(
      controller: c,
      decoration: _inputDecoration(context, label, icon, errorText),
    );
  }

  Widget buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedGender != null && selectedGender!.isNotEmpty
              ? selectedGender!.toLowerCase()
              : null,
          items: const [
            DropdownMenuItem(value: "male", child: Text("Male")),
            DropdownMenuItem(value: "female", child: Text("Female")),
          ],
          onChanged: (value) {
            setState(() {
              selectedGender = value;
            });
          },
          decoration: _inputDecoration(context, "Gender", Icons.wc, null),
        ),
      ],
    );
  }

  Widget buildAvatar(ProfileController controller) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
            color: Colors.grey[200],
            image: _selectedImagePath != null
                ? DecorationImage(
                    image: FileImage(File(_selectedImagePath!)),
                    fit: BoxFit.cover,
                  )
                : controller.profile.value?.profileImage != null
                ? DecorationImage(
                    image: NetworkImage(
                      controller.profile.value!.profileImage!,
                    ),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child:
              _selectedImagePath == null &&
                  controller.profile.value?.profileImage == null
              ? const Icon(Icons.person, size: 60, color: Colors.grey)
              : null,
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
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
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
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
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String label,
    IconData icon,
    String? errorText,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      errorText: errorText,
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
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
