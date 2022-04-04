import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/models/agence.dart';

class AgenceController extends GetxController {
  static AgenceController get instance => Get.find();
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child("agences");
  var nameAgence = "".obs;
  var cir = false.obs;

  Future<void> creatAgence() async {
    setCir(true);
    Agence agence = Agence(id: "id", name: nameAgence.value, employers: null);

    await reference.get().then((value) async {
      var _agences = value.children.map((e) => Agence.fromJson(e.value!));
      if (_agences
          .any((e) => e.name.toLowerCase() == nameAgence.value.toLowerCase())) {
        Get.back();
        Get.defaultDialog(
            title: "Attention",
            content: Text("Le nom '$nameAgence' est existe déjà."),
            confirm: SizedBox(
                width: 100,
                child: ElevatedButton(
                    onPressed: () => Get.back(), child: const Text("Ok"))));
      } else {
        String? id = reference.push().key;
        agence.id = id!;
        reference
            .child(id)
            .set(agence.toJson())
            .catchError((e) {
              if (kDebugMode) {
                print("Jai dl'erreur $e");
              }
            })
            .onError((error, stackTrace) => debugPrint(error.toString()))
            .whenComplete(() => debugPrint("C'est Ok"));
        cleanVar();
        Get.back();
      }
    });
    setCir(false);
  }

  Future<void> cleanVar() async {
    nameAgence("");
    cir(false);
  }

  setCir(bool v) {
    cir(v);
  }

  Future<void> editName(String val) async {
    if (val.length >= 4) {
      nameAgence(val.trim());
    } else {
      nameAgence("");
    }
  }

  Query queryAgences() {
    return reference;
  }
}
