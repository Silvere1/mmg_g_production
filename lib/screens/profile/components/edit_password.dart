import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/user_controller.dart';

class EditPassWord extends StatelessWidget {
  const EditPassWord({Key? key, required this.userController})
      : super(key: key);
  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "Ancien mot de passe",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Obx(() {
              return TextField(
                onChanged: (val) {
                  if (val.trim().length >= 4) {
                    userController.editingPassW(val);
                  } else {
                    userController.editingPassW("");
                  }
                },
                textInputAction: TextInputAction.next,
                obscureText: userController.eye.value,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      userController.eye.toggle();
                    },
                    child: Icon(userController.eye.value
                        ? Icons.remove_red_eye_outlined
                        : Icons.visibility_off_outlined),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "Nouveau mot de passe",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Obx(() {
              return TextField(
                onChanged: (val) {
                  if (val.trim().length >= 4) {
                    userController.editingNewPassW(val);
                  } else {
                    userController.editingNewPassW("");
                  }
                },
                textInputAction: TextInputAction.done,
                obscureText: userController.eye.value,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      userController.eye.toggle();
                    },
                    child: Icon(userController.eye.value
                        ? Icons.remove_red_eye_outlined
                        : Icons.visibility_off_outlined),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
              );
            }),
            const SizedBox(
              height: 15,
            ),
            Obx(() {
              return ElevatedButton(
                  onPressed: userController.passW.value != "" &&
                          userController.newPassW.value != ""
                      ? () async {
                          userController.setCirc(true);
                          await userController.changePassWord().then((value) {
                            userController.setCirc(false);
                            if (value == 2) {
                              Get.back();
                              Get.defaultDialog(
                                  title: "Félicitation",
                                  content: const Text(
                                    "Votre mot de passe est changé avec succès !",
                                    textAlign: TextAlign.center,
                                  ),
                                  confirm: SizedBox(
                                      width: 100,
                                      child: ElevatedButton(
                                          onPressed: () => Get.back(),
                                          child: const Text("Ok"))));
                            } else {
                              Get.defaultDialog(
                                  title: "Attention",
                                  content: const Text(
                                    "Votre ancien mot de passe est incorrect !",
                                    textAlign: TextAlign.center,
                                  ),
                                  confirm: SizedBox(
                                      width: 100,
                                      child: ElevatedButton(
                                          onPressed: () => Get.back(),
                                          child: const Text("Ok"))));
                            }
                          });
                        }
                      : null,
                  child: userController.circ.value
                      ? const CircularProgressIndicator()
                      : const Text("Enregistrer"));
            }),
          ],
        ),
      ),
    );
  }
}
