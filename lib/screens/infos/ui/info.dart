import 'package:flutter/material.dart';

import '/app/config/dimensions.dart';
import '/screens/infos/res/infos_text.dart';

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 100,
              child: Image.asset(
                "assets/icons/icon_rouge.png",
              ),
            ),
          ),
          Dimensions.y10,
          RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                  text: "Mobile Market Gestion ",
                  spellOut: true,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Theme.of(context).primaryColor),
                  children: [
                    TextSpan(
                      text: MmgInfos.txt,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextSpan(
                      text: "\n\nConditions d'utilisation\n\n",
                      spellOut: true,
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: MmgInfos.txtCon,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ])),
          Dimensions.y10,
          const Text("Edit by #Slv")
        ],
      ),
    );
  }
}
