import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/stock_controller.dart';
import '/app/controllers/vente_controller.dart';
import '/app/utils/formats/date.dart';
import '/app/utils/formats/money.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';
import '/screens/home/components/new_procurement.dart';
import '../../../app/models/inventaire.dart';
import '../../../app/models/stock_m.dart';
import '../../global/widgets/indicator.dart';

class AdminDash extends StatefulWidget {
  const AdminDash({Key? key}) : super(key: key);

  @override
  _AdminDashState createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
  VenteController venteController = VenteController.instance;
  StockController stockController = StockController.instance;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      child: Column(
        children: [
          FirebaseAnimatedList(
              query: venteController.queryGlobalInventaireOne(),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              defaultChild: SizedBox(
                height: Get.height * .9,
                child: const Center(child: CircularProgressIndicator()),
              ),
              itemBuilder: (_, snapshot, anim, i) {
                final iv = Inventaire.fromJson(snapshot.value!);
                final t =
                    iv.chiffre + iv.dette + iv.oldDette + (-1 * iv.oldNegation);
                final v = (iv.chiffre * 100) / t;
                final d = (iv.dette * 100) / t;
                final od = (iv.oldDette * 100) / t;
                final p = ((-1) * iv.oldNegation * 100) / t;

                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Recette du ${jour.format(DateTime.fromMillisecondsSinceEpoch(int.parse(iv.id)))}",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 180,
                                    child: PieChart(
                                      PieChartData(
                                          pieTouchData: PieTouchData(
                                              touchCallback:
                                                  (FlTouchEvent event,
                                                      pieTouchResponse) {
                                            setState(() {
                                              if (!event
                                                      .isInterestedForInteractions ||
                                                  pieTouchResponse == null ||
                                                  pieTouchResponse
                                                          .touchedSection ==
                                                      null) {
                                                touchedIndex = -1;
                                                return;
                                              }
                                              touchedIndex = pieTouchResponse
                                                  .touchedSection!
                                                  .touchedSectionIndex;
                                            });
                                          }),
                                          borderData: FlBorderData(
                                            show: false,
                                          ),
                                          sectionsSpace: .5,
                                          centerSpaceRadius: 28,
                                          sections: showMySections(
                                              v: 1 + v,
                                              d: 1 + d,
                                              p: 1 + p,
                                              od: 1 + od)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Indicator(
                                        color: verteColor,
                                        text: "Ventes",
                                        isSquare: false,
                                        size: touchedIndex == 0 ? 18 : 16,
                                        textColor: touchedIndex == 0
                                            ? verteColor
                                            : Colors.grey,
                                      ),
                                      const SizedBox(height: 4),
                                      Indicator(
                                        color: Colors.red,
                                        text: "Dettes",
                                        isSquare: false,
                                        size: touchedIndex == 1 ? 18 : 16,
                                        textColor: touchedIndex == 1
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      const SizedBox(height: 4),
                                      Indicator(
                                        color: pureBlueColor,
                                        text: "Remboursements",
                                        isSquare: false,
                                        size: touchedIndex == 2 ? 18 : 16,
                                        textColor: touchedIndex == 2
                                            ? pureBlueColor
                                            : Colors.grey,
                                      ),
                                      const SizedBox(height: 4),
                                      Indicator(
                                        color: Colors.orange,
                                        text: "Règlements",
                                        isSquare: false,
                                        size: touchedIndex == 3 ? 18 : 16,
                                        textColor: touchedIndex == 3
                                            ? Colors.orange
                                            : Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildSoldeInventaire(context,
                                      MmgAssets.profit, verteColor, iv.chiffre),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  buildSoldeInventaire(context, MmgAssets.dette,
                                      Colors.red, iv.dette),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildSoldeInventaire(context, MmgAssets.donate,
                                    pureBlueColor, iv.oldNegation),
                                const SizedBox(
                                  width: 8,
                                ),
                                buildSoldeInventaire(
                                    context,
                                    MmgAssets.receiveCash,
                                    Colors.orange,
                                    iv.oldDette),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Détail ventes",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildPhoneVente(context, "Sortis",
                                      Colors.orange, iv.nbrPtSortis),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  buildPhoneVente(context, "Vendus", verteColor,
                                      iv.nbrPtVendus),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildPhoneVente(context, "Ramenés",
                                    Colors.purple, iv.nbrPtBack),
                                const SizedBox(
                                  width: 8,
                                ),
                                buildPhoneVente(context, "Non Ramenés",
                                    Colors.redAccent, iv.nbrPtNoBack),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            buildAccVente(context, "Accessoires",
                                Colors.redAccent, iv.nbrAss),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
          Dimensions.y28,
          FirebaseAnimatedList(
              query: stockController.getGlobalStock(),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, snapshot, anim, i) {
                final stockM = StockM.fromJson(snapshot.value!);
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Stock",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(() => const NewProcurement());
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 40),
                              ),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: const [
                                  Icon(Icons.add),
                                  Text("Articles")
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: SvgPicture.asset(
                                  MmgAssets.phoneColored,
                                  height: 24,
                                  //color: color,
                                  colorBlendMode: BlendMode.modulate,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              SizedBox(
                                //width: MediaQuery.of(context).size.width * .3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Portables",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                            fontSize: 13,
                                          ),
                                    ),
                                    Text(
                                      "${stockM.nbrPhone}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: SvgPicture.asset(
                                  MmgAssets.electricColored,
                                  height: 24,
                                  //color: color,
                                  colorBlendMode: BlendMode.modulate,
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Accessoires",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                            fontSize: 13,
                                          ),
                                    ),
                                    Text(
                                      "${stockM.nbrAcc}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Expanded buildPhoneVente(
      BuildContext context, String title, Color color, int nbr) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(2),
              child: SvgPicture.asset(
                MmgAssets.phoneColored,
                height: 24,
                color: color,
                colorBlendMode: BlendMode.modulate,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontSize: 13,
                      ),
                ),
                Text(
                  "$nbr",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildAccVente(
      BuildContext context, String title, Color color, int nbr) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: SvgPicture.asset(
              MmgAssets.electricColored,
              height: 24,
              color: color,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          SizedBox(
            //width: MediaQuery.of(context).size.width * .3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontSize: 13,
                      ),
                ),
                Text(
                  "$nbr",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildSoldeInventaire(
      BuildContext context, String icon, Color color, int money) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: color.withOpacity(.2),
              ),
              child: SvgPicture.asset(
                icon,
                height: 24,
                color: color,
                colorBlendMode: BlendMode.modulate,
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            AutoSizeText(
              setMoney(money),
              minFontSize: 10,
              maxLines: 1,
              style:
                  Theme.of(context).textTheme.headline3!.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  int touchedIndex = -1;
  List<PieChartSectionData> showMySections(
      {required double v,
      required double d,
      required double p,
      required double od}) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: verteColor,
            value: v,
            title: '${(v - 1).toPrecision(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: d,
            title: '${(d - 1).toPrecision(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        case 2:
          return PieChartSectionData(
            color: pureBlueColor,
            value: p,
            title: '${(p - 1).toPrecision(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.orange,
            value: od,
            title: '${(od - 1).toPrecision(1)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          );
        default:
          throw Error();
      }
    });
  }
}
