import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/app/config/dimensions.dart';
import '/app/models/phone.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';

class ItemPhoneStock extends StatelessWidget {
  const ItemPhoneStock({Key? key, required this.anim, required this.phone})
      : super(key: key);
  final Animation<double> anim;
  final Phone phone;

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
                ///
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: backGroundSvg,
                        ),
                        child: SvgPicture.asset(
                          MmgAssets.phone,
                          color: Theme.of(context).primaryColor,
                          height: 18,
                        )),
                    Dimensions.x8,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            phone.name,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Dimensions.y2,
                          Text("Qte : ${phone.qte}"),
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
