import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> passwordIncorrectDialog() {
  return Get.defaultDialog(
    title: "Attention",
    radius: 10,
    content: const Text(
      "Votre mot de passe est incorrect !",
      textAlign: TextAlign.center,
    ),
    confirm:
        ElevatedButton(onPressed: () => Get.back(), child: const Text("Ok")),
  );
}
