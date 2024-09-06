import 'package:book/utils/asset_manager.dart';
import 'package:book/views/sitter/sitter_screen.dart';
import 'package:book/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user.dart';
import '../../widgets/exit_app.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  TextEditingController searchFieldController = TextEditingController();

  List<Sitter> userList = [
    Sitter(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      destination: '5 miles away',
      info:
          "Experienced pet sitter who loves animals. I have taken care of dogs, cats, and small pets for over 5 years. I can also provide basic training and grooming.",
      ratingStars: 4,
      services: [
        Services(serviceIcon: Icons.car_rental_rounded, serviceText: 'Car'),
        Services(serviceIcon: Icons.sports_gymnastics_rounded, serviceText: 'Gym'),
      ],
      userPrice: '\$12 per Hour',
    ),
    Sitter(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      destination: '5 miles away',
      info:
          "Friendly and reliable pet sitter. I am flexible with timing and can take care of pets overnight. I can handle pets of all sizes and temperaments.",
      ratingStars: 3,
      services: [
        Services(serviceIcon: Icons.car_rental_rounded, serviceText: 'Car'),
        Services(serviceIcon: Icons.sports_gymnastics_rounded, serviceText: 'Gym'),
        Services(serviceIcon: Icons.cookie_outlined, serviceText: 'Cooking'),
      ],
      userPrice: '\$12 per Hour',
    ),
    Sitter(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      info:
          "Professional pet sitter with a focus on the well-being of your pets. I provide daily walks, feeding, and playtime, ensuring your pets are happy and healthy.",
      destination: '5 miles away',
      ratingStars: 5,
      services: [
        Services(serviceIcon: Icons.luggage_rounded, serviceText: 'Luggage'),
      ],
      userPrice: '\$12 per Hour',
    ),
    Sitter(
      profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
      userName: 'Deepak Kumar',
      info:
          "Passionate pet sitter available for last-minute bookings. I offer a calm and safe environment for your pets while you're away.",
      destination: '5 miles away',
      ratingStars: 4,
      services: [
        Services(serviceIcon: Icons.sports_gymnastics_rounded, serviceText: 'Gym'),
      ],
      userPrice: '\$12 per Hour',
    ),
    // Additional users...
  ];

  // List of all available services
  List<Services> allServicesList = [
    Services(serviceIcon: Icons.car_rental_rounded, serviceText: 'Car'),
    Services(serviceIcon: Icons.sports_gymnastics_rounded, serviceText: 'Gym'),
    Services(serviceIcon: Icons.cookie_outlined, serviceText: 'Cooking'),
    Services(serviceIcon: Icons.luggage_rounded, serviceText: 'Luggage'),
    // Add other services here...
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
                'Book a Sitter',
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

              // ListView
              Expanded(
                child: ListView.builder(
                  itemCount: userList.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => SitterScreen(sitter: userList[index])));
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
                              children: allServicesList.map((service) {
                                if (userList[index]
                                    .services
                                    .any((s) => s.serviceIcon == service.serviceIcon)) {
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

  Widget _buildServiceTag(Services service) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          service.serviceIcon,
          color: Colors.blueAccent,
          size: 28,
        ),
        // SizedBox(height: 4),
        // Text(
        //   service.serviceText ?? '',
        //   style: GoogleFonts.openSans(
        //     fontSize: 12,
        //     color: Colors.black87,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildExcludedServiceTag(Services service) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              service.serviceIcon,
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
        ),
        // SizedBox(height: 4),
        // Text(
        //   service.serviceText ?? '',
        //   style: GoogleFonts.openSans(
        //     fontSize: 12,
        //     color: Colors.grey,
        //   ),
        // ),
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
