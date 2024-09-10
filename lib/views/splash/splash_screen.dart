import 'dart:developer';

import 'package:book/views/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


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
    // Initialize the animation controller
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // );

    // Create a tween animation from 0.0 (transparent) to 1.0 (opaque)
    // _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    // );

    // Start the animation
    // _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => HomePageScreen(),
      //     ));
      log("Navigating to /root");
      // context.go("/root");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RootScreen(),
          ));
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
