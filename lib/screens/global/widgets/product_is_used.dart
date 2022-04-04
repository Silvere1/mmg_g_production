import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> productIsUsed() async {
  return Get.snackbar(
    "Attention",
    "Ce produit est déjà utilisé, vous ne pouvez plus le supprimer.",
    colorText: Colors.white,
    duration: const Duration(seconds: 4),
  );
}
