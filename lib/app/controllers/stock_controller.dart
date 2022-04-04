import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '/app/controllers/user_controller.dart';
import '/app/models/acc.dart';
import '/app/models/agence.dart';
import '/app/models/phone.dart';
import '/app/models/stock_m.dart';

class StockController extends GetxController {
  static StockController get instance => Get.find();
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child("stock");

  final DatabaseReference global =
      FirebaseDatabase.instance.ref().child("stock").child("global");

  Future<void> addToStock(List<Phone> phones, List<Acc> accs, StockM stockM,
      StockM stockMGlobal, Agence agence) async {
    await reference.runTransaction((value) {
      for (var e in phones) {
        reference
            .child("agences")
            .child(agence.id)
            .child("phones")
            .child(e.id)
            .update(e.toJson());
        global.child("phones").child(e.id).update(e.toJson());
      }
      for (var e in accs) {
        reference
            .child("agences")
            .child(agence.id)
            .child("accessoires")
            .child(e.id)
            .update(e.toJson());
        global.child("accessoires").child(e.id).update(e.toJson());
      }
      reference.child("agences").child(agence.id).update(stockM.toJson());
      global.update(stockMGlobal.toJson());
      return Transaction.abort();
    }, applyLocally: false);
  }

  Query getGlobalStock() => reference.orderByKey().equalTo("global");
  Query getAgenceStock() => reference.child("agences");
  Query getAgenceStockEmployee(String agenceId) =>
      reference.child("agences").orderByKey().equalTo(agenceId);

  Query getGlobalPhoneStock() => global.child("phones");
  Query getGlobalAccStock() => global.child("accessoires");

  Query getAgencePhoneStock(String id) =>
      reference.child("agences").child(id).child("phones");
  Query getAgenceAccStock(String id) =>
      reference.child("agences").child(id).child("accessoires");

  Future<List<Phone>> getPhones() async {
    UserController userController = UserController.instance;
    var _phones = await reference
        .child("agences")
        .child(userController.user!.agenceId!)
        .child("phones")
        .get();
    var phones = _phones.children.map((e) => Phone.fromJson(e.value!)).toList();
    return phones;
  }

  Future<List<Acc>> getAccs() async {
    UserController userController = UserController.instance;
    var _accs = await reference
        .child("agences")
        .child(userController.user!.agenceId!)
        .child("accessoires")
        .get();
    var accs = _accs.children.map((e) => Acc.fromJson(e.value!)).toList();
    return accs;
  }

  Future<List<Phone>> getPhoneSearch(String str) async {
    UserController userController = UserController.instance;
    var _portables = await reference
        .child("agences")
        .child(userController.user!.agenceId!)
        .child("phones")
        .get();
    var portables =
        _portables.children.map((e) => Phone.fromJson(e.value!)).toList();
    var result = <Phone>[];
    for (var e in portables) {
      if (e.name.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Acc>> getAccSearch(String str) async {
    UserController userController = UserController.instance;
    var _accs = await reference
        .child("agences")
        .child(userController.user!.agenceId!)
        .child("accessoires")
        .get();
    var accs = _accs.children.map((e) => Acc.fromJson(e.value!)).toList();
    var result = <Acc>[];
    for (var e in accs) {
      if (e.name.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Acc>> getAccGlobalSearch(String str) async {
    var _accs = await global.child("accessoires").get();
    var accs = _accs.children.map((e) => Acc.fromJson(e.value!)).toList();
    var result = <Acc>[];
    for (var e in accs) {
      if (e.name.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Phone>> getPhoneGlobalSearch(String str) async {
    var _portables = await global.child("phones").get();
    var portables =
        _portables.children.map((e) => Phone.fromJson(e.value!)).toList();
    var result = <Phone>[];
    for (var e in portables) {
      if (e.name.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Acc>> getAccAgenceAdminSearch(String str, String id) async {
    var _accs =
        await reference.child("agences").child(id).child("accessoires").get();
    var accs = _accs.children.map((e) => Acc.fromJson(e.value!)).toList();
    var result = <Acc>[];
    for (var e in accs) {
      if (e.name.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Phone>> getPhoneAgenceSearchAdmin(String str, String id) async {
    var _portables =
        await reference.child("agences").child(id).child("phones").get();
    var portables =
        _portables.children.map((e) => Phone.fromJson(e.value!)).toList();
    var result = <Phone>[];
    for (var e in portables) {
      if (e.name.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }
}
