import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/controllers/user_controller.dart';
import '/res/assets_files.dart';
import '/screens/login/ui/login.dart';
import '/screens/profile/components/edit_password.dart';
import '/screens/profile/components/logout.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: CircleAvatar(
                    child: SvgPicture.asset(userController.user!.admin!
                        ? MmgAssets.userSecured
                        : MmgAssets.user),
                    radius: 40,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Infos Personnelles",
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Nom et Prénom(s)"),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  userController.user!.fullName,
                                  style: Theme.of(context).textTheme.headline3,
                                )))
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Num de téléphone"),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "+229 ${userController.user!.tel}",
                                  style: Theme.of(context).textTheme.headline3,
                                )))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Sécurité",
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => EditPassWord(
                                    userController: userController,
                                  ));
                        },
                        child: const Text("Modifier votre mot de passe")),
                    const Divider(),
                    TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: const Size(double.maxFinite, 38),
                            primary: Colors.black,
                            alignment: Alignment.centerLeft),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => const Logout()).then((value) {
                            if (value == true) {
                              userController.logOut();
                              Get.offAll(() => const Login());
                            }
                          });
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              MmgAssets.logout,
                              height: 20,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text("Déconnexion"),
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
