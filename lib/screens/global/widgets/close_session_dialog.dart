import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> closeSessionDialog() {
  return Get.defaultDialog(
    title: "Attention",
    radius: 10,
    content: const Text("Votre session est terminée !"),
    confirm:
        ElevatedButton(onPressed: () => Get.back(), child: const Text("Ok")),
  );
}
