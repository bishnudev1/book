import 'package:flutter/material.dart';

class User {
  String profilePhoto;
  String userName;
  String destination;
  int ratingStars;
  List<IconData> services;
  String userPrice;

  User({
    required this.profilePhoto,
    required this.userName,
    required this.destination,
    required this.ratingStars,
    required this.services,
    required this.userPrice,
  });
}
