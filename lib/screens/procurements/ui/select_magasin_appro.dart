import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/agence_controller.dart';
import '/app/models/agence.dart';
import '/screens/procurements/widgets/item_select_magasin_appro.dart';

class SelectMagasinAppro extends StatefulWidget {
  const SelectMagasinAppro({Key? key}) : super(key: key);

  @override
  State<SelectMagasinAppro> createState() => _SelectMagasinApproState();
}

class _SelectMagasinApproState extends State<SelectMagasinAppro> {
  AgenceController agenceController = AgenceController.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sélectionner un magasin"),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            FirebaseAnimatedList(
              query: agenceController.queryAgences(),
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
                final agence = Agence.fromJson(snapshot.value!);
                return ItemSelectMagasinAppro(anim: anim, agence: agence);
              },
            ),
          ],
        ),
      ),
    );
  }
}
