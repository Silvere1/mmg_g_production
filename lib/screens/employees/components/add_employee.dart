import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/user_controller.dart';
import '/app/utils/formats/mask_formater.dart';
import '/screens/components/entry.dart';
import '/screens/global/widgets/name_or_tel_existe.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  UserController userController = UserController.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter un employé"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Entry(
                text: Text(
                  "Nom et prénom(s)",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TextField(
                  onChanged: (value) {
                    userController.editingName(
                        nameMaskFormatter.getUnmaskedText().trim());
                  },
                  inputFormatters: [nameMaskFormatter],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
              ),
              Entry(
                text: Text(
                  "Téléphone",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TextField(
                  onChanged: (value) {
                    if (telMaskFormatter.getUnmaskedText().isNumericOnly) {
                      userController.editingTel(
                          int.parse(telMaskFormatter.getUnmaskedText()));
                    }
                  },
                  inputFormatters: [telMaskFormatter],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                ),
              ),
              Entry(
                text: Text(
                  "Mot de passe par défaut",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TextField(
                  onChanged: (value) {
                    userController.editingPassW(value.trim());
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Obx(() => ElevatedButton(
                  onPressed: userController.name.value != "" &&
                          userController.tel.toString().length == 8 &&
                          userController.passW.value.length >= 4
                      ? () async {
                          await userController.creatUser().then((value) {
                            if (value == true) {
                              Get.back();
                            } else {
                              nameOrTelExiste();
                            }
                          });
                        }
                      : null,
                  child: const Text("Ajouter")))
            ],
          ),
        ),
      ),
    );
  }
}
