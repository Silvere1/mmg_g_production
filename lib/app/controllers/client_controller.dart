import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '/app/models/client.dart';

class ClientsController extends GetxController {
  final DatabaseReference _reference =
      FirebaseDatabase.instance.ref().child("clients");
  final DatabaseReference _clientsDette =
      FirebaseDatabase.instance.ref().child("client_dettes");
  static ClientsController get instance => Get.find();
  var name = "".obs;
  var tel = "".obs;
  var cirC = false.obs;

  clenVar() {
    name("");
    tel("");
    cirC(false);
  }

  Future<void> editingName(String str) async {
    if (str.trim().isNotEmpty) {
      name(str.trim());
    } else {
      name("");
    }
  }

  Future<void> editingTel(String str) async {
    if (str.trim().isNotEmpty) {
      tel(str.trim());
    } else {
      tel("");
    }
  }

  Future<List<Client>> getClients(String str) async {
    var _clients = await _reference.get();
    var clients =
        _clients.children.map((e) => Client.fromJson(e.value!)).toList();
    var result = <Client>[];
    for (var e in clients) {
      if (e.fullName!.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }

  Future<void> setDette(Client client) async {
    await _reference.child(client.id).update(client.toJson());
  }

  Future<void> reglementDete(String idClient, int s) async {
    await _reference
        .child(idClient)
        .update({"solde": ServerValue.increment(s)});
  }

  Future<Client> clientForVente(String name, String tel) async {
    Client client =
        Client(id: "id", fullName: name, tel: tel, canDette: false, solde: 0);
    String? id = _reference.push().key;
    client.id = id!;
    await _reference.child(id).set(client.toJson());
    var _client = await _reference.child(id).get();
    return Client.fromJson(_client.value!);
  }

  Future<bool> createClient(bool canDette) async {
    Client client = Client(
        id: "id",
        fullName: name.value,
        tel: tel.value,
        canDette: canDette,
        solde: 0);
    cirC(true);
    var clients = await _reference.get();
    var listClient = clients.children.map((e) => Client.fromJson(e.value!));
    if (listClient.any((e) =>
        e.fullName!.toLowerCase() == client.fullName!.toLowerCase() ||
        e.tel! == client.tel!)) {
      cirC(false);
      return false;
    } else {
      String? id = _reference.push().key;
      client.id = id!;
      _reference.child(id).set(client.toJson());
      cirC(false);
      clenVar();
      return true;
    }
  }

  Future<String> getNameClient(String clientId) async {
    var _result = await _reference.child(clientId).get();
    var _client = Client.fromJson(_result);
    return _client.fullName!;
  }

  Future<void> setEligibility(Client client) async {
    _reference.child(client.id).child("canDette").set(client.canDette);
  }

  Future<List<Client>> getClientsFilter(String str, bool favor) async {
    var _clients =
        await _reference.orderByChild("canDette").equalTo(favor).get();
    var clients =
        _clients.children.map((e) => Client.fromJson(e.value!)).toList();
    var result = <Client>[];
    for (var e in clients) {
      if (e.fullName!.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Client>> getClientsHasDettes() async {
    var _clients = await _reference.get();
    var clients =
        _clients.children.map((e) => Client.fromJson(e.value!)).toList();
    var result = <Client>[];
    for (var e in clients) {
      if (e.solde < 0) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Client>> getClientsHasDettesAgence(String agenceId) async {
    var _clients = await _clientsDette.child(agenceId).get();
    var clients =
        _clients.children.map((e) => Client.fromJson(e.value!)).toList();
    var result = <Client>[];
    for (var e in clients) {
      if (e.solde < 0) {
        result.add(e);
      }
    }
    return result;
  }

  Query queryClients() => _reference;
  Query queryClientsFavor() =>
      _reference.orderByChild("canDette").equalTo(true);
  Query queryClientsOrdinary() =>
      _reference.orderByChild("canDette").equalTo(false);

  ///Dette

}
