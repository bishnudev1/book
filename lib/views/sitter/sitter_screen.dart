import 'package:book/models/user.dart';
import 'package:book/views/home/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/exit_app.dart';

class SitterScreen extends StatefulWidget {
  final Sitter sitter;
  const SitterScreen({super.key, required this.sitter});

  @override
  State<SitterScreen> createState() => _SitterScreenState();
}

class _SitterScreenState extends State<SitterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.blueGrey,
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.sitter.userName,
          style: GoogleFonts.lato(
            fontSize: 17,
          ),
        ),
        actions: [
          Icon(
            Icons.share_outlined,
            color: const Color.fromARGB(255, 39, 39, 39),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: widget.sitter.userName == ""
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.sitter.profilePhoto,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                            backgroundImage: CachedNetworkImageProvider(widget.sitter.profilePhoto),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60), // Adjust this value as needed
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.sitter.userName,
                          style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildStarRating(widget.sitter.ratingStars),
                        SizedBox(height: 8),
                        Text(
                          "Destination: ${widget.sitter.destination}",
                          style: GoogleFonts.abel(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Price: ${widget.sitter.userPrice}",
                          style: GoogleFonts.abel(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(text: "Info"),
                      Tab(text: "Services"),
                      Tab(text: "Reviews"),
                    ],
                  ),
                  SizedBox(
                    height: 300, // Adjust this height based on your content
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildInfoSection(widget.sitter.info),
                        _buildServicesSection(widget.sitter.services),
                        Center(child: Text("No reviews yet")),
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
            },
            backgroundColor: const Color.fromARGB(255, 36, 114, 178),
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
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Icon(data.serviceIcon, size: 24, color: Colors.blueGrey),
                SizedBox(width: 10),
                Text(
                  data.serviceText.toString(),
                  style: GoogleFonts.abel(fontSize: 16),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
