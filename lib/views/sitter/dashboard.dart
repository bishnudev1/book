import 'package:book/services/appstore.dart';
import 'package:book/views/sitter/dashboard_listing.dart';
import 'package:book/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../auth/login.dart';
import 'dashboard_profile.dart';

class SitterDashboard extends StatefulWidget {
  const SitterDashboard({super.key});

  @override
  State<SitterDashboard> createState() => _SitterDashboardState();
}

class _SitterDashboardState extends State<SitterDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
      () {
        final appstore = Provider.of<Appstore>(context, listen: false);
        appstore.initializeUserData();
        appstore.initializeSitterData();
      },
    );
  }

  final List<DashboardItems> items = [
    DashboardItems(
      labelIcon: Icons.person,
      labelName: 'Profile',
    ),
    DashboardItems(labelIcon: Icons.featured_play_list_rounded, labelName: 'Bookings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: GoogleFonts.lato(
            fontSize: 17,
          ),
        ),
        actions: [
          //logout
          Consumer<Appstore>(builder: (context, value, _) {
            return IconButton(
              onPressed: () async {
                //logout
                final resp = await value.signOut();
                if (resp == true) {
                  // context.go('/login');
                  showToast(message: "Logout successfully", type: ToastificationType.success);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                } else {
                  showToast(message: resp.toString(), type: ToastificationType.error);
                }
              },
              icon: const Icon(Icons.logout),
            );
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (items[index].labelName == 'Profile') {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const DashboardProfileScreen()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DashBoardListing()));
                }
              },
              child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[index].labelIcon,
                      size: 38,
                    ),
                    Text(
                      '${items[index].labelName}',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ); // Default empty container if needed
          },
        ),
      ),
      /*Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "🚧",
              style: TextStyle(fontSize: 46),
            ),
            const SizedBox(height: 20),
            const Align(
                alignment: Alignment.center,
                child: Text(
                  " Under development...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),*/
    );
  }
}

class DashboardItems {
  IconData? labelIcon;
  String? labelName;

  DashboardItems({
    this.labelIcon,
    this.labelName,
  });
}
