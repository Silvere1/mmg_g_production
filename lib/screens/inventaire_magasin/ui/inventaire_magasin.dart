import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/user_controller.dart';
import '/app/controllers/vente_controller.dart';
import '/app/models/inventaire.dart';
import '/screens/inventaire_magasin/widgets/item_inventaire_magasin.dart';

class InventaireMagasin extends StatefulWidget {
  const InventaireMagasin({Key? key}) : super(key: key);

  @override
  State<InventaireMagasin> createState() => _InventaireMagasinState();
}

class _InventaireMagasinState extends State<InventaireMagasin> {
  VenteController venteController = VenteController.instance;
  UserController userController = UserController.instance;

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query:
          venteController.queryAgenceInventaire(userController.user!.agenceId!),
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
        return ItemInventaireMagasin(inventaire: inventaire);
      },
    );
  }
}
