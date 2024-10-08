import 'package:book/models/sitter.dart';
import 'package:book/models/user.dart';
import 'package:book/utils/asset_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      Image.asset(
                        AssetManager.dummyPersonDP,
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
                            // backgroundImage: CachedNetworkImageProvider(widget.sitter.profilePhoto ?? ""),
                            backgroundImage: const AssetImage(AssetManager.dummyPersonDP),
                          ),
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
                    height: 300, // Adjust this height based on your content
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildInfoSection(widget.sitter.description ?? ""),
                        _buildServicesSection(widget.sitter.services ?? []),
                        const Center(child: Text("No reviews yet")),
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
                // Icon(data.serviceIcon, size: 24, color: Colors.blueGrey),
                CachedNetworkImage(
                    imageUrl: "https://chihu.infyedgesolutions.com/${data.service_logo}" ?? "",
                    height: 24,
                    width: 24),
                const SizedBox(width: 10),
                Text(
                  data.service_name.toString(),
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
