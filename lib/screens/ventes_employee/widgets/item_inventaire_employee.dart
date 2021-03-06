import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/app/config/dimensions.dart';
import '/app/models/inventaire.dart';
import '/app/utils/formats/date.dart';
import '/app/utils/formats/money.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';
import '../ui/vente_day_employee.dart';

class ItemInventaireEmployee extends StatelessWidget {
  const ItemInventaireEmployee({
    Key? key,
    required this.inventaire,
    required this.agenceId,
  }) : super(key: key);

  final Inventaire inventaire;
  final String agenceId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black38,
              spreadRadius: -1,
              blurRadius: 2,
              offset: Offset(0, 2))
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "Le ${jour.format(DateTime.fromMillisecondsSinceEpoch(int.parse(inventaire.id)))}",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Dimensions.y4,
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Wrap(
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: verteCielColor,
                          ),
                          child: SvgPicture.asset(
                            MmgAssets.profit,
                            height: 20,
                            color: verteColor,
                          ),
                        ),
                        Text(
                          setMoney(inventaire.chiffre),
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: verteColor),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          setMoney(inventaire.dette),
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.red),
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.red.withOpacity(.2),
                          ),
                          child: SvgPicture.asset(
                            MmgAssets.dette,
                            height: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Dimensions.y10,
                VenteDayEmployee(day: inventaire.id, agenceId: agenceId)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
