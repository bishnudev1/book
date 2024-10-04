import 'package:book/utils/asset_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: Text(
          'My Bookings',
          style: GoogleFonts.nunito(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: deviceWidth * 0.05, // Dynamic text size
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 14),
        itemBuilder: (context, index) {
          return bookingItems(context);
        },
      ),
    );
  }

  /// Booking items
  Widget bookingItems(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image View
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              AssetManager.dummyPersonDP,
              height: deviceHeight * 0.15, // Dynamic image size
              width: deviceHeight * 0.15,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),

          /// Sitter Details List
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dev Sitter',
                  style: GoogleFonts.nunito(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: deviceWidth * 0.05, // Dynamic text size
                  ),
                ),
                SizedBox(height: deviceHeight * 0.01),
                Text(
                  'Sitter description ',
                  style: GoogleFonts.nunito(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: deviceWidth * 0.04, // Dynamic text size
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2, // Limit the number of lines to avoid overflow
                ),
                SizedBox(height: deviceHeight * 0.01),
                _buildStarRating(2, deviceWidth), // Pass device width for dynamic icon size
                SizedBox(height: deviceHeight * 0.02),

                /// Date and Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Date - 02-10-2024',
                        style: GoogleFonts.nunito(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceWidth * 0.035, // Dynamic text size
                        ),
                      ),
                    ),
                    SizedBox(width: deviceWidth * 0.02), // Space between texts
                    Text(
                      '\$20/h',
                      style: GoogleFonts.nunito(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: deviceWidth * 0.05, // Dynamic text size
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Star Rating Builder
  Widget _buildStarRating(int rating, double deviceWidth) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(
        Icon(
          i <= rating ? Icons.star : Icons.star_border,
          color: i <= rating ? Colors.amber : Colors.grey,
          size: deviceWidth * 0.05, // Dynamic icon size
        ),
      );
    }
    return Row(children: stars);
  }
}
