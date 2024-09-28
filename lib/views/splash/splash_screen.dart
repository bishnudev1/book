import 'package:book/services/appstore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../services/auth_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => {
          Future.delayed(const Duration(seconds: 3), () {
            Provider.of<Appstore>(context, listen: false).checkAuth(context);
          })
        });
  }

  @override
  void dispose() {
    // Dispose the controller when done
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset(
            //   AssetManager.splashImage,
            //   color: Colors.black,
            //   height: 120,
            // ),
            // SizedBox(height: 10),
            Text(
              'Cihu',
              style: GoogleFonts.arbutusSlab(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
