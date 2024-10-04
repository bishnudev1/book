import 'package:book/models/sitter.dart';
import 'package:book/services/helper_services.dart';
import 'package:book/services/sitter_services.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:book/utils/pop_manager.dart';
import 'package:book/views/root_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../../widgets/show_toast.dart';

class ConfirmSitterRegister extends StatefulWidget {
  final Map<String, dynamic> sitter;

  const ConfirmSitterRegister({Key? key, required this.sitter}) : super(key: key);

  @override
  State<ConfirmSitterRegister> createState() => _ConfirmSitterRegisterState();
}

class _ConfirmSitterRegisterState extends State<ConfirmSitterRegister> {
  List<int> selectedServiceIds = []; // Maintain selected service IDs

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SitterServices>(context, listen: false).getAllSitterServices();
    });
  }

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
              // Handle app exit
            }
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Select Services',
          style: GoogleFonts.abel(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AssetManager.baseTextColor11,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Consumer<SitterServices>(
          builder: (context, value, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // List view to display services
                value.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : value.servicesList.isEmpty
                        ? const Center(
                            child: Text(
                              "No services available",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.servicesList.length,
                            itemBuilder: (context, index) {
                              final service = value.servicesList[index];
                              bool isSelected = selectedServiceIds.contains(service.id);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedServiceIds.remove(service.id); // Deselect service
                                    } else {
                                      selectedServiceIds.add(service.id ?? 0); // Select service
                                    }
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.grey.shade300 : Colors.white,
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
                                  child: Row(
                                    children: [
                                      Image.network(
                                        "https://chihu.infyedgesolutions.com/${service.service_logo}",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 10), // Add padding between icon and label
                                      Expanded(
                                        child: Text(
                                          service.service_name ?? '',
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: AssetManager.baseTextColor11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AssetManager.baseTextColor11,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (selectedServiceIds.isNotEmpty) {
                        final resp = await value.sitter_register(
                          firstName: widget.sitter['firstName'],
                          lastName: widget.sitter['lastName'],
                          email: widget.sitter['email'],
                          password: widget.sitter['password'],
                          zip_code: widget.sitter['zipCode'],
                          description: widget.sitter['description'],
                          per_hourse_rate: widget.sitter['perHourCharge'],
                          coma_sep_service_id: selectedServiceIds.join(','),
                        );

                        if (resp == true) {
                          showToast(
                            message: "Sitter registered successfully",
                            type: ToastificationType.success,
                          );
                          context.go('/dashboard');
                        } else {
                          showToast(
                            message: resp.toString(),
                            type: ToastificationType.error,
                          );
                        }
                      } else {
                        showToast(
                          message: "Please select at least one service",
                          type: ToastificationType.error,
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: value.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Center(
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
