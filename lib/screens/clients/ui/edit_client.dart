import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/app/controllers/client_controller.dart';
import '/app/controllers/vente_controller.dart';
import '/app/models/client.dart';
import '/app/models/inventaire_client.dart';
import '/app/models/vente.dart';
import '/app/utils/formats/date.dart';
import '/app/utils/formats/money.dart';
import '/screens/clients/widgets/item_vente_client.dart';
import '../../../app/services/call/call.dart';
import '../../../res/assets_files.dart';

class EditClient extends StatefulWidget {
  const EditClient({Key? key, required this.client}) : super(key: key);
  final Client client;

  @override
  _EditClientState createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {
  ClientsController clientsController = ClientsController.instance;
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      widget.client.canDette = !widget.client.canDette;
                    });
                    clientsController.setEligibility(widget.client);
                  },
                  child: Row(
                    children: [
                      Checkbox(
                          value: widget.client.canDette,
                          onChanged: (value) {
                            setState(() {
                              widget.client.canDette = !widget.client.canDette;
                            });
                            clientsController.setEligibility(widget.client);
                          }),
                      const Text("Eligible aux dettes")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Achat(s) effectué(s)",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              FirebaseAnimatedList(
                query: venteController.queryClientOp(widget.client.id),
                reverse: true,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                defaultChild: const Center(child: CircularProgressIndicator()),
                duration: const Duration(seconds: 1),
                itemBuilder: (_, snapshot, anim, i) {
                  if (kDebugMode) {
                    print(snapshot.value);
                  }
                  final day = InventaireClient.fromJson(snapshot.value!);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        jour.format(day.theDay),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      FirebaseAnimatedList(
                        query: venteController.queryVenteOfClient(
                            day.theDay.millisecondsSinceEpoch.toString(),
                            widget.client.id),
                        reverse: true,
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
                          if (kDebugMode) {
                            print(snapshot.value);
                          }
                          final vente = Vente.fromJson(snapshot.value!);
                          return ItemVenteClient(anim: anim, vente: vente);
                        },
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
