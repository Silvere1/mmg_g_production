import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class Inventaire {
  String id;
  int nbrPtSortis;
  int nbrPtVendus;
  int nbrPtNoBack;
  int nbrPtBack;
  int nbrAss;
  int chiffre;
  int dette;
  int oldDette;
  int oldNegation;

  Inventaire({
    required this.id,
    required this.nbrPtSortis,
    required this.nbrPtVendus,
    required this.nbrPtNoBack,
    required this.nbrPtBack,
    required this.nbrAss,
    required this.chiffre,
    required this.dette,
    required this.oldDette,
    required this.oldNegation,
  });

  factory Inventaire.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return Inventaire(
      id: json["id"],
      nbrPtSortis: json["nbrPtSortis"],
      nbrPtVendus: json["nbrPtVendus"],
      nbrPtNoBack: json["nbrPtNoBack"],
      nbrPtBack: json["nbrPtBack"],
      nbrAss: json["nbrAss"],
      chiffre: json["chiffre"],
      dette: json["dette"],
      oldDette: json["oldDette"],
      oldNegation: json["oldNegation"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nbrPtSortis": ServerValue.increment(nbrPtSortis),
        "nbrPtVendus": ServerValue.increment(nbrPtVendus),
        "nbrPtNoBack": ServerValue.increment(nbrPtNoBack),
        "nbrPtBack": ServerValue.increment(nbrPtBack),
        "nbrAss": ServerValue.increment(nbrAss),
        "chiffre": ServerValue.increment(chiffre),
        "dette": ServerValue.increment(dette),
        "oldDette": ServerValue.increment(oldDette),
        "oldNegation": ServerValue.increment(oldNegation),
      };
}
