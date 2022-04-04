import 'dart:convert';

class Portable {
  String id;
  String? name;
  bool used;
  int? imei;
  String? color;
  bool? backed;
  bool payer;
  int? prix;
  int? montantRemis;

  Portable({
    required this.id,
    required this.name,
    required this.used,
    required this.imei,
    required this.color,
    required this.backed,
    required this.payer,
    required this.prix,
    required this.montantRemis,
  });

  factory Portable.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return Portable(
      id: json["id"],
      name: json["name"],
      used: json["used"],
      imei: json["imei"],
      color: json["color"],
      backed: json["backed"],
      payer: json["payer"],
      prix: json["prix"],
      montantRemis: json["montantRemis"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "used": used,
        "imei": imei,
        "color": color,
        "backed": backed,
        "payer": payer,
        "prix": prix,
        "montantRemis": montantRemis,
      };
}
