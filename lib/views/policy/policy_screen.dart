import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/exit_app.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          "Privacy & Policy",
          style: GoogleFonts.lato(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Introduction",
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque at tempor dolor. "
              "Nam vehicula justo nec justo fermentum, sit amet aliquam risus tincidunt. "
              "Vivamus viverra quam vel ultricies scelerisque. Nullam ac tristique sapien. "
              "Fusce ac tortor ligula.",
              style: GoogleFonts.lato(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Data Collection",
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Curabitur suscipit, sem sit amet elementum volutpat, felis dui vehicula orci, et fermentum "
              "erat erat nec felis. Donec consectetur quam felis, at consectetur sem rhoncus sed.",
              style: GoogleFonts.lato(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Cookies Usage",
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. "
              "Phasellus volutpat orci a magna vulputate, nec ullamcorper justo tempor. Praesent interdum "
              "arcu ut ligula malesuada vulputate.",
              style: GoogleFonts.lato(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Security",
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Sed euismod, nibh quis vestibulum malesuada, elit libero suscipit augue, ac lobortis ex erat "
              "euismod lorem. Maecenas vitae ipsum at orci volutpat fermentum.",
              style: GoogleFonts.lato(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Conclusion",
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; "
              "Phasellus feugiat nisl id tortor gravida, ut pellentesque velit lobortis. Curabitur "
              "vehicula felis vel nisi cursus aliquet.",
              style: GoogleFonts.lato(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
