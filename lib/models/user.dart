import 'package:flutter/material.dart';

class Sitter {
  String profilePhoto;
  String userName;
  String info;
  String destination;
  int ratingStars;
  List<Services> services;
  String userPrice;

  Sitter({
    required this.profilePhoto,
    required this.userName,
    required this.info,
    required this.destination,
    required this.ratingStars,
    required this.services,
    required this.userPrice,
  });
}

class Services {
  String? serviceText;
  IconData? serviceIcon;

  Services({this.serviceIcon, this.serviceText});
}
