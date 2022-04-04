import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/app/controllers/vente_controller.dart';
import '/app/models/vente.dart';
import '/screens/dettes/widgets/item_vente_client_dette.dart';
import '../../../app/models/client.dart';
import '../../../app/models/inventaire_client.dart';
import '../../../app/services/call/call.dart';
import '../../../app/utils/formats/money.dart';
import '../../../res/assets_files.dart';

class DetailAllDettesClient extends StatefulWidget {
  const DetailAllDettesClient({Key? key, required this.client})
      : super(key: key);
  final Client client;

  @override
  State<DetailAllDettesClient> createState() => _DetailAllDettesClientState();
}

class _DetailAllDettesClientState extends State<DetailAllDettesClient> {
  VenteController venteController = VenteController.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.client.fullName!),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Nom et Prénom(s)"),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    widget.client.fullName!,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  )))
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Num de téléphone"),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    widget.client.tel!,
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  )))
                        ],
                      ),
                      if (widget.client.solde < 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            Text(
                              "Dette : ${setMoney(widget.client.solde.toInt())}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(color: Colors.red),
                            ),
                          ],
                        ),
                      if (widget.client.tel != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Material(
                                  color: Colors.black12,
                                  child: InkWell(
                                    onTap: () {
                                      Call().phone(widget.client.tel!);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        MmgAssets.icPhone,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Material(
                                  color: Colors.black12,
                                  child: InkWell(
                                    onTap: () {
                                      Call().openWhatsapp(widget.client.tel!);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                    ],
                  ),
                ),
              ),
              FirebaseAnimatedList(
                query: venteController.queryClientOp(widget.client.id),
                reverse: true,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                defaultChild: const Center(child: CircularProgressIndicator()),
                itemBuilder: (_, snapshot, anim, i) {
                  final day = InventaireClient.fromJson(snapshot.value!);
                  final _day = day.theDay.millisecondsSinceEpoch.toString();
                  return FutureBuilder<List<Vente>>(
                    future: venteController.getVentesClientDette(
                        _day, widget.client.id),
                    builder: (__, snap) {
                      if (snap.hasData) {
                        return ListView.builder(
                          itemCount: snap.data!.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 8),
                          itemBuilder: (___, i) =>
                              ItemVenteClientDette(vente: snap.data![i]),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
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
