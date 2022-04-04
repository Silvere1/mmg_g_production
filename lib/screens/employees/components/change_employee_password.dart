import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/user_controller.dart';
import '/screens/components/entry.dart';

Dialog buildChangeEmployeePassword(
        BuildContext _, UserController userController) =>
    Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Entry(
              text: Text(
                "Nouveau mots de passe",
                style: Theme.of(_).textTheme.headline3,
              ),
              editText: TextField(
                onChanged: (value) async {
                  await userController.editingPassW(value.trim());
                },
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return ElevatedButton(
                  onPressed: userController.passW.value != ""
                      ? () {
                          Get.back(result: true);
                        }
                      : null,
                  child: const Text("Enregistrer"));
            })
          ],
        ),
      ),
    );
