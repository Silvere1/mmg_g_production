import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/services/preferences/preferences_manager.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';
import '/res/theme/ui/ui_overlay_style.dart';
import '/screens/login/ui/login.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  /* @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(MyOverlayStyle.sameTopBotForTheme);
  }
*/
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: MyOverlayStyle.sameTopBotForTheme,
      sized: false,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: primColor,
            padding: const EdgeInsets.all(34),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(36),
                  child: SizedBox(
                    height: 100,
                    child: Image.asset(
                      MmgAssets.iconNeutre,
                    ),
                  ),
                ),
                Text(
                  "Bienvenue sur\nMobile Market Gestion",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Gérer et surveiller vos ventes",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.white),
                  ),
                ),
                const Spacer(),
                AspectRatio(
                  aspectRatio: 1.5,
                  child: SvgPicture.asset(MmgAssets.intro),
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      PrefManager.instance.setStr("intro", "intro");
                      Get.offAll(() => const Login());
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        primary: Colors.white,
                        onPrimary: primColor,
                        padding: const EdgeInsets.symmetric(horizontal: 30)),
                    child: const Text("Commencer")),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
