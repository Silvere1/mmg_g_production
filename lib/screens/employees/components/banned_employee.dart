import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/user_controller.dart';
import '/app/models/user.dart';
import '/res/assets_files.dart';
import '/screens/components/entry.dart';

class BannedEmployee extends StatefulWidget {
  const BannedEmployee({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<BannedEmployee> createState() => _BannedEmployeeState();
}

class _BannedEmployeeState extends State<BannedEmployee> {
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(MmgAssets.banned),
              ),
              radius: 28,
              backgroundColor: Colors.white,
            ),
            Text(
              "Bannir",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(widget.user.fullName + " ?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3),
            Dimensions.y4,
            Text(
              "Attention, cette action est irreversible !",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.red),
            ),
            Obx(
              () => Entry(
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
                  child: Obx(
                    () => ElevatedButton(
                        onPressed: userController.passW.value.length >= 4
                            ? () {
                                Get.back();
                                userController.bannedEmployee(widget.user);
                              }
                            : null,
                        child: const Text("Oui")),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
