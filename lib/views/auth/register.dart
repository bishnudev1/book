import 'package:book/views/auth/login.dart';
import 'package:book/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:book/utils/asset_manager.dart';
import 'package:toastification/toastification.dart';

import '../../widgets/exit_app.dart'; // Import your AssetManager

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showPassword = true;

  final _formKey = GlobalKey<FormState>(); // Key for the Form
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          onback(context);
        }
      },
      child: Scaffold(
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
              child: Icon(Icons.arrow_back_ios)),
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
                    "Register",
                    style: GoogleFonts.abel(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: AssetManager.baseTextColor11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Please sign up to create an account.",
                    style: GoogleFonts.abel(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: AssetManager.baseTextColor11,
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
                          icon:
                              showPassword ? Icon(Icons.remove_red_eye_outlined) : Icon(Icons.remove_red_eye),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Register Button using InkWell
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AssetManager.baseTextColor11, // Button background color
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (_firstNameController.text != "" &&
                            _lastNameController.text != "" &&
                            _zipCodeController.text != "" &&
                            _emailController.text != "" &&
                            _passwordController != "") {
                          context.go('/root');
                        } else {
                          showToast(message: "Fill enter all details", type: ToastificationType.error);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            'Sign up',
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

                  // Already have an account? Login
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the LoginScreen
                        // context.go('/login');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.lato(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Login',
                            style: GoogleFonts.lato(
                              color: AssetManager.baseTextColor11,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.grey[900]),
      ),
    );
  }
}
