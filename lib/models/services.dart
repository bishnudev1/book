import 'package:flutter/material.dart';

class Services {
  final IconData serviceIcon;
  final String serviceText;
  bool isSelected;

  Services({
    required this.serviceIcon,
    required this.serviceText,
    this.isSelected = false, // Default to false if not selected
  });
}
