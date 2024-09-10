import 'package:book/utils/asset_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../models/user.dart';
import '../../widgets/exit_app.dart';
import '../../widgets/show_toast.dart';
import 'confirm_sitter_register.dart';

class SitterRegisterScreen extends StatefulWidget {
  const SitterRegisterScreen({Key? key}) : super(key: key);

  @override
  State<SitterRegisterScreen> createState() => _SitterRegisterScreenState();
}

class _SitterRegisterScreenState extends State<SitterRegisterScreen> {
  bool showPassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController(); // New description controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              onback(context);
            }
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    AssetManager.loginBG, // Replace with your asset path
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Sitter Register",
                  style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Please sign up to create an account.",
                  style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // First Name Field
                buildTextField(
                    label: 'First Name', icon: Icons.person_outline, controller: _firstNameController),
                const SizedBox(height: 16),

                // Last Name Field
                buildTextField(
                    label: 'Last Name', icon: Icons.person_outline, controller: _lastNameController),
                const SizedBox(height: 16),

                // Zip Code Field
                buildTextField(
                    label: 'Zip Code',
                    icon: Icons.location_on_outlined,
                    keyboardType: TextInputType.number,
                    controller: _zipCodeController),
                const SizedBox(height: 16),

                // Email Field
                buildTextField(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController),
                const SizedBox(height: 16),

                // Password Field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: showPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.key_outlined,
                        color: Colors.grey[600],
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        icon: showPassword
                            ? const Icon(Icons.remove_red_eye_outlined)
                            : const Icon(Icons.remove_red_eye),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 5, // Minimum number of lines
                    maxLines: 10, // Maximum number of lines
                    textAlignVertical: TextAlignVertical.top, // Align text to the top
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.description_outlined,
                        color: Colors.grey[600],
                      ),
                      labelText: 'Description'.toUpperCase(),
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                ),
                const SizedBox(height: 28),

                // Next Button
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AssetManager.baseTextColor11, // Button background color
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (_firstNameController.text.isNotEmpty &&
                            _lastNameController.text.isNotEmpty &&
                            _zipCodeController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty &&
                            _descriptionController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmSitterRegister(sitter: {
                                'firstName': _firstNameController.text,
                                'lastName': _lastNameController.text,
                                'zipCode': _zipCodeController.text,
                                'email': _emailController.text,
                                'password': _passwordController.text,
                                'description': _descriptionController.text
                              }),
                            ),
                          );
                        } else {
                          showToast(
                              message: "Please fill out all fields and select at least one service",
                              type: ToastificationType.error);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Next',
                          style: GoogleFonts.lato(
                            color: Colors.white, // Button text color
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build TextFormField
  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isUpperCase = false, // New parameter for uppercase transformation
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade200,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey[600],
          ),
          labelText: isUpperCase ? label.toUpperCase() : label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.grey[900]),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
