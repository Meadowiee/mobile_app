import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfilePasswordPage extends StatefulWidget {
  const ProfilePasswordPage({super.key});

  @override
  State<ProfilePasswordPage> createState() => _ProfilePasswordPageState();
}

class _ProfilePasswordPageState extends State<ProfilePasswordPage> {
  final RxString _confirmErrorText = ''.obs;
  final _formKey = GlobalKey<FormState>();

  final oldC = TextEditingController();
  final newC = TextEditingController();
  final confirmC = TextEditingController();

  bool oldObscure = true;
  bool newObscure = true;
  bool confirmObscure = true;

  @override
  void dispose() {
    _confirmErrorText.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
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
              String? confirmError = _confirmErrorText.value.isNotEmpty
                  ? _confirmErrorText.value
                  : null;
              return Column(
                children: [
                  passField(
                    "Old Password",
                    oldC,
                    oldObscure,
                    () {
                      setState(() => oldObscure = !oldObscure);
                    },
                    errorText: getError("oldPassword"),
                  ),
                  const SizedBox(height: 20),

                  passField(
                    "New Password",
                    newC,
                    newObscure,
                    () {
                      setState(() => newObscure = !newObscure);
                    },
                    errorText: getError("newPassword"),
                  ),
                  const SizedBox(height: 20),

                  passField(
                    "Confirm Password",
                    confirmC,
                    confirmObscure,
                    () {
                      setState(() => confirmObscure = !confirmObscure);
                    },
                    errorText: confirmError,
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (newC.text != confirmC.text) {
                          _confirmErrorText.value = "Passwords do not match";
                          return;
                        }

                        controller.changePassword(oldC.text, newC.text);
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
                    child: const Text("Update Password"),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget passField(
    String label,
    TextEditingController c,
    bool obscure,
    VoidCallback toggle, {
    String? errorText,
  }) {
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
          obscureText: obscure,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field is required";
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: toggle,
            ),
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
}
