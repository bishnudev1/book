import 'dart:developer';

import 'package:book/services/helper_services.dart';
import 'package:book/services/sitter_services.dart';
import 'package:book/views/home/home_screen.dart';
import 'package:book/views/more/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/appstore.dart';
import '../widgets/exit_app.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({
    super.key,
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  // List of pages to display
  final List<Widget> _pages = [
    const HomePageScreen(), // Home page
    const MoreScreen(), // Settings page, replace with actual settings page
  ];

  init() async {
    final Appstore appstore = Provider.of<Appstore>(context, listen: false);
    await appstore.initializeUserData();

    final userPinCode = appstore.user?.zipCode;

    if (userPinCode == null || userPinCode.isEmpty) {
      await appstore.initializeUserData();
    }

    await Provider.of<SitterServices>(context, listen: false)
        .getSitterListByPinCode(pinCode: appstore.user!.zipCode ?? '');
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => init());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HelperServices>(builder: (context, value, _) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          if (value.currentIndex == 0) {
            onback(context);
          }

          value.changeCurrentIndex(value: 0);
        },
        child: Scaffold(
          body: _pages[value.currentIndex], // Display the selected page
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: value.currentIndex, // The current selected index
            onTap: (index) {
              value.changeCurrentIndex(value: index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      );
    });
  }
}
