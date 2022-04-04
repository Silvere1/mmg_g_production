import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/appro_controller.dart';
import '/app/models/appro.dart';
import '/screens/procurements/widgets/item_global_appro.dart';

class GlobalProcure extends StatefulWidget {
  const GlobalProcure({Key? key}) : super(key: key);

  @override
  State<GlobalProcure> createState() => _GlobalProcureState();
}

class _GlobalProcureState extends State<GlobalProcure> {
  final approController = ApproController.instance;
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        FirebaseAnimatedList(
            query: approController.getGlobalAppro(),
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
              final appro = Appro.fromJson(snapshot.value!);

              return ItemGlobalAppro(anim: anim, appro: appro);
            })
      ],
    );
  }
}
