import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/agence_controller.dart';
import '/app/utils/formats/mask_formater.dart';
import '/screens/components/entry.dart';

Dialog buildAddMagasin(BuildContext _, AgenceController agenceController) =>
    Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Entry(
              text: Text(
                "Nom du magasin",
                style: Theme.of(_).textTheme.headline3,
              ),
              editText: TextField(
                onChanged: (value) async {
                  await agenceController.editName(value.trim());
                },
                inputFormatters: [nameAndNumMaskFormatter],
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              return ElevatedButton(
                  onPressed: agenceController.nameAgence.value != "" &&
                          !agenceController.cir.value
                      ? () async {
                          await agenceController.creatAgence();
                        }
                      : null,
                  child: agenceController.cir.value
                      ? const CircularProgressIndicator()
                      : const Text("Enregistrer"));
            })
          ],
        ),
      ),
    );
