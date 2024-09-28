import 'package:book/services/appstore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import '../models/user.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isAuth = false;
  bool get isAuth => _isAuth;

  Appstore appstore = Appstore();

  AuthServices() {
    appstore.initializeUserData();
  }

  String? selectedPin;

  List<String> _pinCodeList = [];
  List<String> get pinCodeList => _pinCodeList;

  final log = Logger('lib/services/auth_services.dart');

  Dio? _dio;

  Dio? get dio => _dio;

  // Initialize Dio instance
  Future<void> initialize() async {
    final baseUrl = dotenv.env["BASE_API_URL"];
    if (baseUrl != null && baseUrl.isNotEmpty) {
      _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          receiveTimeout: const Duration(seconds: 10),
          connectTimeout: const Duration(seconds: 10),
        ),
      );
      log.info("Dio initialized with baseUrl: $baseUrl");
    } else {
      log.warning("BASE_API_URL is not set in the environment file");
    }
  }

  void checkAuth(BuildContext context) {
    if (_isAuth) {
      context.go('/root');
    } else {
      context.go('/login');
    }
  }

  Map<String, dynamic> _body = {};
  Map<String, dynamic> get body => _body;

  // get pincode
  void getPinCode({required String value}) {
    selectedPin = value;
    notifyListeners();
  }

  void getResgisterBody(body) {
    _body = body;
  }

  // Login services
  Future<bool?> logout() async {
    try {
      _isLoading = true;
      notifyListeners();
      log.info("Trying login...");
      await appstore.signOut();
      _isAuth = false;
      _isLoading = false;
      notifyListeners();
      return true;
      // throw UnimplementedError();
    } on PlatformException catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    } on DioException catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register services
  register(
      {required String firstname,
      required String lastname,
      required String zipcode,
      required String email,
      required String password}) async {
    if (_isLoading) {
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();

      final body = {
        "first_name": firstname,
        'last_name': lastname,
        'zip_code': zipcode,
        'email': email,
        'password': password
      };

      if (_dio == null) {
        log.info("Dio is null, initializing...");
        await initialize();
      }

      final response = await dio?.post('/register', data: body);

      log.info("Register response: $response");

      if (response?.statusCode == 200 && response?.data['status'] != "error") {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return response?.data['message'] ?? 'Unknown error occurred';
      }
    } on PlatformException catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    } on DioException catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
      return "Network error";
    } catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  login({required String email, required String password}) async {
    if (_isLoading) {
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();

      log.info("API URL: ${dotenv.env["BASE_API_URL"]}");

      final body = {'email': email, 'password': password};

      log.info("body: $body");

      if (_dio == null) {
        log.info("Dio is null, initializing...");
        await initialize();
      }

      final response = await _dio!.post('/login', data: body);

      log.info('My Login response is: $response');
      _isLoading = false;
      notifyListeners();

      // Handle response based on status code
      if (response.statusCode == 200) {
        // Success
        log.info('Login successful');
        if (response.data['code'] != 0) {
          final userResp = response.data['user_detail'];
          final user = User.fromJson(userResp);
          log.info('User data: $user');
          appstore.storeLoggedInUser(user: user);
          _isAuth = true;
          notifyListeners();
          return true;
        } else {
          _isAuth = false;
          notifyListeners();
          return response.data['message'] ?? 'Unknown error occurred';
        }
      } else {
        // Error response
        log.warning('Login failed with status: ${response.statusCode}');
        return 'Login failed';
      }
    } on PlatformException catch (e) {
      log.warning("Platform Exception: $e");
      _isLoading = false;
      notifyListeners();
      return 'Platform error: ${e.message}';
    } on DioException catch (e) {
      log.warning("Dio Exception: $e");
      _isLoading = false;
      notifyListeners();
      return 'Network error: ${e.message}';
    } catch (e) {
      log.warning("Error: $e");
      _isLoading = false;
      notifyListeners();
      return 'An unknown error occurred';
    }
  }

  // Get Pin Code
  getPinCodeList() async {
    debugPrint('Executing pin code function');
    try {
      _isLoading = true;
      notifyListeners();
      log.info("Trying to get pincodes...");
      final response = await _dio!.get('/pincode-list');

      // Make sure to check if the response is successful
      if (response?.statusCode == 200) {
        final List<dynamic> data = response?.data["pincode_list"];
        log.info("Data from pin API: $data");

        // Extract pincodes from the response
        _pinCodeList = data.map((item) => item["pincode"] as String).toList();
        log.info("OTP Pincodes are: $_pinCodeList");
      } else {
        log.warning("Failed to fetch pincodes: ${response?.statusCode}");
      }

      _isLoading = false;
      notifyListeners();
    } on PlatformException catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
    } on DioException catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  sitter_register() async {
    try {
      _isLoading = true;
      notifyListeners();
      log.info("Trying to get pincodes...");
      final response = await _dio!.get('/pincode-list');

      // Make sure to check if the response is successful
      if (response?.statusCode == 200) {
        final List<dynamic> data = response?.data["pincode_list"];
        log.info("Data from pin API: $data");

        // Extract pincodes from the response
        _pinCodeList = data.map((item) => item["pincode"] as String).toList();
        log.info("OTP Pincodes are: $_pinCodeList");
      } else {
        log.warning("Failed to fetch pincodes: ${response?.statusCode}");
      }

      _isLoading = false;
      notifyListeners();
    } on PlatformException catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
    } on DioException catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
}
