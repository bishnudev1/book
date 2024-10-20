import 'dart:developer';

import 'package:book/models/sitter.dart';
import 'package:book/services/appstore.dart';
import 'package:book/services/auth_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../views/sitter/dashboard.dart';

class SitterServices with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isAuth = false;
  bool get isAuth => _isAuth;

  AuthServices authServices = AuthServices();
  Appstore appstore = Appstore();

  SitterServices() {
    authServices.initialize();
    appstore.initializeSitterData();
    appstore.initializeUserData();
  }

  List _bookedUserList = [];
  List get bookedUserList => _bookedUserList;

  List<Sitter> _sitterList = []; // Filtered list
  List<Sitter> _originalSitterList = []; // Backup for the original list
  List<Sitter> get sitterList => _sitterList;

  List<Services> _servicesList = [];
  List<Services> get servicesList => _servicesList;

  List<Services> _selectedCategories = [];
  double _selectedPriceRange = 0;

  List _sitterReviews = [];
  List get sitterReviews => _sitterReviews;

  List<Services> get selectedCategories => _selectedCategories;
  double get selectedPriceRange => _selectedPriceRange;

  /// Filter sitter list by name
  filterSitterListByName(String value) {
    if (value.isEmpty) {
      _sitterList = List.from(_originalSitterList); // Restore original list
    } else {
      _sitterList = _originalSitterList
          .where((element) => element.first_name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Filter Sitter by categories, price range
  void filterSitterListByCategories(List<Services> categories, double priceRange) {
    _selectedCategories = categories; // Store selections
    _selectedPriceRange = priceRange;

    log('Selected Categories: ${categories.map((e) => e.service_name).toList()}');
    log('Selected Price Range: $priceRange');

    if (categories.isEmpty && priceRange == 0) {
      log('No filters applied, using original sitter list');
      _sitterList = _originalSitterList;
    } else {
      // Filter based on categories (service_name or id) or price range or both
      if (categories.isNotEmpty && priceRange == 0) {
        // Only filter based on selected categories (either by service_name or id)
        log('Filtering by categories only');
        _sitterList = _originalSitterList.where((element) {
          bool matches = categories.any((category) => element.services!
              .any((service) => service.service_name == category.service_name || service.id == category.id));

          log('Sitter: ${element.first_name}, Services: ${element.services!.map((s) => s.service_name).toList()}, Matches Categories: $matches');
          return matches;
        }).toList();
      } else if (categories.isEmpty && priceRange != 0) {
        // Only filter based on price range
        log('Filtering by price range only');
        _sitterList = _originalSitterList.where((element) {
          bool matches = element.per_hour_rate! <= priceRange;

          log('Sitter: ${element.first_name}, Per Hour Rate: ${element.per_hour_rate}, Matches Price Range: $matches');
          return matches;
        }).toList();
      } else {
        // Filter based on both categories and price range
        log('Filtering by both categories and price range');
        _sitterList = _originalSitterList.where((element) {
          bool matchesCategories = categories.any((category) => element.services!
              .any((service) => service.service_name == category.service_name || service.id == category.id));
          bool matchesPrice = element.per_hour_rate! <= priceRange;

          log('Sitter: ${element.first_name}, Services: ${element.services!.map((s) => s.service_name).toList()}, Matches Categories: $matchesCategories, Per Hour Rate: ${element.per_hour_rate}, Matches Price Range: $matchesPrice');
          return matchesCategories && matchesPrice;
        }).toList();
      }
    }

    log('Filtered Sitter List Length: ${_sitterList.length}');
    notifyListeners();
  }

  Future<void> getSitterListByPinCode({required String pinCode}) async {
    try {
      _isLoading = true;
      notifyListeners(); // Notify listeners that loading has started

      // Fetch sitter list by pin code from API
      final resp = await authServices.dio!.post(
        '/pincode-wise-sitter',
        data: {
          'pincode': pinCode,
        },
      );

      if (resp.statusCode == 200) {
        // Deserialize the response to a list of `Sitter` objects
        List sitterData = resp.data['sitter_list'] as List;
        _sitterList = sitterData.map((data) => Sitter.fromJson(data)).toList();
        _originalSitterList = List.from(_sitterList);

        log("Sitter list: ${_sitterList[0].per_hour_rate}");
        _isLoading = false;
        notifyListeners(); // Notify listeners that loading has finished
      } else {
        _sitterList = [];
        log("Failed to fetch sitters, response code: ${resp.statusCode}");
        _isLoading = false;
        notifyListeners(); // Notify listeners that loading has finished
      }
    } catch (e) {
      log("Error fetching sitters: $e");
      _sitterList = [];
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading has finished
    }
  }

  Future<bool?> sitter_register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String zip_code,
    required String description,
    required String per_hourse_rate,
    required String coma_sep_service_id,
  }) async {
    try {
      log("coma_sep_service_id: ${coma_sep_service_id}");
      _isLoading = true;
      notifyListeners();
      final response = await authServices.dio!.post(
        '/sitter-registration',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'zip_code': zip_code,
          'password': password,
          'description': description,
          'per_hourse_rate': per_hourse_rate,
          'coma_sep_service_id': coma_sep_service_id,
        },
      );

      if (response.statusCode == 200 &&
          response.data['status'] != 'error' &&
          response.data["status"] == "success") {
        // final sitter = Sitter.fromJson(response.data['userDet']);
        // await appstore.storeSitterLoggedInUser(sitter: sitter);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return response.data['message'] ?? 'Unknown error occurred';
      }
    } on PlatformException catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    } on DioException catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  getAllSitterServices() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await authServices.dio!.get('/service-list');
      if (response.statusCode == 200 && response.data['status'] != 'error') {
        _isLoading = false;
        notifyListeners();
        List servicesData = response.data['service_list'] as List;
        _servicesList = servicesData.map((data) => Services.fromJson(data)).toList();

        log("Services list: $_servicesList");
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return response.data['message'] ?? 'Unknown error occurred';
      }
    } on PlatformException catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    } on DioException catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void resetFilters() {
    _selectedCategories = [];
    _selectedPriceRange = 0;
    notifyListeners();
  }

  bookSitter(
      {required int user_id,
      required int sitter_id,
      required int service_id,
      required String address,
      required String booking_date,
      required String booking_time}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await authServices.dio!.post(
        '/sitter-booking',
        data: {
          'user_id': user_id,
          'sitter_id': sitter_id,
          'service_id': service_id,
          'address': address,
          'booking_date': booking_date,
          'booking_time': booking_time,
        },
      );
      log("response.data:${response.data}");
      if (response.statusCode == 200 && response.data["status"] == "success") {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on PlatformException catch (e) {
      log("PlatformException: ${e}");
      _isLoading = false;
      notifyListeners();
      return false;
    } on DioException catch (e) {
      log("DioException: ${e}");
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      log("catch: ${e}");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  submitSitterReview({
    required sitter_id,
    required int rating,
    required String review_description,
    // required String booking_date,
    // required String booking_time
  }) async {
    try {
      log("rating in submitSitterReview: ${rating}");
      log("sitter_id in submitSitterReview: ${sitter_id}");
      log("user_id in submitSitterReview: ${appstore.user?.userId}");
      _isLoading = true;
      notifyListeners();

      if (appstore.user?.userId == null) {
        await appstore.initializeUserData();
      }
      log("user_id in submitSitterReview again: ${appstore.user?.userId}");
      final response = await authServices.dio!.post(
        '/user-review',
        data: {
          'user_id': appstore.user?.userId,
          'sitter_id': sitter_id,
          'rating': rating,
          'review_description': review_description,
          'review_title': "This is title",
        },
      );
      log("response.data in submit review:${response.data}");
      if (response.statusCode == 200 && response.data["status"] == "success") {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on PlatformException catch (e) {
      log("PlatformException: ${e}");
      _isLoading = false;
      notifyListeners();
      return false;
    } on DioException catch (e) {
      log("DioException: ${e}");
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      log("catch: ${e}");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  getSitterReviewList({required String sitter_id}) async {
    try {
      log("sitter_id for fetching review_list: ${sitter_id}");
      _isLoading = true;
      notifyListeners();
      final response = await authServices.dio!.post(
        '/sitter-review-list',
        data: {'sitter_id': sitter_id},
      );
      log("response.data:${response.data}");
      if (response.statusCode == 200 && response.data["status"] == "success") {
        final data = response.data["review_list"];
        _sitterReviews = data;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on PlatformException catch (e) {
      log("PlatformException: ${e}");
      _isLoading = false;
      notifyListeners();
      return false;
    } on DioException catch (e) {
      log("DioException: ${e}");
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      log("catch: ${e}");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  getUserBookingList({required int sitter_id}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response =
          await authServices.dio!.post('/sitterwise-booking-list', data: {"sitter_id": sitter_id});

      if (response.statusCode == 200) {
        log("userBookingList for sitter id ${appstore.sitter?.id}: ${response.data}");
        _bookedUserList = response.data;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } on PlatformException catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    } on DioException catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  updateBookingStatus({required int status, required booking_id, required BuildContext context}) async {
    try {
      _isLoading = true;
      notifyListeners();

      log("status: ${status}");
      log("booking_id: ${booking_id}");
      log("sitter_id: ${appstore.sitter?.id}");

      if (appstore.sitter?.id == null) {
        await appstore.initializeSitterData();
      }

      log("sitter_id again: ${appstore.sitter?.id}");

      final response = await authServices.dio!.post(
        '/sitter-change-status',
        data: {
          'status': status.toString(),
          'sitter_id': appstore.sitter?.id,
          'booking_id': booking_id.toString(),
        },
      );

      log("response.data:${response.data}");

      if (response.statusCode == 200 && response.data["status"] == "success") {
        _isLoading = false;
        notifyListeners();

        return status == 1 ? "Accepted" : "Rejected";
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on PlatformException catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    } on DioException catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
}
// 