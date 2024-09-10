import 'package:flutter/material.dart';

class AssetManager {
  const AssetManager._();

  // Images

  static const baseImagePath = 'assets';

  static const splashImage = '$baseImagePath/splashScreen.png';
  static const dummyPersonDP = '$baseImagePath/person.jpeg';
  static const loginBG = '$baseImagePath/login.jpg';
  static const sitterRegisterBG = '$baseImagePath/sitter_register_bg.png';

  // Normal Height & Width

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Colors

  static const baseTextColor11 = Color.fromARGB(255, 6, 29, 68);
}
