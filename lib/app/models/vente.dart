import 'dart:convert';

import '/app/models/article.dart';
import '/app/models/portable.dart';
import '/app/models/update_vente.dart';
import '/app/models/user.dart';

class Vente {
  String id;
  List<Portable>? portables;
  List<Article>? articles;
  User user;
  String? clientId;
  String nameClient;
  String? numClient;
  int netPayer;
  int payer;
  int nbrPt;
  int nbrAss;
  bool hasDette;
  bool? cancel;
  String agenceId;
  List<UpdateVente>? updates;
  DateTime craeteAt;
  DateTime theDay;

  Vente({
    required this.id,
    required this.portables,
    required this.articles,
    required this.user,
    required this.clientId,
    required this.nameClient,
    required this.numClient,
    required this.netPayer,
    required this.payer,
    required this.nbrPt,
    required this.nbrAss,
    required this.hasDette,
    required this.cancel,
    required this.agenceId,
    required this.updates,
    required this.craeteAt,
    required this.theDay,
  });

  factory Vente.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return Vente(
      id: json["id"],
      portables: json["portables"] == null
          ? null
          : List<Portable>.from(
              json["portables"].map((x) => Portable.fromJson(x))),
      articles: json["articles"] == null
          ? null
          : List<Article>.from(
              json["articles"].map((x) => Article.fromJson(x))),
      user: User.fromJson(json["user"]),
      clientId: json["clientId"],
      nameClient: json["nameClient"],
      numClient: json["numClient"],
      netPayer: json["netPayer"],
      payer: json["payer"],
      nbrPt: json["nbrPt"],
      nbrAss: json["nbrAss"],
      hasDette: json["hasDette"],
      cancel: json["cancel"],
      agenceId: json["agenceId"],
      updates: json["updates"] == null
          ? null
          : List<UpdateVente>.from(
              json["updates"].map((x) => UpdateVente.fromJson(x))),
      craeteAt: DateTime.parse(json["craeteAt"]),
      theDay: DateTime.fromMillisecondsSinceEpoch(int.parse(json["theDay"])),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "portables": portables == null
            ? null
            : List<dynamic>.from(portables!.map((e) => e.toJson())),
        "articles": articles == null
            ? null
            : List<dynamic>.from(articles!.map((e) => e.toJson())),
        "user": user.toJson(),
        "clientId": clientId,
        "nameClient": nameClient,
        "numClient": numClient,
        "netPayer": netPayer,
        "payer": payer,
        "nbrPt": nbrPt,
        "nbrAss": nbrAss,
        "hasDette": hasDette,
        "cancel": cancel,
        "agenceId": agenceId,
        "updates": updates == null
            ? null
            : List<dynamic>.from(updates!.map((e) => e.toJson())),
        "craeteAt": craeteAt.toIso8601String(),
        "theDay": theDay.millisecondsSinceEpoch.toString(),
      };
}
