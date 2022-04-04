import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/app/models/vente.dart';
import '../../../app/utils/formats/date.dart';
import '../../../app/utils/formats/money.dart';
import '../../../res/assets_files.dart';

class ItemVenteEmployeeSearch extends StatelessWidget {
  const ItemVenteEmployeeSearch({Key? key, required this.vente})
      : super(key: key);
  final Vente vente;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffffdcd8),
                    ),
                    child: SvgPicture.asset(
                      vente.cancel != null && vente.cancel == true
                          ? MmgAssets.icNoCash
                          : MmgAssets.receiveCash,
                      color: Theme.of(context).primaryColor,
                      height: 30,
                    )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        vente.nameClient,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Wrap(
                        spacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            setMoney(vente.netPayer),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          if (vente.netPayer - vente.payer != 0)
                            const SizedBox(
                              height: 14,
                              child: VerticalDivider(
                                width: 0,
                                thickness: 3,
                                color: Colors.black38,
                              ),
                            ),
                          if (vente.netPayer - vente.payer != 0)
                            Text(
                              setMoney(vente.netPayer - vente.payer),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(color: Colors.red),
                            ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Wrap(
                            spacing: 10,
                            children: [
                              if (vente.portables != null)
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      MmgAssets.portable,
                                      height: 18,
                                    ),
                                    Text("${vente.portables!.length}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                  ],
                                ),
                              if (vente.articles != null)
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      MmgAssets.electronic,
                                      height: 18,
                                    ),
                                    Text("${vente.nbrAss}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                  ],
                                ),
                            ],
                          ),
                          Text(
                            "Le ${date.format(vente.craeteAt)}",
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
