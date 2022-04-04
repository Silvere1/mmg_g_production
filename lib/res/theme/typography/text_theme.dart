import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'font_weight.dart';

class MyTextTheme {
  static TextTheme get lightTextTheme => GoogleFonts.openSansTextTheme(
        const TextTheme(
          headline3: TextStyle(
              fontSize: 14,
              fontWeight: MyFontWeight.semiBold,
              color: Colors.black),
          headline2: TextStyle(
              fontSize: 16,
              fontWeight: MyFontWeight.semiBold,
              color: Colors.black),
          headline4: TextStyle(
              fontSize: 18,
              fontWeight: MyFontWeight.semiBold,
              color: Colors.black),
          headline5: TextStyle(
              fontSize: 24,
              fontWeight: MyFontWeight.semiBold,
              color: Colors.black),
          headline6: TextStyle(
              fontSize: 20,
              fontWeight: MyFontWeight.semiBold,
              color: Colors.black),
          button: TextStyle(
              fontSize: 18,
              fontWeight: MyFontWeight.semiBold,
              color: Colors.black),
          bodyText1: TextStyle(
              fontSize: 14,
              fontWeight: MyFontWeight.medium,
              color: Colors.black),
          subtitle1: TextStyle(
              fontSize: 14,
              fontWeight: MyFontWeight.semiBold,
              color: Colors.black),
          caption: TextStyle(
              fontSize: 10,
              fontWeight: MyFontWeight.regular,
              color: Colors.black),
        ),
      );
}
