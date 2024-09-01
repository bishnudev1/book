import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        vehicle: 'Honda Accord ',
        userPrice: '\$12 per Hour'),
    User(
        profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
        userName: 'Deepak Kumar',
        destination: '5 miles away',
        ratingAndReview: '4.7, (12)',
        vehicle: 'Honda Accord',
        userPrice: '\$12 per Hour'),
    User(
        profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
        userName: 'Deepak Kumar',
        destination: '5 miles away',
        ratingAndReview: '4.7, (12)',
        vehicle: 'Honda Accord',
        userPrice: '\$12 per Hour'),
    User(
        profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
        userName: 'Deepak Kumar',
        destination: '5 miles away',
        ratingAndReview: '4.7, (12)',
        vehicle: 'Honda Accord',
        userPrice: '\$12 per Hour'),
    User(
        profilePhoto: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
        userName: 'Deepak Kumar',
        destination: '5 miles away',
        ratingAndReview: '4.7, (12)',
        vehicle: 'Honda Accord',
        userPrice: '\$12 per Hour'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              /// Heading Text
              const Text(
                'Book',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// Search Field and
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Search Field
                  Expanded(
                    child: Container(
                      // height: 50,
                      padding: const EdgeInsets.only(left: 10),
                      margin: const EdgeInsets.only(top: 16, right: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: searchFieldController,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Filter Icon
                  const Icon(
                    Icons.filter_list,
                    color: Colors.black,
                    size: 24,
                  ),
                ],
              ),

              /// ListView
              Expanded(
                child: ListView.builder(
                  itemCount: userList.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              '${userList[index].profilePhoto}',
                              height: 160,
                              width: 135,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${userList[index].userName}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                  ),
                                  Text(
                                    '${userList[index].destination}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                  ),
                                  Text(
                                    '${userList[index].ratingAndReview}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.directions_bike_rounded,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${userList[index].vehicle}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${userList[index].userPrice}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
}
