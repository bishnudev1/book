import 'dart:developer';

import 'package:book/models/sitter.dart';
import 'package:book/models/user.dart';
import 'package:book/services/appstore.dart';
import 'package:book/services/sitter_services.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:book/widgets/show_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../models/review.dart';

class SitterScreen extends StatefulWidget {
  final Sitter sitter;
  const SitterScreen({super.key, required this.sitter});

  @override
  State<SitterScreen> createState() => _SitterScreenState();
}

class _SitterScreenState extends State<SitterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TextEditingController reviewController = TextEditingController();
  int _newReviewRating = 0;
  int selectedRating = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      Provider.of<SitterServices>(context, listen: false)
          .getSitterReviewList(sitter_id: widget.sitter.id.toString());
    });
    log("sitter_id in sitter_screen: ${widget.sitter.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blueGrey,
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.sitter.first_name ?? "",
          style: GoogleFonts.lato(
            fontSize: 17,
          ),
        ),
        actions: const [
          Icon(
            Icons.share_outlined,
            color: Color.fromARGB(255, 39, 39, 39),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: widget.sitter.first_name == ""
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // CachedNetworkImage(
                      //   imageUrl:  "",
                      //   placeholder: (context, url) => const CircularProgressIndicator(),
                      //   errorWidget: (context, url, error) => const Icon(Icons.error),
                      //   height: 300,
                      //   width: double.infinity,
                      //   fit: BoxFit.cover,
                      // ),
                      // Image.asset(
                      //   AssetManager.dummyPersonDP,
                      //   height: 300,
                      //   width: double.infinity,
                      //   fit: BoxFit.cover,
                      // ),
                      CachedNetworkImage(
                        height: 300,
                        //   width: deviceHeight * 0.15,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: widget.sitter.profile_pic != ""
                            ? widget.sitter.profile_pic!
                            : "https://w7.pngwing.com/pngs/910/606/png-transparent-head-the-dummy-avatar-man-tie-jacket-user-thumbnail.png",
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      Positioned(
                        top: 240,
                        left: MediaQuery.of(context).size.width / 2 - 45,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 1, color: Colors.white)),
                          child: CircleAvatar(
                              radius: 45,
                              // backgroundImage: CachedNetworkImageProvider(widget.sitter.profilePhoto ?? ""),
                              backgroundImage:
                                  //  const AssetImage(AssetManager.dummyPersonDP
                                  // ),
                                  CachedNetworkImageProvider(widget.sitter.profile_pic != ""
                                      ? widget.sitter.profile_pic!
                                      : "https://w7.pngwing.com/pngs/910/606/png-transparent-head-the-dummy-avatar-man-tie-jacket-user-thumbnail.png")),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60), // Adjust this value as needed
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.sitter.first_name ?? "",
                          style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildStarRating(int.parse(widget.sitter.rating ?? "0") ?? 0),
                        const SizedBox(height: 8),
                        Text(
                          "Description: ${widget.sitter.description}",
                          style: GoogleFonts.abel(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Price: ${widget.sitter.per_hour_rate} per hour",
                          style: GoogleFonts.abel(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: const [
                      Tab(text: "Info"),
                      Tab(text: "Services"),
                      Tab(text: "Reviews"),
                    ],
                  ),
                  SizedBox(
                    // height: 300,
                    height: 500,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildInfoSection(widget.sitter.description ?? ""),
                        _buildServicesSection(widget.sitter.services ?? []),
                        // _buildReviewsSection(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer<SitterServices>(builder: (context, value, _) {
                                  if (value.sitterReviews.isEmpty) {
                                    return const Center(
                                      child: Text("No reviews yet"),
                                    );
                                  }
                                  if (value.isLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return SizedBox(
                                    height: 200, // Adjust this height based on your UI requirements
                                    child: ListView.builder(
                                      itemCount: value.sitterReviews.length,
                                      itemBuilder: (context, index) {
                                        final review = value.sitterReviews[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 16.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // CircleAvatar(
                                              //   radius: 24,
                                              //   backgroundImage: CachedNetworkImageProvider(
                                              //       "https://avatars.githubusercontent.com/u/91979889?v=4"),
                                              //   backgroundColor: Colors.grey[200],
                                              // ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${review["user_first_name"]} ${review["user_last_name"]}",
                                                      style: GoogleFonts.lato(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    _buildStarRating(review["rating"] ?? 0),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      review["review_description"] ?? "",
                                                      style: GoogleFonts.abel(fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }),
                                const Divider(),
                                Text(
                                  "Submit your review",
                                  style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: List.generate(5, (index) {
                                    return IconButton(
                                      icon: Icon(
                                        index < selectedRating ? Icons.star : Icons.star_border,
                                        color: Colors.amber,
                                      ),
                                      onPressed: () {
                                        // onRatingSelected(index + 1);

                                        setState(() {
                                          selectedRating = index + 1;
                                        });
                                        log("selectedRating: ${selectedRating}");
                                        log("index: ${index}");
                                      },
                                    );
                                  }),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: reviewController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: "Write your review here...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.grey),
                                    ),
                                    contentPadding: const EdgeInsets.all(12),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Consumer<SitterServices>(builder: (context, value, _) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // Add your review submission logic here
                                        log("_newReviewRating: ${_newReviewRating}");
                                        log("reviewController.text.isEmpty: ${reviewController.text.isEmpty}");
                                        if (selectedRating == 0 || reviewController.text.isEmpty) {
                                          showToast(
                                              message: "Fill all the fields",
                                              type: ToastificationType.success);
                                          return;
                                        }
                                        final resp = await value.submitSitterReview(
                                            sitter_id: widget.sitter.id,
                                            rating: selectedRating,
                                            review_description: reviewController.text);

                                        if (resp == true) {
                                          showToast(
                                              message: "Your review has been submitted.",
                                              type: ToastificationType.success);
                                          navigateToHome();
                                        } else {
                                          showToast(
                                              message: "Some error occurred. Try again later.",
                                              type: ToastificationType.error);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AssetManager.baseTextColor11,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: Text(
                                        "Submit Review",
                                        style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: () {
              // Add your contact logic here
              _showContactDialog(context);
            },
            backgroundColor: AssetManager.baseTextColor11,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            label: Text(
              "Contact this sitter",
              style: GoogleFonts.lato(fontSize: 15, color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildStarRatingInput(ValueChanged<int> onRatingSelected) {
    int selectedRating = 0;
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < selectedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            onRatingSelected(index + 1);
            setState(() {
              selectedRating = index + 1;
            });
          },
        );
      }),
    );
  }

  Widget _buildStarRating(int rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(
        Icon(
          size: 16,
          i <= rating ? Icons.star : Icons.star_border,
          color: i <= rating ? Colors.amber : Colors.grey,
        ),
      );
    }
    return Row(children: stars);
  }

  Widget _buildInfoSection(String info) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        info,
        style: GoogleFonts.abel(fontSize: 16),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildServicesSection(List<Services> services) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: services.map((data) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon(data.serviceIcon, size: 24, color: Colors.blueGrey),
                Row(
                  children: [
                    CachedNetworkImage(
                        imageUrl: "https://chihu.infyedgesolutions.com/${data.service_logo}" ?? "",
                        height: 24,
                        width: 24),
                    const SizedBox(width: 20),
                    Text(
                      data.service_name.toString(),
                      style: GoogleFonts.abel(fontSize: 16),
                    ),
                  ],
                ),
                Icon(Icons.work_outline)
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    final List<Services> selectedServices = [];
    final TextEditingController addressController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Consumer<Appstore>(builder: (context, value, _) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.white,
                title: Text(
                  "Book a Service",
                  style: GoogleFonts.lato(
                    color: AssetManager.baseTextColor11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: double.maxFinite, // Ensure the dialog takes the maximum width
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.sitter.services == null || widget.sitter.services!.isEmpty
                            ? const Center(
                                child: Text(
                                  "No services available",
                                  style: TextStyle(
                                    color: AssetManager.baseTextColor11,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(), // Prevent scrolling within ListView
                                itemCount: widget.sitter.services!.length,
                                itemBuilder: (context, index) {
                                  final service = widget.sitter.services![index];
                                  bool isSelected = selectedServices.contains(service);

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedServices.remove(service);
                                        } else {
                                          selectedServices.add(service);
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
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.error),
                                          ),
                                          const SizedBox(width: 10),
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
                        const SizedBox(height: 10),

                        // TextField for entering address
                        TextField(
                          controller: addressController,
                          decoration: InputDecoration(
                            labelText: "Enter your address",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Row for selecting date and time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      selectedDate = pickedDate;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AssetManager.baseTextColor11,
                                ),
                                child: Text(
                                  selectedDate == null
                                      ? "Select date"
                                      : "Booking Date: ${selectedDate!.toLocal()}".split(' ')[0],
                                  style: GoogleFonts.lato(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    setState(() {
                                      selectedTime = pickedTime;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AssetManager.baseTextColor11,
                                ),
                                child: Text(
                                  selectedTime == null
                                      ? "Select time"
                                      : "Booking Time: ${selectedTime!.format(context)}",
                                  style: GoogleFonts.lato(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.lato(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      log("executing bookSitter");

                      if (value.user?.userId == 0 || widget.sitter.id == 0) {
                        showToast(
                            message: "You're not signed in. Try re-login.", type: ToastificationType.error);
                        return;
                      }
                      if (addressController.text.isEmpty) {
                        showToast(message: "Please enter your location.", type: ToastificationType.error);
                        return;
                      }
                      if (selectedServices.isEmpty) {
                        showToast(message: "Please select a service", type: ToastificationType.error);
                        return;
                      }

                      if (selectedTime == null || selectedDate == null) {
                        showToast(message: "Please select date and time.", type: ToastificationType.error);
                        return;
                      }

                      final resp = await Provider.of<SitterServices>(context, listen: false).bookSitter(
                          user_id: value.user?.userId ?? 0,
                          sitter_id: widget.sitter.id ?? 0,
                          service_id: selectedServices.first.service_id ?? 0,
                          address: addressController.text,
                          booking_date: selectedDate?.toIso8601String() ?? "",
                          booking_time:
                              "${selectedTime?.hour.toString() ?? ""}:${selectedTime?.minute.toString() ?? ""}");

                      if (resp == true) {
                        showToast(message: "Sitter booked successfully.", type: ToastificationType.success);
                        navigateToHome();
                      } else {
                        showToast(
                            message: "Some error occurred. Try again later.", type: ToastificationType.error);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AssetManager.baseTextColor11,
                    ),
                    child: Text(
                      "Submit",
                      style: GoogleFonts.lato(color: Colors.white),
                    ),
                  ),
                ],
              );
            });
          }),
        );
      },
    );
  }

  void navigateToHome() async {
    Navigator.pop(context);
  }
}
