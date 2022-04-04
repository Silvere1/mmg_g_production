import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/res/assets_files.dart';

Future<dynamic> buildNoAccess(BuildContext _) {
  return showDialog(
    context: _,
    builder: (_) => Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 215,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(MmgAssets.accessDenied),
            Text(
              "Accès refusé!\nVos informations sont incorrectes",
              textAlign: TextAlign.center,
              style: Theme.of(_).textTheme.headline4,
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Ok"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
