import 'package:book/services/appstore.dart';
import 'package:book/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../auth/login.dart';

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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  } else {
                    showToast(message: "Some error occured", type: ToastificationType.error);
                  }
                },
                icon: const Icon(Icons.logout),
              );
            })
          ],
        ),
        body: Padding(
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
        ));
  }
}
