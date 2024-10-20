import 'dart:developer';

import 'package:book/services/appstore.dart';
import 'package:book/services/sitter_services.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:book/views/sitter/dashboard.dart';
import 'package:book/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class DashBoardListing extends StatefulWidget {
  const DashBoardListing({super.key});

  @override
  State<DashBoardListing> createState() => _DashBoardListingState();
}

class _DashBoardListingState extends State<DashBoardListing> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final appStore = Provider.of<Appstore>(context, listen: false);
      final sitter_id = appStore.sitter?.id;
      if (sitter_id == null) {
        log("sitter_id is null. Initializing user data again");
        await appStore.initializeSitterData();
      }
      Provider.of<SitterServices>(context, listen: false).getUserBookingList(sitter_id: sitter_id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: Text(
          'My Bookings',
          style: GoogleFonts.nunito(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<SitterServices>(builder: (context, value, _) {
        if (value.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (value.bookedUserList.isEmpty) {
          return Center(
            child: Text("You don't have any booking right now."),
          );
        }
        return ListView.builder(
          itemCount: value.bookedUserList.length,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 14),
          itemBuilder: (context, index) {
            final booking = value.bookedUserList[index];
            String statusMessage;
            Color statusColor;

            // Determine status message and color based on status
            switch (booking['status']) {
              case 0:
                statusMessage = 'Pending';
                statusColor = Colors.orange;
                break;
              case 1:
                statusMessage = 'Accepted';
                statusColor = Colors.green;
                break;
              case 2:
                statusMessage = "You've rejected the offer.";
                statusColor = Colors.red;
                break;
              default:
                statusMessage = 'Unknown status';
                statusColor = Colors.grey;
            }
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Image View
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          AssetManager.dummyPersonDP,
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.height * 0.15,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),

                      /// Sitter Details List
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${booking['first_name']} ${booking['last_name']}',
                              style: GoogleFonts.nunito(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Service: ${booking['service_name']}',
                              style: GoogleFonts.nunito(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),

                            /// Star Rating
                            _buildStarRating(3),
                            const SizedBox(height: 10),

                            /// Date, Time, and Address
                            Text(
                              'Date: ${booking['booking_date']}',
                              style: GoogleFonts.nunito(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Time: ${booking['booking_time']}',
                              style: GoogleFonts.nunito(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Address: ${booking['address']}',
                              style: GoogleFonts.nunito(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// Status Message
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: statusColor?.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        statusMessage ?? "",
                        style: GoogleFonts.nunito(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Accept and Reject Buttons
                  if (booking['status'] == 0) ...[
                    Consumer<SitterServices>(builder: (context, value, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                log("performing accept offer");
                                // Handle Accept action
                                final resp = await value.updateBookingStatus(
                                  status: 1,
                                  booking_id: booking["id"],
                                  context: context,
                                );

                                if (resp == "Accepted") {
                                  showToast(
                                    message: "You've accepted the offer",
                                    type: ToastificationType.success,
                                  );
                                  navigateToDashboard();
                                } else {
                                  showToast(
                                    message: "Some error occurred. Try again later.",
                                    type: ToastificationType.error,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Accept',
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Handle Reject action
                                final resp = await value.updateBookingStatus(
                                  status: 2,
                                  booking_id: booking["id"],
                                  context: context,
                                );

                                if (resp == "Rejected") {
                                  showToast(
                                    message: "You've rejected the offer",
                                    type: ToastificationType.success,
                                  );
                                  navigateToDashboard();
                                } else {
                                  showToast(
                                    message: "Some error occurred. Try again later.",
                                    type: ToastificationType.error,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Reject',
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ],
              ),
            );
          },
        );
      }),
    );
  }

  /// Star Rating Widget
  Widget _buildStarRating(int rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(
        Icon(
          i <= rating ? Icons.star : Icons.star_border,
          color: i <= rating ? Colors.amber : Colors.grey,
          size: 16,
        ),
      );
    }
    return Row(children: stars);
  }

  void navigateToDashboard() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SitterDashboard()));
  }
}
