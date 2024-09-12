import 'package:book/services/helper_services.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:book/views/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../models/user.dart';
import '../../widgets/exit_app.dart';
import '../../widgets/show_toast.dart';

class ConfirmSitterRegister extends StatefulWidget {
  final Map<String, dynamic> sitter;

  const ConfirmSitterRegister({Key? key, required this.sitter}) : super(key: key);

  @override
  State<ConfirmSitterRegister> createState() => _ConfirmSitterRegisterState();
}

class _ConfirmSitterRegisterState extends State<ConfirmSitterRegister> {
  List<Services> allServicesList = [
    Services(
        serviceIcon: Icons.car_rental_rounded,
        serviceText: 'Car',
        serviceDescription: 'In case of emergency.'),
    Services(
        serviceIcon: Icons.sports_gymnastics_rounded,
        serviceText: 'Gym',
        serviceDescription: 'Fitness and training assistance.'),
    Services(
        serviceIcon: Icons.cookie_outlined,
        serviceText: 'Cooking',
        serviceDescription: 'Emergency transportation for needs'),
    Services(
        serviceIcon: Icons.luggage_rounded,
        serviceText: 'Luggage',
        serviceDescription: 'Travel assistance and luggage.'),
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
        title: Text(
          'Select Services',
          style: GoogleFonts.abel(
            fontWeight: FontWeight.bold,
            fontSize: 20, // Increased font size for the text
            color: AssetManager.baseTextColor11,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Service Tiles (no label)
            ...allServicesList.map((service) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    service.isSelected = !service.isSelected;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: service.isSelected ? Colors.grey.shade300 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Title with GoogleFonts
                      Row(
                        children: [
                          Icon(service.serviceIcon, size: 30, color: AssetManager.baseTextColor11),
                          const SizedBox(width: 16),
                          Text(
                            service.serviceText ?? "",
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 20, // Increased font size for the title
                              color: AssetManager.baseTextColor11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Service Description below the title
                      Text(
                        service.serviceDescription ?? "",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: AssetManager.baseTextColor11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            // Sign Up Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AssetManager.baseTextColor11,
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
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
