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
  final IconData serviceIcon;
  final String? serviceText;
  final String? serviceDescription;
  bool isSelected;

  Services({
    required this.serviceIcon,
    required this.serviceText,
    required this.serviceDescription,
    this.isSelected = false,
  });
}
