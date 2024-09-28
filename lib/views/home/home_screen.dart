import 'package:book/services/appstore.dart';
import 'package:book/services/sitter_services.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/sitter.dart';
import '../../models/user.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  TextEditingController searchFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double padding = deviceWidth * 0.06; // Dynamic padding

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: deviceHeight * 0.07),
              Text(
                'Book a Sitter',
                style: GoogleFonts.montserrat(
                  fontSize: deviceWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: deviceHeight * 0.03),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      margin: const EdgeInsets.only(right: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: searchFieldController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Search for rides...',
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.openSans(
                          fontSize: deviceWidth * 0.04,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AssetManager.baseTextColor11,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list_alt, color: Colors.white),
                      onPressed: () {
                        // TODO: Add filter functionality
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: deviceHeight * 0.01),
              Expanded(
                child: Consumer<SitterServices>(builder: (context, value, _) {
                  if (value.sitterList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final List<Sitter> userList = value.sitterList;
                  return ListView.builder(
                    itemCount: userList.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.push("/sitter", extra: userList[index]);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: deviceHeight * 0.02),
                          padding: EdgeInsets.all(deviceWidth * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      AssetManager.dummyPersonDP,
                                      height: deviceHeight * 0.15,
                                      width: deviceHeight * 0.15,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: deviceWidth * 0.04),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userList[index].first_name ?? "",
                                        style: GoogleFonts.roboto(
                                          fontSize: deviceWidth * 0.045,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: deviceHeight * 0.005),
                                      _buildStarRating(
                                        int.parse(userList[index].rating ?? "0"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: deviceHeight * 0.015),
                              Wrap(
                                spacing: 8,
                                children: userList[index]
                                    .services!
                                    .map((service) => _buildServiceTag(service))
                                    .toList(),
                              ),
                              SizedBox(height: deviceHeight * 0.015),
                              Text(
                                userList[index].description ?? "",
                                style: GoogleFonts.lato(
                                  fontSize: deviceWidth * 0.035,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: deviceHeight * 0.015),
                              Text(
                                "\$${userList[index].per_hour_rate}/hour",
                                style: GoogleFonts.poppins(
                                  color: Colors.green,
                                  fontSize: deviceWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildServiceTag(Services service) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(
  //         Icons.image, // Update to show real icons
  //         color: Colors.blueAccent,
  //         size: 28,
  //       ),
  //     ],
  //   );
  // }
  Widget _buildServiceTag(Services service) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Using Image.network to load the service logo
        Image.network(
          "https://chihu.infyedgesolutions.com/${service.service_logo}" ??
              '', // Ensure service_logo is not null
          width: 28, // Set a desired width
          height: 28, // Set a desired height
          fit: BoxFit.cover, // Adjust the image to cover the area
          errorBuilder: (context, error, stackTrace) {
            // Display a placeholder if the image fails to load
            return Icon(
              Icons.error,
              color: Colors.red,
              size: 28,
            );
          },
        ),
        SizedBox(height: 4), // Add some spacing
        Text(
          service.service_name ?? '', // Display service name below the image
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildStarRating(int rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(
        Icon(
          i <= rating ? Icons.star : Icons.star_border,
          color: i <= rating ? Colors.amber : Colors.grey,
        ),
      );
    }
    return Row(children: stars);
  }
}
