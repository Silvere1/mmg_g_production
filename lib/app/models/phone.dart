import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class Phone {
  String id;
  String name;
  int qte;

  Phone({required this.id, required this.name, required this.qte});

  factory Phone.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return Phone(id: json["id"], name: json["name"], qte: json["qte"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "qte": ServerValue.increment(qte),
      };
}
