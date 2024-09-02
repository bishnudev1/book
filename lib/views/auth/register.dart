import 'package:book/utils/asset_manager.dart';
import 'package:book/views/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color set to white
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
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
          'Signup for Rover',
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
            // Image Asset
            Center(
              child: Image.asset(
                AssetManager.splashImage, // Replace with your asset path
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // First Name
            TextFormField(
              decoration: InputDecoration(
                labelText: 'First Name',
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

            // Last Name
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Last Name',
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

            // Zip Code
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Zip Code',
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

            // Email
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

            // Password
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

            // Register Button using InkWell
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[900], // Dark grey background
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  // TODO: Implement registration logic
                  context.go('/root');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Register',
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

            // Already have an account? Login
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const LoginScreen(),
                  //   ),
                  // );
                  context.go("/login");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.lato(
                        color: Colors.grey[900],
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Login',
                      style: GoogleFonts.lato(
                        color: Colors.grey[900],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    )
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
