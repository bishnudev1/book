import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsCondScreen extends StatefulWidget {
  const TermsCondScreen({super.key});

  @override
  State<TermsCondScreen> createState() => _TermsCondScreenState();
}

class _TermsCondScreenState extends State<TermsCondScreen> {
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
            }
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          "Terms & Conditions",
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
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras ultricies varius massa, ut dictum "
              "ex fermentum eget. Integer feugiat, felis vel fermentum malesuada, turpis nunc tincidunt dui, "
              "id convallis orci felis sit amet leo.",
              style: GoogleFonts.lato(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "User Responsibilities",
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; "
              "Curabitur fringilla mi et sollicitudin vulputate. Quisque posuere ligula id felis luctus, "
              "et facilisis enim aliquam.",
              style: GoogleFonts.lato(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Limitations of Liability",
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Duis vehicula libero eu velit cursus, nec facilisis turpis sodales. Etiam vulputate "
              "mauris eget felis feugiat, in tempus justo vestibulum. Nam viverra convallis magna, "
              "vel convallis tortor.",
              style: GoogleFonts.lato(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Termination",
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Proin tempor orci vel felis tincidunt, vel ultrices eros rhoncus. Suspendisse euismod "
              "sapien nec nisi consectetur, id dapibus dolor interdum.",
              style: GoogleFonts.lato(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Governing Law",
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Pellentesque vitae nulla eget leo viverra hendrerit ac et eros. Vivamus id consectetur orci. "
              "Mauris pretium magna nec metus varius, at congue sem vehicula.",
              style: GoogleFonts.lato(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
