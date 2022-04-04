import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class Appro {
  String? id;
  String? name;
  int nbrPhone;
  int nbrAcc;
  Appro(
      {required this.id,
      required this.name,
      required this.nbrPhone,
      required this.nbrAcc});

  factory Appro.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));

    return Appro(
        id: json["id"],
        name: json["name"],
        nbrPhone: json["nbrPhone"],
        nbrAcc: json["nbrAcc"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nbrPhone": ServerValue.increment(nbrPhone),
        "nbrAcc": ServerValue.increment(nbrAcc),
      };
}
