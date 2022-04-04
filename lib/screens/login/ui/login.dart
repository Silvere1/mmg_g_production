import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/controllers/network_controller.dart';
import '/app/controllers/user_controller.dart';
import '/app/services/app_services/init_services.dart';
import '/app/utils/formats/mask_formater.dart';
import '/res/assets_files.dart';
import '/res/theme/ui/ui_overlay_style.dart';
import '/screens/components/entry.dart';
import '/screens/components/no_internet.dart';
import '/screens/global/widgets/access_denied.dart';
import '/screens/login/ui/welcome.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserController userController = UserController.instance;
  NetworkController networkController = NetworkController.instance;

  @override
  void initState() {
    super.initState();
    userController.cleanVar();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Authentification"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.width * .5,
                    child: Padding(
                      padding: const EdgeInsets.all(34),
                      child: SvgPicture.asset(MmgAssets.connexion),
                    ),
                  ),
                  Entry(
                      text: Text(
                        "Numéro de téléphone",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      editText: TextField(
                        onChanged: (value) {
                          if (telMaskFormatter
                              .getUnmaskedText()
                              .isNumericOnly) {
                            userController.editingTel(
                                int.parse(telMaskFormatter.getUnmaskedText()));
                          }
                        },
                        inputFormatters: [telMaskFormatter],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        enableSuggestions: false,
                      )),
                  Entry(
                    text: Text(
                      "Mot de passe",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    editText: Obx(() => TextField(
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
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Obx(() => ElevatedButton(
                      onPressed: userController.tel.toString().length == 8 &&
                              userController.passW.value.length >= 4 &&
                              !userController.circ.value
                          ? () {
                              if (networkController.isOk) {
                                userController.setCirc(true);
                                userController.login().then((value) async {
                                  userController.setCirc(false);
                                  if (value != null) {
                                    await initServices();
                                    Get.offAll(() => Welcome(user: value));
                                  } else {
                                    buildNoAccess(context);
                                  }
                                });
                              } else {
                                buildNoInternet(context);
                              }
                            }
                          : null,
                      child: userController.circ.value
                          ? const CircularProgressIndicator()
                          : const Text("Connexion"))),
                ],
              ),
            ),
          ),
        ),
        value: MyOverlayStyle.forConnexion);
  }
}
