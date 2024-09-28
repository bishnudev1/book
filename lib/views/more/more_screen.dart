import 'dart:developer';

import 'package:book/services/appstore.dart';
import 'package:book/services/auth_services.dart';
import 'package:book/services/helper_services.dart';
import 'package:book/utils/ph_dialer.dart';
import 'package:book/views/auth/login.dart';
import 'package:book/views/auth/register.dart';
import 'package:book/views/policy/terms_cond_screen.dart';
import 'package:book/views/sitter/sitter_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../policy/policy_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Future.microtask(
  //     () => Provider.of<AuthServices>(context, listen: false)
  //         .checkAuth()
  //         .then((value) {
  //       setState(() {
  //         isAuth = value;
  //       });
  //     }),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 64.0),
          child: Consumer<Appstore>(builder: (context, app, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<HelperServices>(builder: (context, value, _) {
                  return InkWell(
                    onTap: () {
                      log("Okay");
                      value.changeCurrentIndex(value: 0);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.grey[900],
                    ),
                  );
                }),

                const SizedBox(height: 25),
                Text(
                  'Settings',
                  style: GoogleFonts.rubik(
                    color: Colors.grey[900],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  'GENERAL',
                  style: GoogleFonts.rubik(
                    color: Colors.grey[500], // Light grey text color for "GENERAL"
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Account Section
                app.isSignedIn
                    ? _buildSettingsRow(
                        icon: Icons.person_outline,
                        text: 'Account',
                        onTap: () {
                          // TODO: Implement navigation or action
                        },
                      )
                    : Container(), // If not signed in, hide this row

                app.isSignedIn ? SizedBox(height: 12) : Container(), // Spacing after the row

                app.isSignedIn
                    ? Divider(height: 1, color: Colors.grey[200])
                    : Container(), // If signed in, hide the divider

// Conditionally show the divider only if the user is not signed in
                !app.isSignedIn
                    ? Divider(height: 1, color: Colors.grey[200])
                    : Container(), // If signed in, hide the divider

                const SizedBox(height: 12), // Spacing after the row

// Conditionally show Sitter Register for unsigned users
                // !app.isSignedIn
                //     ? _buildSettingsRow(
                //         icon: Icons.person_pin_circle_outlined,
                //         text: 'Sitter Register',
                //         onTap: () {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) => const SitterRegisterScreen(),
                //             ),
                //           );
                //         },
                //       )
                //     : Container(), // If signed in, hide this row

// // Conditionally show divider for not signed-in users
//                 !app.isSignedIn
//                     ? Divider(height: 1, color: Colors.grey[200])
//                     : Container(), // If signed in, hide the divider

//                 app.isSignedIn ? Container() : const SizedBox(height: 12), // Spacing after the row

// Conditionally show Login option for unsigned users
                !app.isSignedIn
                    ? _buildSettingsRow(
                        icon: Icons.login_outlined,
                        text: "Login",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        })
                    : Container(), // If signed in, hide the row

// Conditionally show divider for not signed-in users
                !app.isSignedIn
                    ? Divider(height: 1, color: Colors.grey[200])
                    : Container(), // If signed in, hide the divider

                app.isSignedIn ? Container() : const SizedBox(height: 12), // Spacing after the row

// Conditionally show Register option for unsigned users
                !app.isSignedIn
                    ? _buildSettingsRow(
                        icon: Icons.app_registration_outlined,
                        text: "Register",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        })
                    : Container(), // If signed in, hide the row

// Logout option for signed-in users
                app.isSignedIn
                    ? _buildSettingsRow(
                        icon: Icons.logout,
                        text: 'Logout',
                        onTap: () async {
                          bool? resp = await app.signOut();
                          if (resp == true) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                      )
                    : Container(), // If not signed in, hide the row
                SizedBox(height: 12),
// Divider before the Delete Account section
                app.isSignedIn
                    ? Divider(height: 1, color: Colors.grey[200])
                    : Container(), // If not signed in, hide the divider

                const SizedBox(height: 12),

// Delete Account for signed-in users
                app.isSignedIn
                    ? _buildSettingsRow(
                        icon: Icons.delete_outline,
                        text: 'Delete Account',
                        onTap: () {
                          // TODO: Implement delete account action
                        },
                      )
                    : Container(), // If not signed in, hide the row

                const SizedBox(height: 32),

                // Support Section Header
                Text(
                  'SUPPORT',
                  style: GoogleFonts.rubik(
                    color: Colors.grey[500], // Light grey text color for "GENERAL"
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Help Center Section
                // _buildSettingsRow(
                //   icon: Icons.help_center_outlined,
                //   text: 'Help Center',
                //   onTap: () {
                //     // TODO: Implement navigation or action
                //   },
                // ),
                const SizedBox(
                  height: 12,
                ),

                Divider(height: 1, color: Colors.grey[200]),
                const SizedBox(height: 12),

                // Emergency Hotline Section
                _buildSettingsRow(
                  icon: Icons.phone_in_talk_outlined,
                  text: 'Emergency Hotline',
                  onTap: () {
                    // TODO: Implement navigation or action
                    launchPhoneDialer("9876543210");
                  },
                ),
                const SizedBox(height: 32),

                // Feedback Section Header
                Text(
                  'USEFUL LINKS',
                  style: GoogleFonts.rubik(
                    color: Colors.grey[500], // Light grey text color for "GENERAL"
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(
                  height: 12,
                ),
                Divider(height: 1, color: Colors.grey[200]),
                const SizedBox(height: 12),

                // Report a Bug Section
                _buildSettingsRow(
                  icon: Icons.privacy_tip_outlined,
                  text: 'Privacy Policy',
                  onTap: () {
                    // TODO: Implement navigation or action
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                Divider(height: 1, color: Colors.grey[200]),
                const SizedBox(height: 12),

                // Send Feedback Section
                _buildSettingsRow(
                  icon: Icons.terminal_outlined,
                  text: 'Terms and Condition',
                  onTap: () {
                    // TODO: Implement navigation or action
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsCondScreen()));
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Helper method to create each settings row
  Widget _buildSettingsRow({required IconData icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.grey[900]),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: GoogleFonts.nunito(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
