import 'dart:developer';
import 'package:book/services/auth_services.dart';
import 'package:book/services/helper_services.dart';
import 'package:book/services/router_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env.local");
    log("Loaded .env.local file");
  } catch (e) {
    log("Error loading .env.local file: $e");
  }
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
  });

  AuthServices _authServices = AuthServices();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  log("App Name: $appName, Package Name: $packageName, Version: $version, Build Number: $buildNumber");
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(MultiProvider(
    providers: [
      Provider<RouterServices>(create: (_) => RouterServices()),
      ChangeNotifierProvider(create: (_) => HelperServices()),
      ChangeNotifierProvider<AuthServices>(create: (_) => AuthServices()),
    ],
    child: MyApp(
      authServices: _authServices,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final AuthServices authServices;
  const MyApp({super.key, required this.authServices});
  @override
  Widget build(BuildContext context) {
    final router = RouterServices().getRouter(context);
    return ToastificationWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
