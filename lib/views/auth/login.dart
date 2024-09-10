
import 'package:book/services/auth_services.dart';
import 'package:book/services/helper_services.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:book/views/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade200,
                    ),
                    child: TextFormField(
                      validator: (value) {
                        value!.isEmpty ? true : null;
                        return null;
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
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade200,
                    ),
                    child: TextFormField(
                      obscureText: showPassword,
                      validator: (value) {
                        value!.isEmpty ? true : null;
                        return null;
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
                          border: InputBorder.none),
                      style: TextStyle(color: Colors.grey[900]),
                    ),
                  ),
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
                      color: AssetManager.baseTextColor11, // Dark grey background
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Consumer<AuthServices>(builder: (context, value, _) {
                      return InkWell(
                        onTap: () async {
                          // TODO: Implement login logic
                          // if(_key.currentState!.()){

                          // }
                          bool? resp = await value.login();
                          if (resp == true) {
                            Provider.of<HelperServices>(context, listen: false).changeCurrentIndex(value: 0);
                            // context.go('/root');
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RootScreen()));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
