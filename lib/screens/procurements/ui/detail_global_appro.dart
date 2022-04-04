import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/appro_controller.dart';
import '/app/models/acc.dart';
import '/app/models/appro.dart';
import '/app/models/phone.dart';
import '/app/utils/formats/date.dart';
import '/screens/procurements/widgets/item_acc_appro.dart';
import '/screens/procurements/widgets/item_phone_appro.dart';

class DetailGlobalAprro extends StatefulWidget {
  const DetailGlobalAprro({Key? key, required this.appro}) : super(key: key);
  final Appro appro;

  @override
  State<DetailGlobalAprro> createState() => _DetailGlobalAprroState();
}

class _DetailGlobalAprroState extends State<DetailGlobalAprro> {
  ApproController approController = ApproController.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Détail Approvisionnement"),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            "Global",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Center(
                          child: Text(
                              "Le ${jour.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.appro.id!)))}"),
                        ),
                        if (widget.appro.nbrPhone > 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Dimensions.y4,
                              Text("Nbr Téléphones : ${widget.appro.nbrPhone}"),
                            ],
                          ),
                        if (widget.appro.nbrAcc > 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Dimensions.y4,
                              Text("Nbr Accessoires : ${widget.appro.nbrAcc}"),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (widget.appro.nbrPhone > 0)
              Column(
                children: [
                  Text(
                    "Téléphone(s)",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  FirebaseAnimatedList(
                    query:
                        approController.getPhoneGlobalAppro(widget.appro.id!),
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
                      final phone = Phone.fromJson(snapshot.value!);
                      return ItemPhoneAppro(phone: phone, anim: anim);
                    },
                  ),
                ],
              ),
            if (widget.appro.nbrAcc > 0)
              Column(
                children: [
                  Text(
                    "Accessoire(s)",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  FirebaseAnimatedList(
                    query: approController.getAccGlobalAppro(widget.appro.id!),
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
                      final acc = Acc.fromJson(snapshot.value!);
                      return ItemAccAppro(acc: acc, anim: anim);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
