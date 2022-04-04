import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/appro_controller.dart';
import '/app/models/phone.dart';
import '/app/utils/formats/mask_formater.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';

class ItemPhoneCollectionAppro extends StatelessWidget {
  const ItemPhoneCollectionAppro(
      {Key? key,
      required this.listKey,
      required this.i,
      required this.anim,
      required this.phone,
      required this.approController})
      : super(key: key);
  final GlobalKey<AnimatedListState> listKey;
  final int i;
  final Animation<double> anim;
  final Phone phone;
  final ApproController approController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: anim,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          phone.name,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Dimensions.y2,
                        TextField(
                          onChanged: (value) async {
                            if (value.trim().isNotEmpty) {
                              await approController.getPhoneQte(
                                  i, int.parse(value));
                            } else {
                              await approController.getPhoneQte(i, 1);
                            }
                          },
                          inputFormatters: [prixMaskFormatter],
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              fillColor: backGround,
                              hintStyle: Theme.of(context).textTheme.headline3,
                              hintText: "Qte : ${phone.qte}"),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      listKey.currentState!.removeItem(
                          i,
                          (_, animation) => ItemPhoneCollectionAppro(
                                listKey: listKey,
                                i: i,
                                anim: animation,
                                phone: phone,
                                approController: approController,
                              ));
                      await approController.deletePhone(i);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        MmgAssets.delete,
                        height: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
