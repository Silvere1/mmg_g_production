import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/app/models/acc.dart';
import '../../../app/config/dimensions.dart';
import '../../../res/assets_files.dart';
import '../../../res/theme/colors/constants.dart';

class ItemAccStockSerach extends StatelessWidget {
  const ItemAccStockSerach({Key? key, required this.acc}) : super(key: key);
  final Acc acc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.black12,
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
                      MmgAssets.electronic,
                      color: Theme.of(context).primaryColor,
                      height: 18,
                    )),
                Dimensions.x8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        acc.name,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Dimensions.y2,
                      Text("Qte : ${acc.qte}"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
