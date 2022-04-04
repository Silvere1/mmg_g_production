import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/user_controller.dart';
import '/screens/components/entry.dart';
import '../../../app/config/dimensions.dart';

class CancelVente extends StatefulWidget {
  const CancelVente({Key? key}) : super(key: key);

  @override
  State<CancelVente> createState() => _CancelVenteState();
}

class _CancelVenteState extends State<CancelVente> {
  UserController userController = UserController.instance;
  final _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Attention\nAnnulation de vente",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                "Cette opération est irréversible, veuillez bien vérifier les détails de la vente avant de continuer !",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Colors.red,
                      fontSize: 12,
                    ),
              ),
              Entry(
                text: Text(
                  "Raison d'annulation",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TextField(
                  controller: _editingController,
                  minLines: 1,
                  maxLines: 2,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Entry(
                text: Text(
                  "Mot de passe",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TextField(
                  onChanged: (value) {
                    userController.editingPassW(value.trim());
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
                ),
              ),
              Dimensions.y14,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () => Get.back(), child: const Text("Non")),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: userController.passW.value.length >= 4 &&
                                _editingController.text.trim().isNotEmpty
                            ? () {
                                Get.back(
                                    result: _editingController.text.trim());
                              }
                            : null,
                        child: const Text("Oui")),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
