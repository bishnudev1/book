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
      ratingAndReview: '4.7, (12)',
      services: ['Car', 'Gym', 'Luggage'],
      userPrice: '\$12 per Hour',
    ),
    User(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      destination: '5 miles away',
      ratingAndReview: '4.7, (12)',
      services: ['Car', 'Gym', 'Cooking'],
      userPrice: '\$12 per Hour',
    ),
    User(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      destination: '5 miles away',
      ratingAndReview: '4.7, (12)',
      services: ['Luggage'],
      userPrice: '\$12 per Hour',
    ),
    User(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      destination: '5 miles away',
      ratingAndReview: '4.7, (12)',
      services: ['Gym', 'Car'],
      userPrice: '\$12 per Hour',
    ),
    // Additional users...
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
    // Getting device width and height
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double padding = deviceWidth * 0.06; // Dynamic padding

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
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
                      icon: const Icon(Icons.search, color: Colors.white),
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
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 4,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              // userList[index].profilePhoto,
                              AssetManager.dummyPersonDP,
                              height: deviceHeight * 0.15,
                              width: deviceWidth * 0.25,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: deviceWidth * 0.04),
                          Expanded(
                            child: Column(
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
                                SizedBox(height: deviceHeight * 0.01),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.redAccent),
                                    SizedBox(width: deviceWidth * 0.01),
                                    Text(
                                      userList[index].destination,
                                      style: GoogleFonts.lato(
                                        fontSize: deviceWidth * 0.035,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: deviceHeight * 0.01),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber),
                                    SizedBox(width: deviceWidth * 0.01),
                                    Text(
                                      userList[index].ratingAndReview,
                                      style: GoogleFonts.lora(
                                        fontSize: deviceWidth * 0.035,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: deviceHeight * 0.01),

                                // Service Tags
                                Wrap(
                                  spacing: deviceWidth * 0.02,
                                  children: [
                                    for (var service in ['Cooking', 'Gym', 'Car', 'Luggage'])
                                      _buildServiceTag(service, userList[index].services),
                                  ],
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

  Widget _buildServiceTag(String service, List<String> providedServices) {
    bool isServiceProvided = providedServices.contains(service);
    return Chip(
      label: Text(
        service,
        style: TextStyle(
          color: isServiceProvided ? Colors.white : Colors.black54,
        ),
      ),
      avatar: Icon(
        isServiceProvided ? Icons.check : Icons.close,
        color: Colors.white,
      ),
      backgroundColor: isServiceProvided ? Colors.green : Colors.grey.shade400,
    );
  }
}
