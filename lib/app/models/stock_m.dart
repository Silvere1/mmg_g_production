import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class StockM {
  String? name;
  int nbrPhone;
  int nbrAcc;
  StockM({required this.nbrPhone, required this.nbrAcc, required this.name});

  factory StockM.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return StockM(
        nbrPhone: json["nbrPhone"], nbrAcc: json["nbrAcc"], name: json["name"]);
  }

  Map<String, dynamic> toJson() => {
        "nbrPhone": ServerValue.increment(nbrPhone),
        "nbrAcc": ServerValue.increment(nbrAcc),
        "name": name
      };
}
