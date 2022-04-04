import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/app/models/vente.dart';
import '/screens/ventes/widgets/item_vente_portable_admin.dart';
import '../../../app/config/dimensions.dart';
import '../../../app/controllers/vente_controller.dart';
import '../../../app/services/call/call.dart';
import '../../../app/utils/formats/date.dart';
import '../../../app/utils/formats/money.dart';
import '../../../res/assets_files.dart';
import '../../ventes_employee/widgets/item_update_vente.dart';
import '../../ventes_employee/widgets/item_vente_article.dart';

class DetailVente extends StatefulWidget {
  const DetailVente({Key? key, required this.vente}) : super(key: key);
  final Vente vente;

  @override
  State<DetailVente> createState() => _DetailVenteState();
}

class _DetailVenteState extends State<DetailVente> {
  VenteController venteController = VenteController.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Détail de la vente"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FirebaseAnimatedList(
                query: venteController.queryAVente(
                    widget.vente.theDay.millisecondsSinceEpoch.toString(),
                    widget.vente.id),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                defaultChild: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                  ),
                ),
                duration: const Duration(seconds: 1),
                itemBuilder: (_, snapshot, anim, i) {
                  final vente = Vente.fromJson(snapshot.value!);
                  return Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Wrap(
                                    direction: Axis.vertical,
                                    spacing: 4,
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        spacing: 20,
                                        children: [
                                          if (vente.nbrPt != 0)
                                            Text(
                                              "Portable(s) : ${vente.nbrPt}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                          if (vente.nbrAss != 0)
                                            Text(
                                              "Accessoire(s) : ${vente.nbrAss}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                            ),
                                        ],
                                      ),
                                      Text(
                                        "Net à payer : ${setMoney(vente.netPayer)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      Text(
                                        "Payer : ${setMoney(vente.payer)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      if (vente.hasDette)
                                        Text(
                                          "Reste à payer : ${setMoney(vente.netPayer - vente.payer)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(color: Colors.red),
                                        ),
                                    ],
                                  ),
                                  Text(
                                    "Client : ${vente.nameClient}",
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                  if (widget.vente.numClient != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Wrap(
                                        spacing: 10,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                              "Tel : ${widget.vente.numClient}"),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Material(
                                              color: Colors.black12,
                                              child: InkWell(
                                                onTap: () {
                                                  Call().phone(
                                                      widget.vente.numClient!);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                    MmgAssets.icPhone,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Material(
                                              color: Colors.black12,
                                              child: InkWell(
                                                onTap: () {
                                                  Call().openWhatsapp(
                                                      widget.vente.numClient!);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SvgPicture.asset(
                                                    MmgAssets.icWhatsapp,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 6,
                                      children: [
                                        SvgPicture.asset(
                                          MmgAssets.realAgent,
                                          height: 18,
                                        ),
                                        Text(
                                          widget.vente.user.fullName,
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                        SvgPicture.asset(
                                          MmgAssets.magasinRegular,
                                          height: 18,
                                        ),
                                        Text(
                                          widget.vente.user.agenceName!,
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      "Le ${date.format(vente.craeteAt)}",
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                          color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (vente.cancel != null && vente.cancel == true)
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Colors.red[100],
                                  padding: const EdgeInsets.all(4),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 3,
                                    children: [
                                      SvgPicture.asset(
                                        MmgAssets.icNoCashRegular,
                                        height: 18,
                                      ),
                                      Text(
                                        "Vente annulée",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w900,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      if (vente.portables != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Dimensions.y10,
                            Text(
                              "Portable(s)",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            ListView.builder(
                              itemCount: vente.portables!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, i) => ItemVentePortableAdmin(
                                  portable: vente.portables![i]),
                            ),
                          ],
                        ),
                      if (vente.articles != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Dimensions.y10,
                            Text(
                              "Accessoire(s)",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            ListView.builder(
                              itemCount: vente.articles!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, i) =>
                                  ItemVenteArticle(article: vente.articles![i]),
                            ),
                          ],
                        ),
                      if (vente.updates != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Dimensions.y6,
                            Text(
                              "Historique des règlements",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            ListView.builder(
                              itemCount: vente.updates!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, i) => ItemUpdateVente(
                                  updateVente: vente.updates![i]),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
