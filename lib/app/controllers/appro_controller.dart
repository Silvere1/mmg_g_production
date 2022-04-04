import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '/app/controllers/article_controller.dart';
import '/app/controllers/portable_controller.dart';
import '/app/controllers/stock_controller.dart';
import '/app/models/acc.dart';
import '/app/models/agence.dart';
import '/app/models/appro.dart';
import '/app/models/article.dart';
import '/app/models/phone.dart';
import '/app/models/portable.dart';
import '/app/models/stock_m.dart';
import '/app/utils/formats/date.dart';

class ApproController extends GetxController {
  static ApproController get instance => Get.find();
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child("procurements");
  final DatabaseReference global =
      FirebaseDatabase.instance.ref().child("procurements").child("global");
  final DatabaseReference dateAgenceOp =
      FirebaseDatabase.instance.ref().child("procurements").child("date_op");

  var listPhone = <Phone>[].obs;
  var listAcc = <Acc>[].obs;
  var nbrPhone = 0.obs;
  var nbrAcc = 0.obs;
  var cirBar = false.obs;

  var listArticle = <Article>[].obs;
  var listPortable = <Portable>[].obs;

  cleanList() {
    listAcc([]);
    listPhone([]);
    listArticle([]);
    listPortable([]);
    nbrAcc(0);
    nbrPhone(0);
    cirBar(false);
  }

  addPortableNoUsed(Portable portable) async {
    if (listPortable.any((e) => e.id == portable.id)) {
      return;
    } else {
      listPortable.add(portable);
    }
  }

  addArticleNoUsed(Article article) async {
    if (listArticle.any((e) => e.id == article.id)) {
      return;
    } else {
      listArticle.add(article);
    }
  }

  getTotal() async {
    nbrAcc(0);
    nbrPhone(0);
    for (var e in listPhone) {
      nbrPhone.value += e.qte;
    }
    for (var e in listAcc) {
      nbrAcc.value += e.qte;
    }
  }

  getPhoneQte(int index, int qt) async {
    listPhone[index].qte = qt;
    await getTotal();
  }

  getAccQte(int index, int qt) async {
    listAcc[index].qte = qt;
    await getTotal();
  }

  addPhone(Phone phone) {
    listPhone.add(phone);
    getTotal();
  }

  addAcc(Acc acc) {
    listAcc.add((acc));
    getTotal();
  }

  deletePhone(int i) async {
    listPortable.removeWhere((e) => e.id == listPhone[i].id);
    listPhone.removeAt(i);
    await getTotal();
  }

  deleteAcc(int i) async {
    listArticle.removeWhere((e) => e.id == listAcc[i].id);
    listAcc.removeAt(i);
    await getTotal();
  }

  Future<void> addApp(Agence agence) async {
    cirBar(true);
    StockController stockController = StockController.instance;
    PortableController portableController = PortableController.instance;
    ArticleController articleController = ArticleController.instance;
    DateTime _toDay = DateTime.now().onlyDate();
    String _dayKey = _toDay.millisecondsSinceEpoch.toString();
    StockM stockM = StockM(
        name: agence.name, nbrPhone: nbrPhone.value, nbrAcc: nbrAcc.value);
    StockM stockMGlobal =
        StockM(name: null, nbrPhone: nbrPhone.value, nbrAcc: nbrAcc.value);
    Appro appro = Appro(
        id: _dayKey,
        name: agence.name,
        nbrPhone: nbrPhone.value,
        nbrAcc: nbrAcc.value);

    Appro approGlobal = Appro(
        id: _dayKey,
        name: null,
        nbrPhone: nbrPhone.value,
        nbrAcc: nbrAcc.value);

    await stockController.addToStock(
        listPhone, listAcc, stockM, stockMGlobal, agence);

    await reference.runTransaction((value) {
      dateAgenceOp.child(agence.id).update({_dayKey: _dayKey});
      dateAgenceOp.child("global").update({_dayKey: _dayKey});
      for (var e in listPhone) {
        reference
            .child(_dayKey)
            .child(agence.id)
            .child("phones")
            .child(e.id)
            .update(e.toJson());
        global.child(_dayKey).child("phones").child(e.id).update(e.toJson());
      }
      for (var e in listAcc) {
        reference
            .child(_dayKey)
            .child(agence.id)
            .child("accessoires")
            .child(e.id)
            .update(e.toJson());
        global
            .child(_dayKey)
            .child("accessoires")
            .child(e.id)
            .update(e.toJson());
      }
      reference.child(_dayKey).child(agence.id).update(appro.toJson());
      global.child(_dayKey).update(approGlobal.toJson());

      return Transaction.abort();
    }, applyLocally: false);

    if (listPortable.isNotEmpty) {
      await portableController.setPortableUsed(listPortable);
    }

    if (listArticle.isNotEmpty) {
      await articleController.setArticleUsed(listArticle);
    }

    cleanList();
    cirBar(false);
  }

  Query getGlobalAppro() => global;

  Query getGlobalDateAppro() => dateAgenceOp.child("global");
  Query getAgenceDateAppro(String agenceId) => dateAgenceOp.child(agenceId);

  Query getAgenceAppro(String id) => reference.child(id);
  Query getAgenceApproEmployee(String id, String agenceId) =>
      reference.child(id).orderByKey().equalTo(agenceId);

  Query getPhoneGlobalAppro(String date) => global.child(date).child("phones");
  Query getAccGlobalAppro(String date) =>
      global.child(date).child("accessoires");

  Query getPhoneAgenceAppro(String date, String agenceId) =>
      reference.child(date).child(agenceId).child("phones");
  Query getAccAgenceAppro(String date, String agenceId) =>
      reference.child(date).child(agenceId).child("accessoires");
}
