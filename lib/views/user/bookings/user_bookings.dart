import 'package:book/services/auth_services.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      Provider.of<AuthServices>(context, listen: false).getSitterBookingList();
    });
  }

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
      body: Consumer<AuthServices>(builder: (context, value, _) {
        if (value.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (value.bookedSitterList.isEmpty) {
          return Center(
            child: Text("You've no recent bookings as of now."),
          );
        }
        return ListView.builder(
          itemCount: value.bookedSitterList.length,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 14),
          itemBuilder: (context, index) {
            final booking = value.bookedSitterList[index];
            return bookingItems(context, booking);
          },
        );
      }),
    );
  }

  /// Booking items
  Widget bookingItems(BuildContext context, Map<String, dynamic> booking) {
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const SizedBox(width: 13),

          /// Sitter Details List
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${booking["sitter_first_name"]} ${booking["sitter_last_name"]}' ?? "Dev01",
                  style: GoogleFonts.nunito(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: deviceWidth * 0.05, // Dynamic text size
                  ),
                ),
                SizedBox(height: deviceHeight * 0.01),
                Text(
                  '${booking["service_name"]} - ${booking["address"]}',
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
                        'Date - ${booking["booking_date"]} at ${booking["booking_time"]}',
                        style: GoogleFonts.nunito(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceWidth * 0.035, // Dynamic text size
                        ),
                      ),
                    ),
                    SizedBox(width: deviceWidth * 0.02), // Space between texts
                    // Text(
                    //   '\$20/h',
                    //   style: GoogleFonts.nunito(
                    //     color: Colors.green,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: deviceWidth * 0.05, // Dynamic text size
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: deviceHeight * 0.01),

                /// Booking Status
                Text(
                  _getStatusText(booking["status"]),
                  style: GoogleFonts.nunito(
                    color: _getStatusColor(booking["status"]),
                    fontWeight: FontWeight.bold,
                    fontSize: deviceWidth * 0.04, // Dynamic text size
                  ),
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

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Sitter has accepted your booking';
      case 2:
        return 'Sitter has canceled your booking';
      default:
        return 'Unknown status';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
