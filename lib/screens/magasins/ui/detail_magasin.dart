import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/agence_controller.dart';
import '/app/controllers/vente_controller.dart';
import '/app/models/agence.dart';
import '/app/models/inventaire.dart';
import '/app/utils/formats/date.dart';
import '/app/utils/formats/money.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';
import '/screens/magasins/ui/employee_magasin.dart';
import '../../../app/models/user.dart';
import '../widgets/vente_day_magasin.dart';

class DetailMagasin extends StatefulWidget {
  const DetailMagasin({Key? key, required this.agence}) : super(key: key);
  final Agence agence;

  @override
  _DetailMagasinState createState() => _DetailMagasinState();
}

class _DetailMagasinState extends State<DetailMagasin> {
  VenteController venteController = VenteController.instance;
  AgenceController agenceController = AgenceController.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.agence.name),
          actions: [
            if (widget.agence.employers != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PopupMenuButton<User>(
                  itemBuilder: (_) => widget.agence.employers!
                      .map((e) => PopupMenuItem<User>(
                          value: e, child: Text(e.fullName)))
                      .toList(),
                  onSelected: (e) {
                    showDialog(
                        context: context,
                        builder: (_) => EmployeeMagasin(user: e));
                  },
                  child: SvgPicture.asset(
                    MmgAssets.realAgent,
                    color: Colors.white,
                    height: 24,
                  ),
                ),
              )
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            FirebaseAnimatedList(
              query: venteController.queryAgenceInventaire(widget.agence.id),
              reverse: true,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              defaultChild: SizedBox(
                height: Get.height * .9,
                child: const Center(child: CircularProgressIndicator()),
              ),
              duration: const Duration(seconds: 1),
              itemBuilder: (_, snapshot, anim, i) {
                if (kDebugMode) {
                  print(snapshot.value);
                }
                final inventaire = Inventaire.fromJson(snapshot.value!);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
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
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
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
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                                const Divider(),
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    Wrap(
                                      spacing: 4,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color:
                                                pureBlueColor.withOpacity(.2),
                                          ),
                                          child: SvgPicture.asset(
                                            MmgAssets.donate,
                                            height: 20,
                                            color: pureBlueColor,
                                          ),
                                        ),
                                        Text(
                                          setMoney(inventaire.oldNegation),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(color: pureBlueColor),
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      spacing: 4,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          setMoney(inventaire.oldDette),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(color: Colors.orange),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color:
                                                Colors.orange.withOpacity(.2),
                                          ),
                                          child: SvgPicture.asset(
                                            MmgAssets.receiveCash,
                                            height: 20,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Text(
                                  "Portable(s)",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          "Sorti(s) : ${inventaire.nbrPtSortis}"),
                                    ),
                                    Expanded(
                                        child: Text(
                                            "Vendu(s) : ${inventaire.nbrPtVendus}")),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          "Ramené(s) : ${inventaire.nbrPtBack}"),
                                    ),
                                    Expanded(
                                      child: Text(
                                          "Non ramené(s) : ${inventaire.nbrPtNoBack}"),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Text(
                                  "Accessoire(s) : ${inventaire.nbrAss}",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                const Divider(),
                                VenteDayMagasin(
                                    day: inventaire.id,
                                    agenceId: widget.agence.id),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
