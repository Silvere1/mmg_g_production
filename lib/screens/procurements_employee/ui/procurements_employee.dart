import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/appro_controller.dart';
import '/app/controllers/user_controller.dart';
import '/app/models/acc.dart';
import '/app/models/appro.dart';
import '/app/models/phone.dart';
import '/app/utils/formats/date.dart';
import '/screens/stock/widgets/item_acc_stock_agence.dart';
import '/screens/stock/widgets/item_phone_stock_agence.dart';

class ProcurementEmployee extends StatefulWidget {
  const ProcurementEmployee({Key? key}) : super(key: key);

  @override
  State<ProcurementEmployee> createState() => _ProcurementEmployeeState();
}

class _ProcurementEmployeeState extends State<ProcurementEmployee> {
  ApproController approController = ApproController.instance;
  UserController userController = UserController.instance;
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        FirebaseAnimatedList(
            query: approController
                .getAgenceDateAppro(userController.user!.agenceId!),
            reverse: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                      query: approController.getAgenceApproEmployee(
                          date, userController.user!.agenceId!),
                      reverse: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, snapshot, anim, i) {
                        final appro = Appro.fromJson(snapshot.value!);
                        return SizeTransition(
                          sizeFactor: anim,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Material(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Center(
                                        child: Text(
                                          appro.name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),
                                      ),
                                      if (appro.nbrPhone > 0)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Dimensions.y4,
                                            Text(
                                                "Nbr Téléphones : ${appro.nbrPhone}"),
                                          ],
                                        ),
                                      if (appro.nbrAcc > 0)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Dimensions.y4,
                                            Text(
                                                "Nbr Accessoires : ${appro.nbrAcc}"),
                                          ],
                                        ),
                                      if (appro.nbrPhone > 0)
                                        ExpansionTile(
                                          tilePadding: EdgeInsets.zero,
                                          title: const Text("Téléphone(s)"),
                                          children: [
                                            FirebaseAnimatedList(
                                                query: approController
                                                    .getPhoneAgenceAppro(
                                                        date, snapshot.key!),
                                                reverse: true,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                defaultChild: const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                                duration:
                                                    const Duration(seconds: 1),
                                                itemBuilder:
                                                    (_, snapshot, anim, i) {
                                                  if (kDebugMode) {
                                                    print(snapshot.value);
                                                    print(snapshot.key);
                                                  }
                                                  final phone = Phone.fromJson(
                                                      snapshot.value!);

                                                  return ItemPhoneStockAgence(
                                                      anim: anim, phone: phone);
                                                })
                                          ],
                                        ),
                                      if (appro.nbrAcc > 0)
                                        ExpansionTile(
                                          tilePadding: EdgeInsets.zero,
                                          title: const Text("Accessoire(s)"),
                                          children: [
                                            FirebaseAnimatedList(
                                                query: approController
                                                    .getAccAgenceAppro(
                                                        date, snapshot.key!),
                                                reverse: true,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                defaultChild: const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                                duration:
                                                    const Duration(seconds: 1),
                                                itemBuilder:
                                                    (_, snapshot, anim, i) {
                                                  if (kDebugMode) {
                                                    print(snapshot.value);
                                                    print(snapshot.key);
                                                  }
                                                  final acc = Acc.fromJson(
                                                      snapshot.value!);

                                                  return ItemAccStockAgence(
                                                      anim: anim, acc: acc);
                                                })
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                ],
              );
            })
      ],
    );
  }
}
