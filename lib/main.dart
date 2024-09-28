import 'dart:developer';
import 'dart:io';
import 'package:book/models/sitter.dart';
import 'package:book/models/user.dart';
import 'package:book/services/appstore.dart';
import 'package:book/services/auth_services.dart';
import 'package:book/services/helper_services.dart';
import 'package:book/services/router_services.dart';
import 'package:book/services/sitter_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
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
  if (!kIsWeb) {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
  }
  Hive.registerAdapter(UserAdapter()); // Register the adapters
  Hive.registerAdapter(SitterAdapter());
  // Hive.registerAdapter(ServicesAdapter());

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    log('${record.level.name}: ${record.time}: ${record.message}');
  });

  AuthServices authServices = AuthServices();

  await authServices.initialize();

  Appstore appstore = Appstore();

  await appstore.initializeUserData();
  await appstore.initializeSitterData();

  log("Currently signed in username: ${appstore.user?.firstName}");
  log("Currently signed in sitter: ${appstore.sitter?.first_name}");

  SitterServices sitterServices = SitterServices();

  await sitterServices.getSitterListByPinCode(pinCode: appstore.user?.zipCode ?? '');

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
      ChangeNotifierProvider<Appstore>.value(value: appstore),
      ChangeNotifierProvider<AuthServices>.value(value: authServices),
      ChangeNotifierProvider<SitterServices>.value(value: sitterServices),
    ],
    child: MyApp(
      authServices: authServices,
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
