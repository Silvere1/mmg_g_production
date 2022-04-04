import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/app/models/portable.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';
import '/screens/global/widgets/product_is_used.dart';
import '/screens/produits/components/delete_portable.dart';

class ItemPortable extends StatelessWidget {
  const ItemPortable({Key? key, required this.portable, required this.anim})
      : super(key: key);

  final Portable portable;
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: anim,
      /*position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(
          parent: anim,
          curve: Curves.bounceOut,
          reverseCurve: Curves.bounceIn)),*/
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                ///
              },
              onLongPress: () {
                if (portable.used) {
                  productIsUsed();
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => DeletePortable(portable: portable));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backGroundSvg,
                        ),
                        child: SvgPicture.asset(
                          MmgAssets.portable,
                          color: Theme.of(context).primaryColor,
                          height: 20,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        portable.name!,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
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
