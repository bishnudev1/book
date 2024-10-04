import 'dart:developer';

import 'package:book/models/sitter.dart';
import 'package:book/services/appstore.dart';
import 'package:book/services/auth_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  }

  List<Sitter> _sitterList = []; // Filtered list
  List<Sitter> _originalSitterList = []; // Backup for the original list
  List<Sitter> get sitterList => _sitterList;

  List<Services> _servicesList = [];
  List<Services> get servicesList => _servicesList;

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

        log("Sitter list: $_sitterList");
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
        final sitter = Sitter.fromJson(response.data['userDet']);
        await appstore.storeSitterLoggedInUser(sitter: sitter);
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
}
// 