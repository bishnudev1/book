import 'package:book/models/sitter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'dart:developer';

import '../models/user.dart';

class Appstore with ChangeNotifier {
  late Box<User> _userBox;
  late Box<Sitter> _sitterBox;
  User? _user;

  User? get user => _user;

  Sitter? _sitter;

  Sitter? get sitter => _sitter;

  bool _isLoading = false;
  bool _isSignedIn = false;

  bool _isSitterSignedIn = false;
  bool get isSitterSignedIn => _isSitterSignedIn;

  // bool _isSitter = false;

  // Getter methods for other classes to access
  Box<User> get box => _userBox;
  bool get isSignedIn => _isSignedIn;

  Future<void> initializeUserData() async {
    log("Initializing user data");

    // Initialize Hive box for the user
    try {
      _userBox = await Hive.openBox<User>('user');
      log("UserBox opened: ${_userBox.isOpen}");
    } catch (e) {
      log("Error opening user box: $e");
      return; // Return early if there's an error
    }

    // Fetch user data
    _user = _userBox.get('user') ?? User();
    log("User data initialized: ${_user?.firstName}");

    // Determine if user is signed in
    _isSignedIn = _user?.firstName != null && _user?.lastName != '';

    _isLoading = false;
    notifyListeners();
  }

  Future<void> initializeSitterData() async {
    log("Initializing sitter data");

    // Initialize Hive box for the user
    try {
      _sitterBox = await Hive.openBox<Sitter>('sitter');
      log("SitterBox opened: ${_sitterBox.isOpen}");
    } catch (e) {
      log("Error opening sitter box: $e");
      return; // Return early if there's an error
    }

    // Fetch user data
    _sitter = _sitterBox.get('sitter') ?? Sitter();
    log("Sitter data initialized: ${_sitter?.first_name}");

    // Determine if user is signed in
    _isSitterSignedIn = _sitter?.first_name != null && _sitter?.last_name != '';

    _isLoading = false;
    notifyListeners();
  }

  Future<void> storeLoggedInUser({required User user}) async {
    // If the user exists, delete the existing user
    if (_userBox.isNotEmpty) {
      await _userBox.clear();
    }
    _user = user;
    await _userBox.put('user', user);
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> storeSitterLoggedInUser({required Sitter sitter}) async {
    log("Into the appstore storeSitterLoggedInUser");
    // If the user exists, delete the existing user
    if (_sitterBox.isNotEmpty) {
      await _sitterBox.clear();
    }
    _sitter = sitter;
    await _sitterBox.put('sitter', sitter);
    _isSitterSignedIn = true;
    log("Sitterbox status: ${_sitterBox.isEmpty}");
    notifyListeners();
  }

  Future<bool?> signOut() async {
    try {
      if (_isSignedIn && _userBox.isNotEmpty) {
        await _userBox.clear();
        _isSignedIn = false;
        notifyListeners();
        return true;
      } else if (_isSitterSignedIn && _sitterBox.isNotEmpty) {
        await _sitterBox.clear();
        _isSitterSignedIn = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      log("Error signing out: $e");
      return false;
    }
    return null;
  }

  void checkAuth(BuildContext context) {
    if (_isSignedIn == true && _isSitterSignedIn == false) {
      context.go('/root');
    } else if (_isSignedIn == false && _isSitterSignedIn == true) {
      context.go('/dashboard');
    } else if (_isSignedIn == false && _isSitterSignedIn == false) {
      context.go('/login');
    }
  }

  void setUserAuth({required bool value}) {
    _isSignedIn = value;
    notifyListeners();
  }

  void setSitterAuth({required bool value}) {
    _isSitterSignedIn = value;
    notifyListeners();
    log("setSitterAuth: ${_isSitterSignedIn}");
  }

  void checkHive() {
    log("UserBox is open: ${_userBox.isOpen}");
  }
}
