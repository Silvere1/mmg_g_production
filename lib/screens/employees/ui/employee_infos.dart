import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/network_controller.dart';
import '/app/controllers/user_controller.dart';
import '/app/models/agence.dart';
import '/app/models/user.dart';
import '/screens/components/entry.dart';
import '/screens/components/no_internet.dart';
import '/screens/employees/components/change_employee_password.dart';
import '/screens/employees/components/selecte_magasin.dart';
import '../../../app/services/call/call.dart';
import '../../../res/assets_files.dart';

class EmployeeInfos extends StatefulWidget {
  const EmployeeInfos({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _EmployeeInfosState createState() => _EmployeeInfosState();
}

class _EmployeeInfosState extends State<EmployeeInfos> {
  UserController userController = UserController.instance;
  NetworkController networkController = NetworkController.instance;
  var newPassword = "* * * * * *".obs;
  var newAgenceName = "Aucune".obs;
  var agenceId = "".obs;

  @override
  void initState() {
    super.initState();
    userController.cleanVar();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Détail employé"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Entry(
                  text: Text(
                    "Nom & prénom(s)",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  editText: Text(widget.user.fullName)),
              Entry(
                  text: Text(
                    "Téléphone",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  editText: Text("+229 " + widget.user.tel.toString())),
              Dimensions.y6,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Material(
                      color: Colors.black12,
                      child: InkWell(
                        onTap: () {
                          Call().phone(widget.user.tel.toString());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            MmgAssets.icPhone,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Material(
                      color: Colors.black12,
                      child: InkWell(
                        onTap: () {
                          Call().openWhatsapp(widget.user.tel.toString());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            MmgAssets.icWhatsapp,
                            height: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Entry(
                text: Text(
                  "Mot de passe",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(newPassword.value)),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => buildChangeEmployeePassword(
                                _, userController)).then((value) {
                          if (value == true) {
                            newPassword(userController.passW.value);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(32, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: SvgPicture.asset(
                        "assets/svgs/edit.svg",
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Entry(
                text: Text(
                  "Agence affectée",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return Text(widget.user.agenceName == null
                          ? newAgenceName.value
                          : agenceId.value != ""
                              ? newAgenceName.value
                              : widget.user.agenceName!);
                    }),
                    ElevatedButton(
                      onPressed: () {
                        Get.to<Agence>(() => const SelectMagasin())!
                            .then((value) {
                          if (value != null) {
                            agenceId.value = value.id;
                            newAgenceName(value.name);
                            if (kDebugMode) {
                              print(value.toJson());
                            }
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: SvgPicture.asset(
                        "assets/svgs/edit.svg",
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Obx(() => ElevatedButton(
                  onPressed: newAgenceName.value != "Aucune" &&
                              userController.circ.value == false ||
                          newPassword.value != "* * * * * *" &&
                              userController.circ.value == false
                      ? () async {
                          if (networkController.isOk) {
                            if (newPassword.value != "* * * * * *") {
                              await userController
                                  .changeEmployeePassword(widget.user);
                            }
                            if (agenceId.value != "") {
                              await userController.setAgenceForUser(
                                  agenceId.value, widget.user);
                            }
                            Get.back();
                          } else {
                            buildNoInternet(context);
                          }
                        }
                      : null,
                  child: userController.circ.value == true
                      ? const CircularProgressIndicator()
                      : const Text("Enregistrer"))),
            ],
          ),
        ),
      ),
    );
  }
}
