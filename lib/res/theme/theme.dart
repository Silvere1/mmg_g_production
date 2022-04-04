import 'package:flutter/material.dart';

import 'colors/constants.dart';
import 'colors/gen_material_color.dart';
import 'typography/font_weight.dart';
import 'typography/text_theme.dart';

ThemeData buildLightThemeData() {
  return ThemeData(
    visualDensity: VisualDensity.standard,
    primarySwatch: genMaterialColor(primColor),
    backgroundColor: backGround,
    scaffoldBackgroundColor: backGround,
    textTheme: MyTextTheme.lightTextTheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle:
          MyTextTheme.lightTextTheme.headline4!.copyWith(color: Colors.white),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
    ),
    drawerTheme: DrawerThemeData(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
      )),
      backgroundColor: backGround,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          onSurface: primColor,
          elevation: 0.2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      fillColor: Colors.white,
      labelStyle: const TextStyle(fontSize: 16),
      floatingLabelStyle: const TextStyle(fontSize: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      filled: true,
      hintStyle: MyTextTheme.lightTextTheme.bodyText2!.copyWith(
        fontSize: 12,
        fontWeight: MyFontWeight.regular,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            //onSurface: primColor,
            //elevation: 0.2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: MyTextTheme.lightTextTheme.button!
                .copyWith(fontSize: 14, fontWeight: MyFontWeight.regular),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(0))),
    listTileTheme: const ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: backGround,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5),
    checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    )),
    tabBarTheme: const TabBarTheme(
      labelStyle: TextStyle(fontSize: 16),
    ),
  );
}
