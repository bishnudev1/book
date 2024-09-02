import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color set to white
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'More',
          style: GoogleFonts.raleway(
            color: Colors.grey[900], // Dark grey text color
            fontSize: 22, // Slightly larger font size
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Subhead Text with Divider
            Row(
              children: [
                Text(
                  'You',
                  style: GoogleFonts.rubik(
                    color: Colors.grey[900], // Dark grey text color
                    fontSize: 20, // Larger font size for emphasis
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Custom Row with Person Icon and Text 'Signin or Signup'
            GestureDetector(
              onTap: () {
                // TODO: Implement navigation or action
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey[900]),
                      const SizedBox(width: 16),
                      Text(
                        'Sign In or Sign Up',
                        style: GoogleFonts.nunito(
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Custom Row with Settings Icon and Text 'Settings'
            GestureDetector(
              onTap: () {
                // TODO: Implement navigation or action
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings_outlined, color: Colors.grey[900]),
                      const SizedBox(width: 16),
                      Text(
                        'Settings',
                        style: GoogleFonts.nunito(
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Custom Row with Favorite Icon and Text 'Become a sitter'
            GestureDetector(
              onTap: () {
                // TODO: Implement navigation or action
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.volunteer_activism, color: Colors.grey[900]),
                      const SizedBox(width: 16),
                      Text(
                        'Become a sitter',
                        style: GoogleFonts.nunito(
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 32), // Space between sections

            // Second Subhead Text with Divider
            Row(
              children: [
                Text(
                  'Support',
                  style: GoogleFonts.rubik(
                    color: Colors.grey[900], // Dark grey text color
                    fontSize: 20, // Larger font size for emphasis
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Custom Row with Help Icon and Text 'Help Center'
            GestureDetector(
              onTap: () {
                // TODO: Implement navigation or action
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_center_outlined, color: Colors.grey[900]),
                      const SizedBox(width: 16),
                      Text(
                        'Help Center',
                        style: GoogleFonts.nunito(
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Custom Row with Emergency Icon and Text 'Emergency Hotline'
            GestureDetector(
              onTap: () {
                // TODO: Implement navigation or action
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone_in_talk, color: Colors.grey[900]),
                      const SizedBox(width: 16),
                      Text(
                        'Emergency Hotline',
                        style: GoogleFonts.nunito(
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
