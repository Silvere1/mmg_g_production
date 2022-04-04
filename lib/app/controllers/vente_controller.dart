import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '/app/controllers/client_controller.dart';
import '/app/controllers/stock_controller.dart';
import '/app/controllers/user_controller.dart';
import '/app/models/acc.dart';
import '/app/models/article.dart';
import '/app/models/client.dart';
import '/app/models/inventaire.dart';
import '/app/models/phone.dart';
import '/app/models/portable.dart';
import '/app/models/stock_m.dart';
import '/app/models/update_vente.dart';
import '/app/models/vente.dart';
import '/app/utils/formats/date.dart';

class VenteController extends GetxController {
  final DatabaseReference _reference =
      FirebaseDatabase.instance.ref().child("ventes");

  final DatabaseReference _inventairesRef =
      FirebaseDatabase.instance.ref().child("inventaires");

  final DatabaseReference _inventairesGlobalRef =
      FirebaseDatabase.instance.ref().child("inventaires").child("global");

  final DatabaseReference _clientOpRef =
      FirebaseDatabase.instance.ref().child("client_ope");

  final DatabaseReference _clientsDette =
      FirebaseDatabase.instance.ref().child("client_dettes");

  static VenteController get instance => Get.find();
  var total = 0.obs;
  var soldeArticle = 0.obs;
  var cirC = false.obs;
  var somValid = true.obs;
  var some = 0.obs;
  var nbrVendus = 0.obs;
  var nbrReBack = 0.obs;
  var nbrNoVendus = 0.obs;
  var nbrArticle = 0.obs;

  var listPortable = <Portable>[].obs;
  var listArticle = <Article>[].obs;
  var listPhones = <Phone>[].obs;
  var listAcc = <Acc>[].obs;

  //late Vente venteX;

  cleanLists() async {
    listArticle([]);
    listPortable([]);
    listPhones([]);
    listAcc([]);
    total(0);
    nbrVendus(0);
    nbrNoVendus(0);
    nbrReBack(0);
  }

  Future<void> getVenteX(Vente vente) async {
    if (vente.portables != null) {
      for (var e in vente.portables!) {
        listPortable.add(e);
      }
    }
    if (vente.articles != null) {
      for (var e in vente.articles!) {
        listArticle.add(e);
      }
    }
    // venteX = vente;
  }

  cleanVar() {
    cirC(false);
    somValid(true);
    some(0);
  }

  addPortable(Portable portableX) {
    listPortable.add(portableX);
    if (!listPhones.any((e) => e.id == portableX.id)) {
      listPhones.add(Phone(id: portableX.id, name: portableX.name!, qte: 1));
    } else {
      for (var e in listPhones) {
        if (e.id == portableX.id) {
          e.qte += 1;
        }
      }
    }
  }

  Future<void> editSomeRemi(int i, int s) async {
    some(0);
    listPortable[i].montantRemis = s;
    somValid(listPortable.every((e) => e.montantRemis! <= e.prix!));
    for (var e in listPortable) {
      some.value += e.montantRemis!;
    }
  }

  Future<void> reglementPortable(
      Vente vente, Portable portable, int i, int montant) async {
    cirC(true);
    UserController userController = UserController.instance;
    ClientsController clientsController = ClientsController.instance;
    String _toDay = DateTime.now().onlyDate().millisecondsSinceEpoch.toString();
    final _user = userController.user!;
    final _dayKey = vente.theDay.millisecondsSinceEpoch.toString();
    var _vente = vente;
    final _montantRemis = portable.montantRemis!;

    portable.montantRemis = _montantRemis + montant;
    portable.payer = portable.prix! - portable.montantRemis! == 0;
    _vente.portables![i] = portable;
    _vente.payer += montant;
    _vente.hasDette = _vente.netPayer - _vente.payer > 0;

    UpdateVente updateVente = UpdateVente(
      userName: _user.fullName,
      raison:
          "Payement de $montant Fcfa pour ${portable.name} de couleur : ${portable.color} & imei : ${portable.imei}",
      at: DateTime.now(),
    );
    if (_vente.updates == null) {
      _vente.updates = [updateVente];
    } else {
      _vente.updates!.add(updateVente);
    }

    Inventaire inventaire = Inventaire(
      id: _dayKey,
      nbrPtSortis: 0,
      nbrPtVendus: portable.payer ? 1 : 0,
      nbrPtNoBack: portable.payer ? -1 : 0,
      nbrPtBack: 0,
      nbrAss: 0,
      chiffre: montant,
      dette: -montant,
      oldDette: 0,
      oldNegation: 0,
    );
    Inventaire inventaireToDay = Inventaire(
      id: _toDay,
      nbrPtSortis: 0,
      nbrPtVendus: 0,
      nbrPtNoBack: 0,
      nbrPtBack: 0,
      nbrAss: 0,
      chiffre: 0,
      dette: 0,
      oldDette: montant,
      oldNegation: 0,
    );

    await _reference.runTransaction((value) {
      _reference.child(_dayKey).child(vente.id).update(_vente.toJson());
      return Transaction.abort();
    }, applyLocally: false);

    await _inventairesRef.runTransaction((value) {
      _inventairesRef
          .child(_vente.agenceId)
          .child(_dayKey)
          .update(inventaire.toJson());
      _inventairesGlobalRef.child(_dayKey).update(inventaire.toJson());
      if (_toDay != _dayKey) {
        _inventairesRef
            .child(_vente.agenceId)
            .child(_toDay)
            .update(inventaireToDay.toJson());
        _inventairesGlobalRef.child(_toDay).update(inventaireToDay.toJson());
      }
      return Transaction.abort();
    }, applyLocally: false);

    await clientsController.reglementDete(_vente.clientId!, montant);
    await _clientsDette
        .child(vente.agenceId)
        .child(vente.clientId!)
        .update({"solde": ServerValue.increment(montant)});
    cirC(false);
  }

  Future<void> backedPortable(Vente vente, Portable portable, int i) async {
    cirC(true);
    UserController userController = UserController.instance;
    StockController stockController = StockController.instance;
    ClientsController clientsController = ClientsController.instance;
    //String _toDay = DateTime.now().onlyDate().millisecondsSinceEpoch.toString();
    final _user = userController.user!;
    final _dayKey = vente.theDay.millisecondsSinceEpoch.toString();

    portable.backed = true;
    var _vente = vente;
    _vente.portables![i] = portable;
    _vente.netPayer -= portable.prix!;
    _vente.hasDette = _vente.netPayer - _vente.payer > 0;

    UpdateVente updateVente = UpdateVente(
      userName: _user.fullName,
      raison:
          "Le retour du ${portable.name} de couleur : ${portable.color} & imei : ${portable.imei}",
      at: DateTime.now(),
    );
    if (_vente.updates == null) {
      _vente.updates = [updateVente];
    } else {
      _vente.updates!.add(updateVente);
    }

    Inventaire inventaire = Inventaire(
      id: _dayKey,
      nbrPtSortis: 0,
      nbrPtVendus: 0,
      nbrPtNoBack: -1,
      nbrPtBack: 1,
      nbrAss: 0,
      chiffre: 0,
      dette: -portable.prix!,
      oldDette: 0,
      oldNegation: 0,
    );

    /* Inventaire inventaireToDay = Inventaire(
      id: _toDay,
      nbrPtSortis: 0,
      nbrPtVendus: 0,
      nbrPtNoBack: 0,
      nbrPtBack: 0,
      nbrAss: 0,
      chiffre: 0,
      dette: 0,
      oldDette: 0,
      oldNegation: -portable.prix!,
    );*/

    StockM stockM = StockM(nbrPhone: 1, nbrAcc: 0, name: _user.agenceName);
    StockM stockMGlobal = StockM(nbrPhone: 1, nbrAcc: 0, name: "Global");

    await _reference.runTransaction((value) {
      _reference.child(_dayKey).child(vente.id).update(_vente.toJson());
      return Transaction.abort();
    }, applyLocally: false);

    await _inventairesRef.runTransaction((value) {
      _inventairesRef
          .child(_vente.agenceId)
          .child(_dayKey)
          .update(inventaire.toJson());
      _inventairesGlobalRef.child(_dayKey).update(inventaire.toJson());

      /* if (_dayKey != _toDay) {
        _inventairesRef
            .child(_vente.agenceId)
            .child(_toDay)
            .update(inventaireToDay.toJson());
        _inventairesGlobalRef.child(_toDay).update(inventaireToDay.toJson());
      }*/
      return Transaction.abort();
    }, applyLocally: false);

    await stockController.reference.runTransaction((value) {
      stockController.reference
          .child("agences")
          .child(_vente.agenceId)
          .update(stockM.toJson());
      stockController.reference
          .child("agences")
          .child(_vente.agenceId)
          .child("phones")
          .child(portable.id)
          .update({"qte": ServerValue.increment(1)});
      stockController.reference.child("global").update(stockMGlobal.toJson());
      stockController.reference
          .child("global")
          .child("phones")
          .child(portable.id)
          .update({"qte": ServerValue.increment(1)});
      return Transaction.abort();
    }, applyLocally: false);
    await clientsController.reglementDete(_vente.clientId!, portable.prix!);
    await _clientsDette
        .child(vente.agenceId)
        .child(vente.clientId!)
        .update({"solde": ServerValue.increment(portable.prix!)});
    cirC(false);
  }

  deletePortableOfList(int i) {
    var x = listPortable[i];
    if (listPhones.any((e) => e.id == x.id && e.qte == 1)) {
      listPhones.removeWhere((e) => e.id == x.id && e.qte == 1);
    }
    if (listPhones.any((e) => e.id == x.id && e.qte > 1)) {
      for (var e in listPhones) {
        if (e.id == x.id && e.qte > 1) {
          e.qte -= 1;
        }
      }
    }
    listPortable.removeAt(i);
    getTotal();
  }

  deleteArticleOfList(int i) {
    var x = listArticle[i];
    listAcc.removeWhere((e) => e.id == x.id);
    listArticle.removeAt(i);
    getTotal();
  }

  Future<void> getTotal() async {
    total(0);
    soldeArticle(0);
    listAcc([]);
    nbrArticle(0);
    for (var e in listPortable) {
      total.value += e.prix!;
    }
    for (var e in listArticle) {
      final acc = Acc(id: e.id, name: e.name, qte: e.nbr!);
      listAcc.add(acc);
      total.value += e.prix!;
      soldeArticle.value += e.prix!;
      nbrArticle.value += e.nbr!;
    }
  }

  Future<void> cancelAVente(Vente vente, String raison) async {
    cirC(true);
    StockController stockController = StockController.instance;
    ClientsController clientsController = ClientsController.instance;
    String _toDay = DateTime.now().onlyDate().millisecondsSinceEpoch.toString();
    String _dayKey = vente.theDay.millisecondsSinceEpoch.toString();
    //int _nbrBack = 0;
    int _nbrDejaVendu = 0;
    int _nbrNoBack = 0;
    int _nbrAcc = 0;
    int _chiffre = 0;
    int _dette = 0;
    var _phones = <Phone>[];
    var _accs = <Acc>[];
    var _vente = vente;

    _nbrAcc = vente.nbrAss;
    _chiffre = vente.payer;
    _dette = vente.netPayer - vente.payer;
    if (vente.portables != null) {
      for (var e in vente.portables!) {
        if (e.payer == true) {
          _nbrDejaVendu += 1;
        } else {
          if (e.backed == null) {
            _nbrNoBack += 1;
          } else {
            // _nbrBack += 1;
          }
        }
        if (e.backed == null) {
          if (_phones.any((x) => x.id == e.id)) {
            for (var p in _phones) {
              if (p.id == e.id) {
                p.qte += 1;
              }
            }
          } else {
            _phones.add(Phone(id: e.id, name: e.name!, qte: 1));
          }
        }
      }
    }

    if (vente.articles != null) {
      for (var e in vente.articles!) {
        if (_accs.any((x) => x.id == e.id)) {
          for (var a in _accs) {
            if (a.id == e.id) {
              a.qte = e.nbr!;
            }
          }
        } else {
          _accs.add(Acc(id: e.id, name: e.name, qte: e.nbr!));
        }
      }
    }

    UpdateVente updateVente = UpdateVente(
      userName: vente.user.fullName,
      raison: "Annulation de la vente pour : $raison",
      at: DateTime.now(),
    );
    if (_vente.updates == null) {
      _vente.updates = [updateVente];
    } else {
      _vente.updates!.add(updateVente);
    }

    Inventaire inventaire = Inventaire(
      id: _dayKey,
      nbrPtSortis: 0,
      nbrPtVendus: -_nbrDejaVendu,
      nbrPtNoBack: -_nbrNoBack,
      nbrPtBack: _nbrNoBack + _nbrDejaVendu,
      nbrAss: -_nbrAcc,
      chiffre: -_chiffre,
      dette: -_dette,
      oldDette: 0,
      oldNegation: 0,
    );
    Inventaire inventaireToDay = Inventaire(
      id: _toDay,
      nbrPtSortis: 0,
      nbrPtVendus: 0,
      nbrPtNoBack: 0,
      nbrPtBack: 0,
      nbrAss: 0,
      chiffre: 0,
      dette: 0,
      oldDette: 0,
      oldNegation: -_chiffre,
    );

    if (_vente.portables != null) {
      for (var e in _vente.portables!) {
        e.backed = true;
      }
    }

    /// Dette
    if (vente.hasDette == true) {
      _vente.hasDette = false;
      _vente.cancel = true;
      await _reference.child(_dayKey).child(_vente.id).update(_vente.toJson());
      await clientsController.reglementDete(_vente.clientId!, _dette);
      await _clientsDette
          .child(vente.agenceId)
          .child(vente.clientId!)
          .update({"solde": ServerValue.increment(_dette)});
    }

    ///No Dette
    else {
      _vente.cancel = true;
      await _reference.child(_dayKey).child(_vente.id).update(_vente.toJson());
    }

    ///
    final stockM = StockM(
        nbrPhone: _nbrNoBack + _nbrDejaVendu,
        nbrAcc: _nbrAcc,
        name: vente.user.agenceName!);
    final stockMGlobal = StockM(
        nbrPhone: _nbrNoBack + _nbrDejaVendu, nbrAcc: _nbrAcc, name: "Global");

    ///
    await _inventairesGlobalRef.child(_dayKey).update(inventaire.toJson());

    await _inventairesRef
        .child(vente.agenceId)
        .child(_dayKey)
        .update(inventaire.toJson());

    if (_dayKey != _toDay) {
      await _inventairesGlobalRef
          .child(_toDay)
          .update(inventaireToDay.toJson());

      await _inventairesRef
          .child(vente.agenceId)
          .child(_toDay)
          .update(inventaireToDay.toJson());
    }

    ///
    await stockController.reference.runTransaction((value) {
      for (var e in _phones) {
        stockController.reference
            .child("agences")
            .child(vente.agenceId)
            .child("phones")
            .child(e.id)
            .update(e.toJson());
        stockController.global.child("phones").child(e.id).update(e.toJson());
      }

      for (var e in _accs) {
        stockController.reference
            .child("agences")
            .child(vente.agenceId)
            .child("accessoires")
            .child(e.id)
            .update(e.toJson());
        stockController.global
            .child("accessoires")
            .child(e.id)
            .update(e.toJson());
      }

      stockController.reference
          .child("agences")
          .child(vente.agenceId)
          .update(stockM.toJson());

      stockController.global.update(stockMGlobal.toJson());

      return Transaction.abort();
    }, applyLocally: false);
    cirC(false);
  }

  Future<void> createVente(
      {Client? client, String? clientName, String? tel, bool? noPayAll}) async {
    cirC(true);
    DateTime _toDay = DateTime.now().onlyDate();
    String _dayKey = _toDay.millisecondsSinceEpoch.toString();
    ClientsController clientsController = ClientsController.instance;
    UserController userController = UserController.instance;
    StockController stockController = StockController.instance;
    var _user = userController.user!;

    Inventaire inventaire = Inventaire(
      id: _dayKey,
      nbrPtSortis: listPortable.length,
      nbrPtVendus: 0,
      nbrPtNoBack: 0,
      nbrPtBack: 0,
      nbrAss: nbrArticle.value,
      chiffre: 0,
      dette: 0,
      oldDette: 0,
      oldNegation: 0,
    );

    ///Dette
    if (client != null && noPayAll! == true) {
      some(0);
      int _nbrPhonePayer = 0;

      for (var e in listPortable) {
        if (e.prix! == e.montantRemis!) {
          e.payer = true;
        } else {
          e.payer = false;
        }
        some.value += e.montantRemis!;
      }

      for (var e in listPortable) {
        if (e.payer) {
          _nbrPhonePayer += 1;
        }
      }

      Vente _vente = Vente(
        id: "id",
        portables: listPortable.isEmpty ? null : listPortable,
        articles: listArticle.isEmpty ? null : listArticle,
        user: _user,
        clientId: client.id,
        nameClient: client.fullName!,
        numClient: client.tel,
        netPayer: total.value,
        payer: some.value + soldeArticle.value,
        nbrPt: listPortable.length,
        nbrAss: nbrArticle.value,
        hasDette: true,
        cancel: null,
        agenceId: _user.agenceId!,
        updates: null,
        craeteAt: DateTime.now(),
        theDay: _toDay,
      );

      inventaire.nbrPtNoBack = listPortable.length - _nbrPhonePayer;
      inventaire.nbrPtVendus = _nbrPhonePayer;
      inventaire.chiffre = some.value + soldeArticle.value;
      inventaire.dette = total.value - some.value - soldeArticle.value;

      String? id = _reference.child(_dayKey).push().key;
      _vente.id = id!;
      await _reference.child(_dayKey).child(id).set(_vente.toJson());
      client.solde += some.value + soldeArticle.value - total.value;
      await clientsController.setDette(client);

      /// Very Important
      client.solde = (some.value + soldeArticle.value - total.value).toDouble();
      await _clientsDette
          .child(_user.agenceId!)
          .child(client.id)
          .update(client.toJson());
      await _clientOpRef.child(client.id).update({_dayKey: _dayKey});
    }

    ///No Dette
    if (client != null && noPayAll! == false) {
      for (var e in listPortable) {
        e.montantRemis = e.prix;
        e.payer = true;
      }

      Vente _vente = Vente(
        id: "id",
        portables: listPortable.isEmpty ? null : listPortable,
        articles: listArticle.isEmpty ? null : listArticle,
        user: _user,
        clientId: client.id,
        nameClient: client.fullName!,
        numClient: client.tel,
        netPayer: total.value,
        payer: total.value,
        nbrPt: listPortable.length,
        nbrAss: nbrArticle.value,
        hasDette: false,
        cancel: null,
        agenceId: _user.agenceId!,
        updates: null,
        craeteAt: DateTime.now(),
        theDay: _toDay,
      );

      inventaire.nbrPtVendus = listPortable.length;
      inventaire.chiffre = total.value;

      String? id = _reference.child(_dayKey).push().key;
      _vente.id = id!;
      await _reference.child(_dayKey).child(id).set(_vente.toJson());
      await _clientOpRef.child(client.id).update({_dayKey: _dayKey});
    }

    if (client == null && clientName == null && tel == null) {
      for (var e in listPortable) {
        e.montantRemis = e.prix;
        e.payer = true;
      }
      Vente _vente = Vente(
        id: "id",
        portables: listPortable.isEmpty ? null : listPortable,
        articles: listArticle.isEmpty ? null : listArticle,
        user: _user,
        clientId: null,
        nameClient: "Inconnu",
        numClient: null,
        netPayer: total.value,
        payer: total.value,
        nbrPt: listPortable.length,
        nbrAss: nbrArticle.value,
        hasDette: false,
        cancel: null,
        agenceId: _user.agenceId!,
        updates: null,
        craeteAt: DateTime.now(),
        theDay: _toDay,
      );

      inventaire.nbrPtVendus = listPortable.length;
      inventaire.chiffre = total.value;

      String? id = _reference.child(_dayKey).push().key;
      _vente.id = id!;
      await _reference.child(_dayKey).child(id).set(_vente.toJson());
    }
    if (client == null && clientName != null && tel != null) {
      var _client = await clientsController.clientForVente(clientName, tel);
      for (var e in listPortable) {
        e.montantRemis = e.prix;
        e.payer = true;
      }

      Vente _vente = Vente(
        id: "id",
        portables: listPortable.isEmpty ? null : listPortable,
        articles: listArticle.isEmpty ? null : listArticle,
        user: _user,
        clientId: _client.id,
        nameClient: _client.fullName!,
        numClient: _client.tel!,
        netPayer: total.value,
        payer: total.value,
        nbrPt: listPortable.length,
        nbrAss: nbrArticle.value,
        hasDette: false,
        cancel: null,
        agenceId: _user.agenceId!,
        updates: null,
        craeteAt: DateTime.now(),
        theDay: _toDay,
      );

      inventaire.nbrPtVendus = listPortable.length;
      inventaire.chiffre = total.value;

      String? id = _reference.child(_dayKey).push().key;
      _vente.id = id!;
      await _reference.child(_dayKey).child(id).set(_vente.toJson());
      await _clientOpRef.child(_client.id).update({_dayKey: _dayKey});
    }

    await _inventairesGlobalRef
        .child(_toDay.millisecondsSinceEpoch.toString())
        .update(inventaire.toJson());

    await _inventairesRef
        .child(_user.agenceId!)
        .child(_toDay.millisecondsSinceEpoch.toString())
        .update(inventaire.toJson());

    for (var e in listPhones) {
      e.qte = e.qte * (-1);
    }
    for (var e in listAcc) {
      e.qte = e.qte * (-1);
    }

    final stockM = StockM(
        nbrPhone: -listPortable.length,
        nbrAcc: -nbrArticle.value,
        name: _user.agenceName);
    final stockMGlobal = StockM(
        nbrPhone: -listPortable.length,
        nbrAcc: -nbrArticle.value,
        name: "Global");

    await stockController.reference.runTransaction((value) {
      for (var e in listPhones) {
        stockController.reference
            .child("agences")
            .child(_user.agenceId!)
            .child("phones")
            .child(e.id)
            .update(e.toJson());
        stockController.global.child("phones").child(e.id).update(e.toJson());
      }

      for (var e in listAcc) {
        stockController.reference
            .child("agences")
            .child(_user.agenceId!)
            .child("accessoires")
            .child(e.id)
            .update(e.toJson());
        stockController.global
            .child("accessoires")
            .child(e.id)
            .update(e.toJson());
      }

      stockController.reference
          .child("agences")
          .child(_user.agenceId!)
          .update(stockM.toJson());

      stockController.global.update(stockMGlobal.toJson());

      return Transaction.abort();
    }, applyLocally: false);

    cirC(false);
    Get.back();
    Get.back();
  }

  Query queryAgenceInventaire(String agenceId) =>
      _inventairesRef.child(agenceId);

  Query queryAgenceInventaire0ne(String agenceId) =>
      _inventairesRef.child(agenceId).limitToLast(1);

  Query queryGlobalInventaire() => _inventairesGlobalRef;

  Query queryGlobalInventaireOne() => _inventairesGlobalRef.limitToLast(1);

  Query queryClientOp(String clientId) => _clientOpRef.child(clientId);

  Query queryVentesOfAgence(String day, String agenceId) =>
      _reference.child(day).orderByChild("agenceId").equalTo(agenceId);

  Query queryVenteOfClient(String day, String clientId) =>
      _reference.child(day).orderByChild("clientId").equalTo(clientId);

  Query queryAllVentes(String day) => _reference.child(day);

  Query queryPortablesOfVente(String day, String venteId) =>
      _reference.child(day).child(venteId).child("portables");

  Query queryArticlesOfVente(String day, String venteId) =>
      _reference.child(day).child(venteId).child("articles");

  Query queryAVente(String day, String id) =>
      _reference.child(day).orderByKey().equalTo(id);

  Future<List<Vente>> getVentesClientDette(String day, String clientId) async {
    var _ventes = await _reference.child(day).get();
    var ventes = _ventes.children.map((e) => Vente.fromJson(e.value!)).toList();
    var result = <Vente>[];
    for (var e in ventes) {
      if (e.hasDette == true && e.clientId == clientId) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Vente>> getVentesClientDetteAgence(
      String day, String clientId, String agenceId) async {
    var _ventes = await _reference.child(day).get();
    var ventes = _ventes.children.map((e) => Vente.fromJson(e.value!)).toList();
    var result = <Vente>[];
    for (var e in ventes) {
      if (e.hasDette == true &&
          e.clientId == clientId &&
          e.agenceId == agenceId) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Vente>> getVentesSearch(
      String day, String agenceId, String str) async {
    var _ventes = await _reference
        .child(day)
        .orderByChild("agenceId")
        .equalTo(agenceId)
        .get();
    var ventes = _ventes.children.map((e) => Vente.fromJson(e.value!)).toList();
    var result = <Vente>[];
    for (var e in ventes) {
      if (e.nameClient.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Vente>> getVentesGlobalsSearch(String day, String str) async {
    var _ventes = await _reference.child(day).get();
    var ventes = _ventes.children.map((e) => Vente.fromJson(e.value!)).toList();
    var result = <Vente>[];
    for (var e in ventes) {
      if (e.nameClient.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }
}
