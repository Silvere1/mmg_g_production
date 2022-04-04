import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/models/title.dart';

class MenuController extends GetxController {
  static MenuController get instance => Get.find();
  final _globalKey = GlobalKey<ScaffoldState>().obs;
  var barTitle = "Tableau de bord".obs;
  var indexPage = 0.obs;

  void controlMenu() {
    if (!_globalKey.value.currentState!.isDrawerOpen) {
      _globalKey.value.currentState!.openDrawer();
    }
  }

  onChangeMenu(MTitle e, int i, bool admin) {
    indexPage(i);
    barTitle(e.title);
    if (admin == true) {
      for (var x in adminTitles) {
        x.select = false;
      }
    } else {
      for (var x in employeeTitles) {
        x.select = false;
      }
    }
    e.select = true;
  }
}
