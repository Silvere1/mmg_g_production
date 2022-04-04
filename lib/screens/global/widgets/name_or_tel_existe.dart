import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> nameOrTelExiste() {
  return Get.defaultDialog(
    title: "Attention",
    radius: 10,
    content: const Text(
      "Ce nom ou numéro de téléphone existe déjà !",
      textAlign: TextAlign.center,
    ),
    confirm:
        ElevatedButton(onPressed: () => Get.back(), child: const Text("Ok")),
  );
}
