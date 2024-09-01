import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final log = Logger('lib/services/auth_services.dart');

  Dio? _dio;

  Dio? get dio => _dio;

  initialize() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env["API_URL"]!,
        receiveTimeout: const Duration(seconds: 10),
        connectTimeout: const Duration(seconds: 10),
      ),
    );
  }

  // Login services
  login() async {
    try {
      _isLoading = true;
      notifyListeners();
      log.info("Trying login...");
      _isLoading = false;
      notifyListeners();
      throw UnimplementedError();
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

  // Register services
  register() async {
    try {
      _isLoading = true;
      notifyListeners();
      log.info("Trying signin...");
      _isLoading = false;
      notifyListeners();
      throw UnimplementedError();
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
