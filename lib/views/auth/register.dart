import 'dart:developer';

import 'package:book/services/auth_services.dart';
import 'package:book/utils/validation.dart';
import 'package:book/views/auth/login.dart';
import 'package:book/widgets/show_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:book/utils/asset_manager.dart';
import 'package:provider/provider.dart';
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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  final ValueNotifier<bool> _isFirstNameValid = ValueNotifier(true);
  final ValueNotifier<bool> _isLastNameValid = ValueNotifier(true);
  final ValueNotifier<bool> _isEmailValid = ValueNotifier(true);
  final ValueNotifier<bool> _isPasswordValid = ValueNotifier(true);

  // List<String> zipCodeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => Provider.of<AuthServices>(context, listen: false).getPinCodeList());
  }

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
              child: const Icon(Icons.arrow_back_ios)),
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
                      label: 'First Name',
                      icon: Icons.person_outline,
                      controller: _firstNameController,
                      validator: (value) {
                        return validateEmptyString(value ?? '', 'First name');
                      },
                      valueListenableValue: _isFirstNameValid,
                      onChanged: (value) {
                        final validationResult = validateEmptyString(value, 'First Name');
                        _isFirstNameValid.value = validationResult == null ? true : false;
                        _firstNameController.text = value;
                      }),
                  const SizedBox(height: 16),

                  // Last Name Field
                  buildTextField(
                      label: 'Last Name',
                      icon: Icons.person_outline,
                      controller: _lastNameController,
                      validator: (value) {
                        return validateEmptyString(value ?? '', 'Last Name');
                      },
                      valueListenableValue: _isLastNameValid,
                      onChanged: (value) {
                        final validationResult = validateEmptyString(value, 'Last Name');
                        _isLastNameValid.value = validationResult == null ? true : false;
                        _lastNameController.text = value;
                      }),
                  const SizedBox(height: 16),

                  // Zip Code Field
                  Consumer<AuthServices>(builder: (context, value, _) {
                    return buildZipCodeAutocompleteField(otps: value.pinCodeList);
                  }),
                  /*buildTextField(
                      label: 'Zip Code',
                      icon: Icons.location_on_outlined,
                      keyboardType: TextInputType.number,
                      controller: _zipCodeController),*/
                  const SizedBox(height: 16),

                  // Email Field
                  buildTextField(
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) {
                        return validateEmail(value ?? '');
                      },
                      valueListenableValue: _isEmailValid,
                      onChanged: (value) {
                        final validationResult = validateEmail(value);
                        _isEmailValid.value = validationResult == null ? true : false;
                        _emailController.text = value;
                      }),
                  const SizedBox(height: 16),

                  // Password Field
                  ValueListenableBuilder(
                      valueListenable: _isPasswordValid,
                      builder: (context, value, _) {
                        return Container(
                          padding: value
                              ? const EdgeInsets.only(bottom: 0) // No padding if valid
                              : const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade200,
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: showPassword,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return validateEmptyString(value ?? '', 'Password');
                            },
                            onChanged: (value) {
                              final validationResult = validateEmptyString(value, 'Password');
                              debugPrint("My validate string is: $validationResult");
                              _isPasswordValid.value = validationResult == null ? true : false;
                              debugPrint('My email is validate: ${_isPasswordValid.value}');
                              _passwordController.text = value;
                            },
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
                        );
                      }),
                  const SizedBox(height: 28),

                  // Register Button using InkWell
                  Consumer<AuthServices>(builder: (context, value, _) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AssetManager.baseTextColor11, // Button background color
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: InkWell(
                        onTap: () async {
                          _isFirstNameValid.value = false;
                          _isLastNameValid.value = false;
                          _isEmailValid.value = false;
                          _isPasswordValid.value = false;
                          if (_formKey.currentState!.validate()) {
                            if (_firstNameController.text != "" &&
                                _lastNameController.text != "" &&
                                _zipCodeController.text != "" &&
                                _emailController.text != "" &&
                                _passwordController.text != "") {
                              // context.go('/root');
                              final result = await value.register(
                                  firstname: _firstNameController.text,
                                  lastname: _lastNameController.text,
                                  zipcode: _zipCodeController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text);

                              log("My result is: $result");

                              if (result == true) {
                                showToast(message: "Register successfully", type: ToastificationType.success);
                                // context.go('/login');
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                              } else {
                                showToast(message: result.toString(), type: ToastificationType.error);
                              }
                            } else {
                              showToast(message: "Fill enter all details", type: ToastificationType.error);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: value.isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Sign up',
                                    style: GoogleFonts.lato(
                                      color: Colors.white, // Button text color
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),

                  // Already have an account? Login
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the LoginScreen
                        // context.go('/login');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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
  Widget buildTextField(
      {required String label,
      required IconData icon,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      required String? Function(String?)? validator,
      required ValueListenable<bool> valueListenableValue,
      required Function(String)? onChanged}) {
    return ValueListenableBuilder(
        valueListenable: valueListenableValue,
        builder: (context, value, _) {
          return Container(
            padding: value
                ? const EdgeInsets.only(bottom: 0) // No padding if valid
                : const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade200,
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: validator,
              onChanged: onChanged,
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
        });
  }

  /// Auto Complete Dropdown
  Widget buildZipCodeAutocompleteField({required List<String> otps}) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return otps.where((zip) => zip.contains(textEditingValue.text));
      },
      onSelected: (String selection) {
        _zipCodeController.text = selection;
      },
      fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Border radius for the text field
            color: Colors.grey.shade200,
          ),
          child: TextFormField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            decoration: InputDecoration(
              labelText: 'Zip Code',
              prefixIcon: const Icon(Icons.location_on_outlined),
              labelStyle: TextStyle(color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20), // Apply border radius to the text field
                borderSide: BorderSide.none, // Remove border side for a clean look
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
          ),
        );
      },
      optionsViewBuilder:
          (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20), // Border radius for the dropdown
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Applying border radius
                  color: Colors.white,
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
