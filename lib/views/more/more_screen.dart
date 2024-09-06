import 'dart:developer';

import 'package:book/services/auth_services.dart';
import 'package:book/services/helper_services.dart';
import 'package:book/views/auth/login.dart';
import 'package:book/views/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widgets/exit_app.dart';

class MoreScreen extends StatefulWidget {
  MoreScreen({super.key});

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
          child: Consumer<AuthServices>(builder: (context, value, _) {
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
                const SizedBox(height: 30),

                // Account Section
                value.isAuth
                    ? _buildSettingsRow(
                        icon: Icons.person_outline,
                        text: 'Account',
                        onTap: () {
                          // TODO: Implement navigation or action
                        },
                      )
                    : Container(),
                // SizedBox(
                //   height: 12,
                // ),
                // Divider(height: 1, color: Colors.grey[200]),
                // const SizedBox(height: 12),

                // // Notifications Section
                // _buildSettingsRow(
                //   icon: Icons.notifications_active_outlined,
                //   text: 'Notifications',
                //   onTap: () {
                //     // TODO: Implement navigation or action
                //   },
                // ),
                SizedBox(
                  height: 12,
                ),
                Divider(height: 1, color: Colors.grey[200]),
                const SizedBox(height: 12),

                // Corporate Section
                _buildSettingsRow(
                  icon: Icons.person_pin_circle_outlined,
                  text: 'Sitter Register',
                  onTap: () {
                    // TODO: Implement navigation or action
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                Divider(height: 1, color: Colors.grey[200]),
                const SizedBox(height: 12),

                //Register Section

                !value.isAuth
                    ? _buildSettingsRow(
                        icon: Icons.login_outlined,
                        text: "Login",
                        onTap: () {
                          // context.go("/login");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        })
                    : Container(),
                SizedBox(
                  height: 12,
                ),
                Divider(height: 1, color: Colors.grey[200]),
                const SizedBox(height: 12),
                // Register Section
                !value.isAuth
                    ? _buildSettingsRow(
                        icon: Icons.app_registration_outlined,
                        text: "Register",
                        onTap: () {
                          // context.go("/register");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        })
                    : Container(),
                // SizedBox(
                //   height: 12,
                // ),
                // Divider(height: 1, color: Colors.grey[200]),
                // const SizedBox(height: 12),
                // Logout Section
                value.isAuth
                    ? _buildSettingsRow(
                        icon: Icons.logout,
                        text: 'Logout',
                        onTap: () async {
                          // TODO: Implement logout action
                          bool? resp = await value.logout();
                          if (resp == true) {
                            // context.go("/login");
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                      )
                    : Container(),
                SizedBox(
                  height: 12,
                ),
                Divider(height: 1, color: Colors.grey[200]),
                const SizedBox(height: 12),

                // Delete Account Section
                value.isAuth
                    ? _buildSettingsRow(
                        icon: Icons.delete_outline,
                        text: 'Delete Account',
                        onTap: () {
                          // TODO: Implement delete account action
                        },
                      )
                    : Container(),
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
                _buildSettingsRow(
                  icon: Icons.help_center_outlined,
                  text: 'Help Center',
                  onTap: () {
                    // TODO: Implement navigation or action
                  },
                ),
                SizedBox(
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

                // Report a Bug Section
                _buildSettingsRow(
                  icon: Icons.privacy_tip_outlined,
                  text: 'Privacy Policy',
                  onTap: () {
                    // TODO: Implement navigation or action
                  },
                ),
                SizedBox(
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
        padding: EdgeInsets.symmetric(horizontal: 10),
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
