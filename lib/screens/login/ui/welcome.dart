import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/controllers/user_controller.dart';
import '/app/models/user.dart';
import '/res/assets_files.dart';
import '/screens/home/ui/home.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.user.admin! ? "Espace Administrateur" : "Espace Employer"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AspectRatio(
                aspectRatio: 1 * 1.1,
                child: SvgPicture.asset(widget.user.admin!
                    ? MmgAssets.manager
                    : MmgAssets.employee),
              ),
              Text(
                "Connexion réussie\nBienvenue dans votre espace !",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => Home(user: widget.user));
                  },
                  child: const Text("Continuer"))
            ],
          ),
        ),
      ),
    );
  }
}
