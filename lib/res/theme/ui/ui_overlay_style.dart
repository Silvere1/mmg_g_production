import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/res/theme/colors/constants.dart';

abstract class MyOverlayStyle {
  static SystemUiOverlayStyle sameTopBotForTheme = SystemUiOverlayStyle.light
      .copyWith(
          systemNavigationBarColor: primColor,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarColor: primColor,
          statusBarIconBrightness: Brightness.light);

  static SystemUiOverlayStyle sameTopBotForBackground =
      SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: backGround,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarColor: backGround,
          statusBarIconBrightness: Brightness.dark);

  static SystemUiOverlayStyle get forHome =>
      SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarColor: backGround,
          statusBarIconBrightness: Brightness.dark);

  static SystemUiOverlayStyle forConnexion = SystemUiOverlayStyle.light
      .copyWith(
          systemNavigationBarColor: backGround,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarColor: primColor,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light);
}
