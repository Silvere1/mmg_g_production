import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  static NetworkController get instance => Get.find();
  late StreamSubscription<ConnectivityResult> subscription;
  final Connectivity connectivity = Connectivity();
  bool isOk = false;

  @override
  void onReady() async {
    super.onReady();
    await connectivity.checkConnectivity();
    subscription = connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        isOk = false;
        if (kDebugMode) {
          print(event);
        }
      } else {
        isOk = true;
        if (kDebugMode) {
          print(event);
        }
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    subscription.cancel();
  }
}
