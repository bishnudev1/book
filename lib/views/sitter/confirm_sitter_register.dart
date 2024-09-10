import 'package:book/services/helper_services.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:book/views/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../models/user.dart';
import '../../widgets/exit_app.dart';
import '../../widgets/show_toast.dart'; // Import your showToast function

class ConfirmSitterRegister extends StatefulWidget {
  final Map<String, dynamic> sitter;

  const ConfirmSitterRegister({Key? key, required this.sitter}) : super(key: key);

  @override
  State<ConfirmSitterRegister> createState() => _ConfirmSitterRegisterState();
}

class _ConfirmSitterRegisterState extends State<ConfirmSitterRegister> {
  List<Services> allServicesList = [
    Services(serviceIcon: Icons.car_rental_rounded, serviceText: 'Car'),
    Services(serviceIcon: Icons.sports_gymnastics_rounded, serviceText: 'Gym'),
    Services(serviceIcon: Icons.cookie_outlined, serviceText: 'Cooking'),
    Services(serviceIcon: Icons.luggage_rounded, serviceText: 'Luggage'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Services Selection
            Text(
              'Select Services:',
              style: GoogleFonts.abel(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            ...allServicesList
                .map((service) => CheckboxListTile(
                      title: Text(service.serviceText ?? ""),
                      secondary: Icon(service.serviceIcon),
                      value: service.isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          service.isSelected = value ?? false;
                        });
                      },
                    ))
                .toList(),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AssetManager.baseTextColor11, // Button background color
                borderRadius: BorderRadius.circular(30),
              ),
              child: Consumer<HelperServices>(builder: (context, value, _) {
                return InkWell(
                  onTap: () {
                    bool isAnyServiceSelected = allServicesList.any((service) => service.isSelected);

                    if (isAnyServiceSelected) {
                      // Proceed with Sign Up
                      value.changeCurrentIndex(value: 0);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RootScreen(),
                        ),
                      );
                    } else {
                      showToast(
                        message: "Please select at least one service",
                        type: ToastificationType.error,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.lato(
                          color: Colors.white, // Button text color
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            // Add more UI elements as needed
          ],
        ),
      ),
    );
  }
}
