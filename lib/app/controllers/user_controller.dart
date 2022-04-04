import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '/app/services/app_services/app_service.dart';

import '/app/controllers/agence_controller.dart';
import '/app/controllers/menu_controlller.dart';
import '/app/models/agence.dart';
import '/app/models/title.dart';
import '/app/models/user.dart';
import '/app/services/preferences/preferences_manager.dart';
import '/screens/global/widgets/close_session_dialog.dart';
import '/screens/global/widgets/paasword_incorrect.dart';
import '/screens/login/ui/login.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  final DatabaseReference _reference =
      FirebaseDatabase.instance.ref().child("users");
  User? user;
  var tel = 0.obs;
  var passW = "".obs;
  var newPassW = "".obs;
  var eye = true.obs;
  var circ = false.obs;
  var userName = "".obs;
  var userTel = "".obs;
  var userAgenceName = "".obs;

  ///Editing
  var name = "".obs;

  cleanVar() {
    tel(0);
    passW("");
    newPassW("");
    eye(true);
    name("");
  }

  @override
  void onReady() {
    super.onReady();
    checkUserOn();
  }

  Future<void> editingTel(int val) async {
    tel(val);
  }

  Future<void> checkUserOn() async {
    if (await PrefManager.instance.exist("user")) {
      user =
          User.fromJson(jsonDecode(await PrefManager.instance.getStr("user")));
      if (kDebugMode) {
        print("Jai trouvé un user");
      }
    }
    if (user != null) {
      _reference.child(user!.idUser!).get().then((value) {
        if (!value.exists) {
          logOut();
          closeSessionDialog().then((value) => Get.offAll(() => const Login()));
        }
      });
      _reference.child(user!.idUser!).onValue.listen((event) {
        user = User.fromJson(event.snapshot.value!);
        if (user!.admin != null) {
          loadInfon();
        } else {
          logOut();
          closeSessionDialog().then((value) => Get.offAll(() => const Login()));
        }
      });
    }

    _reference.onChildRemoved.listen((event) {
      if (kDebugMode) {
        print(event.snapshot.value.toString());
      }
      User _user = User.fromJson(event.snapshot.value!);
      if (_user.idUser == user!.idUser) {
        logOut();
        closeSessionDialog().then((value) => Get.offAll(() => const Login()));
      }
      loadInfon();
    });
  }

  loadInfon() {
    userName.value = user!.fullName;
    userTel.value = user!.tel.toString();
  }

  logOut() {
    PrefManager.instance.remove("user");
    PrefManager.instance.remove("intro");
  }

  saveLogin(bool admin) async {
    MenuController.instance
        .onChangeMenu(admin ? adminTitles[0] : employeeTitles[0], 0, admin);
    await PrefManager.instance.setStr("user", jsonEncode(user!.toJson()));
    await PrefManager.instance.setStr("intro", "intro");
  }

  Future<User?> login() async {
    AppServices appServices = AppServices.instance;
    user = null;
    var users = await _reference.get();
    var listUsers = users.children.map((e) => User.fromJson(e.value!));
    for (var e in listUsers) {
      if (kDebugMode) {
        print(e.toJson());
      }
      if (e.admin != null && e.tel == tel.value && e.password == passW.value) {
        user = e;
        await saveLogin(e.admin!);
        await appServices.init();
        cleanVar();
      }
    }
    return user;
  }

  Future<int> changePassWord() async {
    if (passW.value != user!.password) {
      return 1;
    } else {
      var _user = user!;
      int x = 0;
      _user.password = newPassW.value;
      await _reference.child(user!.idUser!).update(_user.toJson());
      await _reference.child(user!.idUser!).get().then((value) {
        var result = User.fromJson(value.value!);
        if (result.password == newPassW.value) {
          user = result;
          saveLogin(user!.admin!);
          x = 2;
          cleanVar();
        } else {
          x = 3;
        }
      });
      return x;
    }
  }

  Future<void> changeEmployeePassword(User userx) async {
    await _reference.child(userx.idUser!).update({"password": passW.value});
    passW("");
  }

  Future<void> setAgenceForUser(String agenceId, User userX) async {
    setCirc(true);
    AgenceController agenceController = AgenceController.instance;
    var _agenceRef = agenceController.reference.child(agenceId);
    var result = await _agenceRef.get();
    Agence agenceY = Agence.fromJson(result.value!);

    if (userX.agenceId != null) {
      var _agenceUser = agenceController.reference.child(userX.agenceId!);

      if (userX.agenceId != agenceId) {
        var magasinX = await _agenceUser.get();
        Agence agenceX = Agence.fromJson(magasinX.value!);
        var i = 0.obs;
        for (var a in agenceX.employers!) {
          if (a.idUser == userX.idUser) {
            i(agenceX.employers!.indexOf(a));
          }
        }
        await _agenceUser.child("employers").child("${i.value}").remove();
        agenceX.employers!
            .removeWhere((element) => element.idUser == userX.idUser);
        await _agenceUser.update(agenceX.toJson());

        if (agenceY.employers == null) {
          agenceY.employers = [userX];
          await _agenceRef.set(agenceY.toJson());
        } else {
          agenceY.employers!.add(userX);
          await _agenceRef.update(agenceY.toJson());
        }
        await _reference
            .child(userX.idUser!)
            .update({"agenceId": agenceId, "agenceName": agenceY.name});

        ///
      }
    } else {
      /// add auto
      if (agenceY.employers == null) {
        agenceY.employers = [userX];
        await _agenceRef.update(agenceY.toJson());
      } else {
        agenceY.employers!.add(userX);
        await _agenceRef.update(agenceY.toJson());
      }
      await _reference
          .child(userX.idUser!)
          .update({"agenceId": agenceId, "agenceName": agenceY.name});
    }
    setCirc(false);
  }

  Future<bool> creatUser() async {
    setCirc(true);
    User _user = User(
        idUser: "null",
        fullName: name.value,
        password: passW.value,
        tel: tel.value,
        admin: false,
        agenceId: null,
        agenceName: null,
        createAt: DateTime.now(),
        updateAt: null);

    var users = await _reference.get();
    var listUsers = users.children.map((e) => User.fromJson(e.value!));

    if (listUsers.any((e) =>
        e.fullName.toLowerCase() == _user.fullName.toLowerCase() ||
        e.tel == _user.tel)) {
      setCirc(false);
      return false;
    } else {
      String? id = _reference.push().key;
      _user.idUser = id;
      _reference.child(id!).set(_user.toJson());
      setCirc(false);
      cleanVar();
      return true;
    }
  }

  setCirc(bool v) {
    circ(v);
  }

  Future<void> bannedEmployee(User userX) async {
    if (passW.value != user!.password) {
      passwordIncorrectDialog();
    } else {
      AgenceController agenceController = AgenceController.instance;
      var _agenceRef = agenceController.reference.child(userX.agenceId!);
      var result = await _agenceRef.get();
      var _agence = Agence.fromJson(result.value!);
      var i = 0.obs;
      for (var e in _agence.employers!) {
        if (e.idUser! == userX.idUser) {
          i(_agence.employers!.indexOf(e));
        }
      }
      await _agenceRef.child("employers").child("${i.value}").remove();
      await _reference.child(userX.idUser!).child("admin").remove();
    }
  }

  deleteEmployee(User userX) async {
    if (passW.value != user!.password) {
      passwordIncorrectDialog();
    } else {
      _reference.child(userX.idUser!).remove();
    }
  }

  Future<bool> checkPassword() async {
    if (passW.value != user!.password) {
      passwordIncorrectDialog();
      return false;
    } else {
      return true;
    }
  }

  Future<void> editingPassW(String val) async {
    if (val.trim().length >= 4) {
      passW(val);
    } else {
      passW("");
    }
  }

  Future<void> editingName(String val) async {
    if (val.length >= 3) {
      name(val);
    } else {
      name("");
    }
  }

  Future<void> editingNewPassW(String val) async {
    newPassW(val);
  }

  Query getEmployee() => _reference.orderByChild("admin").equalTo(false);
}
