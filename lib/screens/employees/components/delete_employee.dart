import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/user_controller.dart';
import '/app/models/user.dart';
import '/screens/components/entry.dart';

class DeleteEmployee extends StatefulWidget {
  const DeleteEmployee({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<DeleteEmployee> createState() => _DeleteEmployeeState();
}

class _DeleteEmployeeState extends State<DeleteEmployee> {
  UserController userController = UserController.instance;

  @override
  void initState() {
    super.initState();
    userController.cleanVar();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Supprimer",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                widget.user.fullName + " ?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
              Entry(
                text: Text(
                  "Entrez votre mot de passe",
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
                        onPressed: userController.passW.value.length >= 4
                            ? () {
                                Get.back();
                                userController.deleteEmployee(widget.user);
                              }
                            : null,
                        child: const Text("Oui")),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
