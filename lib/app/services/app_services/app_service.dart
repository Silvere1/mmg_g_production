import 'dart:convert';

import 'package:get/get.dart';

import '/app/models/user.dart';
import '/app/services/preferences/preferences_manager.dart';

class AppServices extends GetxService {
  static AppServices get instance => Get.find();
  var intro = false.obs;
  var hasUser = false.obs;
  User? user;
  Future<AppServices> init() async {
    /// check Intro
    intro(await PrefManager.instance.exist("intro"));

    /// check login agent
    hasUser(await PrefManager.instance.exist("user"));

    if (hasUser.value) {
      var _user = await PrefManager.instance.getStr("user");
      user = User.fromJson(jsonDecode(_user));
    }

    return this;
  }
}
