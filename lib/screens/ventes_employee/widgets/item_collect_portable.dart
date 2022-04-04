import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/vente_controller.dart';
import '/app/models/phone_color.dart';
import '/app/models/portable.dart';
import '/app/utils/formats/money.dart';
import '/res/assets_files.dart';

class ItemCollectPortable extends StatelessWidget {
  const ItemCollectPortable({
    Key? key,
    required this.venteController,
    required this.list1Key,
    required this.portable,
    required this.i,
    required this.anim,
  }) : super(key: key);

  final GlobalKey<AnimatedListState> list1Key;
  final VenteController venteController;
  final Portable portable;
  final int i;
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: anim,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  portable.name!,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Dimensions.y2,
                Wrap(
                  spacing: 14,
                  children: [
                    Text("imei : ${portable.imei!}"),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(portable.color!),
                        Dimensions.x6,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            color: Colors.black,
                            padding: const EdgeInsets.all(.5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                height: 16,
                                width: 16,
                                color: getPhoneColor(portable.color!),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("Prix : ${setMoney(portable.prix!)}"),
                    InkWell(
                      onTap: () async {
                        list1Key.currentState!.removeItem(
                            i,
                            (_, animation) => ItemCollectPortable(
                                venteController: venteController,
                                list1Key: list1Key,
                                portable: portable,
                                i: i,
                                anim: animation));
                        await 1.delay();
                        await venteController.deletePortableOfList(i);
                      },
                      child: SvgPicture.asset(
                        MmgAssets.delete,
                        height: 24,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
