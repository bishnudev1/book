import 'package:book/utils/asset_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = true;

  bool rememberMe = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final GlobalKey _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color set to white
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     onPressed: () {
      //       // Navigator.pop(context);
      //       // context.pop();
      //     },
      //     icon: Text(
      //       'Cancel',
      //       style: GoogleFonts.lato(
      //         color: Colors.grey[900], // Dark grey text color
      //         fontSize: 12,
      //       ),
      //     ),
      //   ),
      //   centerTitle: true,
      //   title: Text(
      //     'Login to Rover',
      //     style: GoogleFonts.lato(
      //       color: Colors.grey[900], // Dark grey text color
      //       fontSize: 18,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, right: 25, left: 25, bottom: 20),
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
              SizedBox(
                height: 4,
              ),
              Text(
                "Please Sign in to continue.",
                style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold, fontSize: 17, color: AssetManager.baseTextColor11),
              ),
              SizedBox(
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
                              ? Icon(Icons.remove_red_eye_outlined)
                              : Icon(Icons.remove_red_eye)),
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
                child: InkWell(
                  onTap: () {
                    // TODO: Implement login logic
                    // if(_key.currentState!.()){

                    // }
                    context.go('/root');
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
                ),
              ),
              const SizedBox(height: 20),

              // Don't have an account? Register
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to the RegisterScreen
                    context.go('/register');
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
    );
  }
}
