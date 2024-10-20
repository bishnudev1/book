import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'sitter.g.dart';

@HiveType(typeId: 1)
class Sitter extends HiveObject {
  @HiveField(0)
  String? first_name;

  @HiveField(1)
  String? last_name;

  @HiveField(2)
  String? rating;

  @HiveField(3)
  String? description;

  @HiveField(4)
  List<Services>? services;

  @HiveField(5)
  int? per_hour_rate;

  @HiveField(6)
  String? email;

  @HiveField(7)
  String? user_type;

  @HiveField(8)
  String? zip_code;

  @HiveField(9)
  int? id;

  @HiveField(10)
  String? profile_pic;

  Sitter(
      {this.first_name,
      this.last_name,
      this.rating,
      this.description,
      this.services,
      this.per_hour_rate,
      this.email,
      this.user_type,
      this.zip_code,
      this.id,
      this.profile_pic});

  // Factory method for converting JSON to Sitter object
  factory Sitter.fromJson(Map<String, dynamic> json) {
    return Sitter(
      first_name: json['first_name'],
      last_name: json['last_name'],
      rating: json['rating'] != "" ? json['rating'].toString() : null,
      description: json['description'],
      email: json['email'],
      user_type: json['user_type'],
      id: json["user_id"],
      zip_code: json['zip_code'],
      profile_pic: json['profile_pic'],
      // Safely parsing per_hour_rate as int
      per_hour_rate: json['per_hour_rate'] is int
          ? json['per_hour_rate']
          : int.tryParse(json['per_hour_rate'].toString()),
      services: (json['serviceDet'] as List?)?.map((e) => Services.fromJson(e)).toList(),
    );
  }

  // Convert Sitter object to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'last_name': last_name,
      'rating': rating,
      'user_type': user_type,
      'email': email,
      'user_id': id,
      'description': description,
      'profile_pic': profile_pic,
      'per_hour_rate': per_hour_rate,
      'zip_code': zip_code,
      'serviceDet': services?.map((e) => e.toJson()).toList(),
    };
  }
}

class Services {
  final int? id;
  final int? sitter_id;
  final int? service_id;
  final String? service_name;
  final String? service_logo;

  Services({
    this.id,
    this.sitter_id,
    this.service_id,
    this.service_name,
    this.service_logo,
  });

  // Factory method for converting JSON to Services object
  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['id'],
      sitter_id: json['sitter_id'],
      service_id: json['service_id'],
      service_name: json['service_name'],
      service_logo: json['service_logo'],
    );
  }

  // Convert Services object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sitter_id': sitter_id,
      'service_id': service_id,
      'service_name': service_name,
      'service_logo': service_logo,
    };
  }
}
