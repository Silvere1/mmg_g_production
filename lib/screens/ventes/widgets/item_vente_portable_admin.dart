import 'package:flutter/material.dart';

import '/app/models/portable.dart';
import '../../../app/config/dimensions.dart';
import '../../../app/models/phone_color.dart';
import '../../../app/utils/formats/money.dart';

class ItemVentePortableAdmin extends StatelessWidget {
  const ItemVentePortableAdmin({Key? key, required this.portable})
      : super(key: key);
  final Portable portable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(8),
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
                Dimensions.y2,
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        Text("Prix : ${setMoney(portable.prix!)}"),
                        if (portable.backed == null
                            ? portable.prix! - portable.montantRemis! != 0
                            : false)
                          const SizedBox(
                            height: 14,
                            child: VerticalDivider(
                              width: 0,
                              thickness: 3,
                              color: Colors.black38,
                            ),
                          ),
                        if (portable.backed == null
                            ? portable.prix! - portable.montantRemis! != 0
                            : false)
                          Text(
                            setMoney(portable.prix! - portable.montantRemis!),
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.red),
                          ),
                      ],
                    ),
                    portable.backed == null
                        ? Text(portable.payer ? "Payé" : "Non Payer")
                        : const Text("Ramené"),
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
