import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> nameExiste() {
  return Get.defaultDialog(
    title: "Attention",
    radius: 10,
    content: const Text(
      "Ce nom existe déjà !",
      textAlign: TextAlign.center,
    ),
    confirm:
        ElevatedButton(onPressed: () => Get.back(), child: const Text("Ok")),
  );
}
