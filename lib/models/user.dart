import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user.g.dart'; // This file will be generated by build_runner

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String? userType;

  @HiveField(1)
  String? firstName;

  @HiveField(2)
  String? lastName;

  @HiveField(3)
  String? zipCode;

  @HiveField(4)
  String? email;

  @HiveField(5)
  int? userId;

  @HiveField(6)
  String? profile_pic;

  User(
      {this.userType,
      this.firstName,
      this.lastName,
      this.zipCode,
      this.email,
      this.userId,
      this.profile_pic});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userType: json['user_type'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      zipCode: json['zip_code'],
      email: json['email'],
      profile_pic: json['profile_pic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_type': userType,
      'first_name': firstName,
      'last_name': lastName,
      'zip_code': zipCode,
      'email': email,
      'profile_pic': profile_pic,
    };
  }
}

// @HiveType(typeId: 1)
// class Services extends HiveObject {
//   @HiveField(0)
//   final IconData serviceIcon; // Save as a String instead of IconData

//   @HiveField(1)
//   final String? serviceText;

//   @HiveField(2)
//   final String? serviceDescription;

//   @HiveField(3)
//   bool isSelected;

//   Services({
//     required this.serviceIcon, // Store icon name
//     required this.serviceText,
//     required this.serviceDescription,
//     this.isSelected = false,
//   });

//   factory Services.fromJson(Map<String, dynamic> json) {
//     return Services(
//       serviceIcon: IconData(json['serviceIcon'], fontFamily: 'MaterialIcons'),
//       serviceText: json['serviceText'],
//       serviceDescription: json['serviceDescription'],
//       isSelected: json['isSelected'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'serviceIcon': serviceIcon.codePoint,
//       'serviceText': serviceText,
//       'serviceDescription': serviceDescription,
//       'isSelected': isSelected,
//     };
//   }
// }
