import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '/app/models/portable.dart';

class PortableController extends GetxController {
  final DatabaseReference _reference =
      FirebaseDatabase.instance.ref().child("portables");
  static PortableController get instance => Get.find();
  var name = "".obs;

  void cleanVar() {
    name("");
  }

  Future<bool> createPortable() async {
    Portable portable = Portable(
        id: "null",
        name: name.value,
        used: false,
        imei: null,
        color: null,
        backed: null,
        payer: false,
        prix: null,
        montantRemis: null);

    var _portables = await _reference.get();
    var portables =
        _portables.children.map((e) => Portable.fromJson(e.value!)).toList();

    if (portables
        .any((e) => e.name!.toLowerCase() == portable.name!.toLowerCase())) {
      return false;
    } else {
      String? id = _reference.push().key;

      portable.id = id!;

      _reference.child(id).set(portable.toJson());
      cleanVar();
      return true;
    }
  }

  Future<void> setPortableUsed(List<Portable> portables) async {
    await _reference.runTransaction((value) {
      for (var e in portables) {
        _reference.child(e.id).update({"used": true});
      }
      return Transaction.abort();
    }, applyLocally: false);
  }

  deletePortable(Portable portableX) {
    _reference.child(portableX.id).remove();
  }

  Future<void> namePortableEditing(String str) async {
    name(str);
  }

  Future<List<Portable>> getPortables(String str) async {
    name(str);
    var _portables = await _reference.get();
    var portables =
        _portables.children.map((e) => Portable.fromJson(e.value!)).toList();
    var result = <Portable>[];
    for (var e in portables) {
      if (e.name!.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Portable>> getListPortables() async {
    var _portables = await _reference.get();
    var portables =
        _portables.children.map((e) => Portable.fromJson(e.value!)).toList();
    return portables;
  }

  Query queryPortables() => _reference;
}
