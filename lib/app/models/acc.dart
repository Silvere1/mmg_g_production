import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class Acc {
  String id;
  String name;
  int qte;

  Acc({required this.id, required this.name, required this.qte});

  factory Acc.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));

    return Acc(id: json["id"], name: json["name"], qte: json["qte"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "qte": ServerValue.increment(qte),
      };
}
