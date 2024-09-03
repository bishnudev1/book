import 'package:book/services/helper_services.dart';
import 'package:book/views/home/home_screen.dart';
import 'package:book/views/more/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  // List of pages to display
  final List<Widget> _pages = [
    HomePageScreen(), // Home page
    MoreScreen(), // Settings page, replace with actual settings page
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HelperServices>(builder: (context, value, _) {
      return Scaffold(
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
      );
    });
  }
}
