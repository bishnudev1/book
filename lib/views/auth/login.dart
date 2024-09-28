import 'dart:developer';

import 'package:book/services/auth_services.dart';
import 'package:book/services/helper_services.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:book/utils/validation.dart';
import 'package:book/views/auth/register.dart';
import 'package:book/views/sitter/sitter_register_screen.dart';
import 'package:book/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../widgets/exit_app.dart';
import '../root_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = true;

  bool rememberMe = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final ValueNotifier<bool> _isEmailValid = ValueNotifier(true);
  final ValueNotifier<bool> _isPasswordValid = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          log("Did pop");
          return;
        }
        if (Navigator.canPop(context)) {
          log("Can pop");
          Navigator.pop(context);
        } else {
          log("On back");
          onback(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
        body: Padding(
          padding: const EdgeInsets.only(top: 40, right: 25, left: 25, bottom: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Centered Image Asset
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
                    "Login",
                    style: GoogleFonts.abel(
                        fontWeight: FontWeight.bold, fontSize: 32, color: AssetManager.baseTextColor11),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Please Sign in to continue.",
                    style: GoogleFonts.abel(
                        fontWeight: FontWeight.bold, fontSize: 17, color: AssetManager.baseTextColor11),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Email Field
                  ValueListenableBuilder(
                      valueListenable: _isEmailValid,
                      builder: (context, value, _) {
                        debugPrint('My value is: $value');
                        return Container(
                          padding: value
                              ? const EdgeInsets.only(bottom: 0) // No padding if valid
                              : const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade200,
                          ),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return validateEmail(value ?? '');
                            },
                            onChanged: (value) {
                              final validationResult = validateEmail(value ?? '');
                              debugPrint("My validate string is: $validationResult");
                              _isEmailValid.value = validationResult == null ? true : false;
                              debugPrint('My email is validate: ${_isEmailValid.value}');
                              _emailController.text = value;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey[600],
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                border: InputBorder.none),
                            style: TextStyle(color: Colors.grey[900]),
                          ),
                        );
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
                            obscureText: showPassword,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return validateEmptyString(value ?? '', 'Password');
                              // value.isEmpty ? true : null;
                              // return null;
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
                                      : const Icon(Icons.remove_red_eye)),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: Colors.grey[900]),
                          ),
                        );
                      }),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Remember this device",
                          style: GoogleFonts.abel(
                              fontSize: 14, fontWeight: FontWeight.bold, color: AssetManager.baseTextColor11),
                        ),
                        Switch(
                            value: rememberMe,
                            activeColor: AssetManager.baseTextColor11,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value;
                              });
                            })
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Login Button using InkWell
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AssetManager.baseTextColor11,
                      // Dark grey background
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Consumer<AuthServices>(builder: (context, value, _) {
                      return InkWell(
                        onTap: () async {
                          // TODO: Implement login logic
                          _isEmailValid.value = false;
                          _isPasswordValid.value = false;
                          if (_key.currentState!.validate()) {
                            var resp;
                            if (_emailController.text != "") {
                              if (_passwordController.text != "") {
                                resp = await value.login(
                                    email: _emailController.text, password: _passwordController.text);
                              } else {
                                showToast(message: "Please enter a password", type: ToastificationType.error);
                              }
                            } else {
                              showToast(message: "Please enter a email", type: ToastificationType.error);
                            }
                            if (resp == true) {
                              showToast(message: "Login successfully", type: ToastificationType.success);
                              Provider.of<HelperServices>(context, listen: false)
                                  .changeCurrentIndex(value: 0);
                              // context.go('/root');
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => const RootScreen()));
                            } else if (resp == null) {
                              return;
                            } else {
                              showToast(message: resp, type: ToastificationType.error);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: value.isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Sign in',
                                    style: GoogleFonts.lato(
                                      color: Colors.white, // White text
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Don't have an account? Register
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the RegisterScreen
                        // context.go('/register');
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: GoogleFonts.lato(
                              color: Colors.grey[600],
                              fontSize: 16,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Sign up',
                            style: GoogleFonts.lato(
                              color: AssetManager.baseTextColor11,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Don't have an account? Register
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the RegisterScreen
                        // context.go('/sregister');
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const SitterRegisterScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Do you want to register as a Sitter ?",
                            style: GoogleFonts.lato(
                              color: Colors.grey[600],
                              fontSize: 16,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Register',
                            style: GoogleFonts.lato(
                              color: AssetManager.baseTextColor11,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // decoration: TextDecoration.underline,
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
}
