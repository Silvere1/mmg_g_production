import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/appro_controller.dart';
import '/app/models/appro.dart';
import '/app/utils/formats/date.dart';
import '/screens/procurements/widgets/item_agence_appro.dart';

class AgenceProcureAdmin extends StatefulWidget {
  const AgenceProcureAdmin({Key? key}) : super(key: key);

  @override
  State<AgenceProcureAdmin> createState() => _AgenceProcureAdminState();
}

class _AgenceProcureAdminState extends State<AgenceProcureAdmin> {
  final approController = ApproController.instance;
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        FirebaseAnimatedList(
            query: approController.getGlobalDateAppro(),
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
                print(snapshot.key);
              }
              final date = snapshot.value as String;
              return Column(
                children: [
                  Text(
                    "Le ${jour.format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)))}",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  FirebaseAnimatedList(
                    query: approController.getAgenceAppro(date),
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
                      final appro = Appro.fromJson(snapshot.value!);

                      return ItemAgenceAppro(
                          anim: anim, appro: appro, agenceId: snapshot.key!);
                    },
                  ),
                ],
              );
            })
      ],
    );
  }
}
