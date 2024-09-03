import 'package:book/utils/asset_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  TextEditingController searchFieldController = TextEditingController();

  List<User> userList = [
    User(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      destination: '5 miles away',
      ratingStars: 4,
      services: [
        Icons.car_rental_rounded,
        Icons.sports_gymnastics_rounded,
      ],
      userPrice: '\$12 per Hour',
    ),
    User(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      destination: '5 miles away',
      ratingStars: 3,
      services: [Icons.car_rental_rounded, Icons.sports_gymnastics_rounded, Icons.cookie_outlined],
      userPrice: '\$12 per Hour',
    ),
    User(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      destination: '5 miles away',
      ratingStars: 5,
      services: [Icons.luggage_rounded],
      userPrice: '\$12 per Hour',
    ),
    User(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      destination: '5 miles away',
      ratingStars: 4,
      services: [Icons.sports_gymnastics_rounded],
      userPrice: '\$12 per Hour',
    ),
    // Additional users...
  ];

  // List of all available services
  final List<IconData> allServices = [
    Icons.car_rental_rounded,
    Icons.sports_gymnastics_rounded,
    Icons.cookie_outlined,
    Icons.luggage_rounded,
    // Add other service icons here...
  ];

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

              // Heading Text
              Text(
                'Book a Ride',
                style: GoogleFonts.montserrat(
                  fontSize: deviceWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: deviceHeight * 0.03),

              // Search Field and Filter Icon
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
                      color: Colors.blueAccent,
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

              // ListView
              Expanded(
                child: ListView.builder(
                  itemCount: userList.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
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
                                  // userList[index].profilePhoto,
                                  AssetManager.dummyPersonDP,
                                  height: deviceHeight * 0.15,
                                  width: deviceHeight * 0.15, // Circular image
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: deviceWidth * 0.04),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userList[index].userName,
                                    style: GoogleFonts.roboto(
                                      fontSize: deviceWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: deviceHeight * 0.005),
                                  _buildStarRating(userList[index].ratingStars),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: deviceHeight * 0.015),

                          // Services Logos
                          Wrap(
                            spacing: 8,
                            children: allServices.map((service) {
                              if (userList[index].services.contains(service)) {
                                return _buildServiceTag(service);
                              } else {
                                return _buildExcludedServiceTag(service);
                              }
                            }).toList(),
                          ),

                          SizedBox(height: deviceHeight * 0.015),

                          // Additional information
                          Text(
                            "A short description or additional information about the user or the services they provide.",
                            style: GoogleFonts.lato(
                              fontSize: deviceWidth * 0.035,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.015),
                          Text(
                            userList[index].userPrice,
                            style: GoogleFonts.poppins(
                              color: Colors.green,
                              fontSize: deviceWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceTag(IconData serviceIcon) {
    return Icon(
      serviceIcon,
      color: Colors.blueAccent,
      size: 28,
    );
  }

  Widget _buildExcludedServiceTag(IconData serviceIcon) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          serviceIcon,
          color: Colors.grey,
          size: 28,
        ),
        Positioned(
          child: Icon(
            Icons.clear,
            color: Colors.redAccent,
            size: 18,
          ),
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
