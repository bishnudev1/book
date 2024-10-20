import 'dart:io';

import 'package:book/models/sitter.dart';
import 'package:book/services/appstore.dart';
import 'package:book/widgets/show_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:toastification/toastification.dart';

import '../models/user.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isAuth = false;
  bool get isAuth => _isAuth;

  Appstore appstore = Appstore();

  AuthServices() {
    appstore.initializeUserData();
    appstore.initializeSitterData();
  }

  String? selectedPin;

  List<String> _pinCodeList = [];
  List<String> get pinCodeList => _pinCodeList;

  List _bookedSitterList = [];
  List get bookedSitterList => _bookedSitterList;

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
          log.info("response.data: ${response.data}");
          final loginResp = response.data['user_detail'];
          log.info("user_type: ${loginResp["user_type"]}");
          if (loginResp['user_type'] == "sitter") {
            log.info("Login as a sitter");
            final user_id = loginResp["user_id"] ?? "";
            final user_type = loginResp["user_type"] ?? "";
            final first_name = loginResp["first_name"] ?? "";
            final last_name = loginResp["last_name"] ?? "";
            final zip_code = loginResp["zip_code"] ?? "";
            final email = loginResp["email"] ?? "";
            final profile_pic = loginResp["profile_pic"] ?? "";

            log.info("sitter_id while login in: ${user_id}");
            final newUser = Sitter(
                id: user_id,
                user_type: user_type,
                first_name: first_name,
                last_name: last_name,
                zip_code: zip_code,
                email: email,
                rating: '0',
                description: 'This is my description',
                per_hour_rate: 99,
                services: [],
                profile_pic: profile_pic);
            // final sitter = Sitter.fromJson(loginResp);
            await appstore.storeSitterLoggedInUser(sitter: newUser);
            // appstore.setSitterAuth(value: true);
            _isAuth = true;
            notifyListeners();
            return 'sitter';
          }
          log.info("login as a user");
          final user_id = loginResp["user_id"] ?? "";
          final user_type = loginResp["user_type"] ?? "";
          final first_name = loginResp["first_name"] ?? "";
          final last_name = loginResp["last_name"] ?? "";
          final zip_code = loginResp["zip_code"] ?? "";
          final email = loginResp["email"] ?? "";
          final profile_pic = loginResp["profile_pic"] ?? "";
          final newUser = User(
              userId: user_id,
              userType: user_type,
              firstName: first_name,
              lastName: last_name,
              zipCode: zip_code,
              profile_pic: profile_pic,
              email: email);
          // final user = User.fromJson(loginResp);
          // log.info('User data: $user');
          appstore.storeLoggedInUser(user: newUser);
          appstore.setUserAuth(value: true);
          _isAuth = true;
          notifyListeners();
          return 'user';
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

  getSitterBookingList() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _dio!.post('/sitter-booking-list', data: {"user_id": appstore.user?.userId});

      if (response.statusCode == 200) {
        log.info("sitterBookingList for user id ${appstore.user?.userId}: ${response.data}");
        _bookedSitterList = response.data;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
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

  updateProfile(
      {required String id,
      required String first_name,
      required String last_name,
      required String email,
      required BuildContext context,
      required bool isUser}) async {
    try {
      log.info("id: ${id}");
      log.info("first_name: ${first_name}");
      log.info("last_name: ${last_name}");
      log.info("email: ${email}");
      // return true;
      _isLoading = true;
      notifyListeners();
      // log.info("Trying to get pincodes...");
      final response = await _dio!.post('/update-profile',
          data: {"user_id": id, "first_name": first_name, "last_name": last_name, "email": email});

      // Make sure to check if the response is successful
      if (response.statusCode == 200 && response.data["status"] == "success") {
        // await appstore.signOut();
        if (isUser) {
          final newUser = User(
              userId: appstore.user?.userId,
              userType: appstore.user?.userType,
              firstName: first_name,
              lastName: last_name,
              zipCode: appstore.user?.zipCode,
              profile_pic: appstore.user?.profile_pic,
              email: email);
          await appstore.storeLoggedInUser(user: newUser);
        } else if (!isUser) {
          final newSitter = Sitter(
              id: appstore.sitter?.id,
              user_type: appstore.sitter?.user_type,
              first_name: first_name,
              last_name: last_name,
              zip_code: appstore.sitter?.zip_code,
              profile_pic: appstore.sitter?.profile_pic,
              email: email,
              rating: appstore.sitter?.rating,
              description: appstore.sitter?.description,
              per_hour_rate: appstore.sitter?.per_hour_rate,
              services: appstore.sitter?.services);
          await appstore.storeSitterLoggedInUser(sitter: newSitter);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        log.warning("Failed to update profile: ${response?.statusCode}");
        _isLoading = false;
        notifyListeners();
        return false;
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
      return false;
    } catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  updateProfilePicture({required File image, required String id, required bool isUser}) async {
    log.info("updateProfilePicture called in authServices");
    log.info("File image: ${image}");
    log.info("user_type: ${isUser ? appstore.user?.userType : appstore.sitter?.user_type}");
    log.info("id: ${id}");
    try {
      if (appstore.user?.email == "" && appstore.user?.email == null && isUser) {
        // await appstore.initializeSitterData();
        await appstore.initializeUserData();
      } else if (appstore.sitter?.email == "" && appstore.sitter?.email == null && !isUser) {
        await appstore.initializeSitterData();
      }
      log.info("appstore.user?.email: ${appstore.user?.email}");
      log.info("appstore.sitter?.email: ${appstore.sitter?.email}");
      _isLoading = true;
      notifyListeners();
      FormData formData = FormData.fromMap({
        'id': id,
        'user_type': isUser ? appstore.user?.userType : appstore.sitter?.user_type,
        'image': await MultipartFile.fromFile(image.path, filename: basename(image.path)),
      });

      final response = await _dio!.post('/profile-pic-update', data: formData);

      log.info("response.data: ${response.data}");
      if (response.statusCode == 200 && response.data["status"] == "success") {
        log.info("response.data['update_profile_pic']: ${response.data["update_profile_pic"]}");
        if (isUser) {
          log.info("execting user level updateProfilePicture");
          final newUser = User(
              userId: appstore.user?.userId,
              userType: appstore.user?.userType,
              firstName: appstore.user?.firstName,
              lastName: appstore.user?.lastName,
              zipCode: appstore.user?.zipCode,
              profile_pic: response.data["update_profile_pic"],
              email: appstore.user?.email);
          await appstore.storeLoggedInUser(user: newUser);
          _isLoading = false;
          notifyListeners();
          return true;
        } else if (!isUser) {
          log.info("execting sitter level updateProfilePicture");
          final newSitter = Sitter(
              id: appstore.sitter?.id,
              user_type: appstore.sitter?.user_type,
              first_name: appstore.sitter?.first_name,
              last_name: appstore.sitter?.last_name,
              zip_code: appstore.sitter?.zip_code,
              profile_pic: response.data["update_profile_pic"],
              email: appstore.sitter?.email,
              rating: appstore.sitter?.rating,
              description: appstore.sitter?.description,
              per_hour_rate: appstore.sitter?.per_hour_rate,
              services: appstore.sitter?.services);
          await appstore.storeSitterLoggedInUser(sitter: newSitter);
          _isLoading = false;
          notifyListeners();
          return true;
        }
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
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
      return false;
    } catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  changePassword(
      {required String id,
      required String old_password,
      required String new_password,
      required bool isUser}) async {
    try {
      final response = await _dio!.post('/change-password',
          data: {"user_id": id, "old_password": old_password, "new_password": new_password});
      log.info("response.data: ${response.data}");
      if (response.statusCode == 200 && response.data["status"] == "success") {
        return true;
      } else {
        return false;
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
      return false;
    } catch (e) {
      log.info(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
