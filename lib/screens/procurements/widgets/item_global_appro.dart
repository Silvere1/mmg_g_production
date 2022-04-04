import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/models/appro.dart';
import '/app/utils/formats/date.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';
import '/screens/procurements/ui/detail_global_appro.dart';

class ItemGlobalAppro extends StatelessWidget {
  const ItemGlobalAppro({Key? key, required this.anim, required this.appro})
      : super(key: key);
  final Animation<double> anim;
  final Appro appro;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: anim,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Get.to(() => DetailGlobalAprro(appro: appro));
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backGroundSvg,
                        ),
                        child: SvgPicture.asset(
                          MmgAssets.procurement,
                          color: Theme.of(context).primaryColor,
                          height: 22,
                        )),
                    Dimensions.x8,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Le ${jour.format(DateTime.fromMillisecondsSinceEpoch(int.parse(appro.id!)))}",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Dimensions.y4,
                          Wrap(
                            spacing: 14,
                            children: [
                              Text("Téléphone(s) : ${appro.nbrPhone}"),
                              Text("Accessoire(s) : ${appro.nbrAcc}"),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
