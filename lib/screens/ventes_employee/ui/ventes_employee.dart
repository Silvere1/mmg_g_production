import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/user_controller.dart';
import '/app/controllers/vente_controller.dart';
import '/app/models/inventaire.dart';
import '/screens/ventes_employee/ui/collections.dart';
import '../widgets/item_inventaire_employee.dart';

class VentesEmployee extends StatefulWidget {
  const VentesEmployee({Key? key}) : super(key: key);

  @override
  _VentesEmployeeState createState() => _VentesEmployeeState();
}

class _VentesEmployeeState extends State<VentesEmployee> {
  VenteController venteController = VenteController.instance;
  UserController userController = UserController.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          FirebaseAnimatedList(
            query: venteController
                .queryAgenceInventaire(userController.user!.agenceId!),
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
                  ItemInventaireEmployee(
                      inventaire: inventaire,
                      agenceId: userController.user!.agenceId!),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const Collections());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
