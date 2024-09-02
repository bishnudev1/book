import 'package:book/utils/asset_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color set to white
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context);
            // context.pop();
          },
          icon: Text(
            'Cancel',
            style: GoogleFonts.lato(
              color: Colors.grey[900], // Dark grey text color
              fontSize: 12,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Login to Rover',
          style: GoogleFonts.lato(
            color: Colors.grey[900], // Dark grey text color
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centered Image Asset
            Center(
              child: Image.asset(
                AssetManager.splashImage, // Replace with your asset path
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Email Field
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey[900]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[900]!),
                ),
              ),
              style: TextStyle(color: Colors.grey[900]),
            ),
            const SizedBox(height: 16),

            // Password Field
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.grey[900]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[900]!),
                ),
              ),
              style: TextStyle(color: Colors.grey[900]),
            ),
            const SizedBox(height: 16),

            // Login Button using InkWell
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[900], // Dark grey background
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  // TODO: Implement login logic
                  context.go('/root');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Login',
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
                        color: Colors.grey[900],
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Register',
                      style: GoogleFonts.lato(
                        color: Colors.grey[900],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
