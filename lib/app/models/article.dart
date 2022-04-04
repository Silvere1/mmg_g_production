import 'dart:convert';

class Article {
  String id;
  String name;
  bool used;
  int? nbr;
  int? pu;
  int? prix;

  Article(
      {required this.id,
      required this.name,
      required this.used,
      required this.nbr,
      required this.pu,
      required this.prix});

  factory Article.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return Article(
        id: json["id"],
        name: json["name"],
        used: json["used"],
        nbr: json["nbr"],
        pu: json["pu"],
        prix: json["prix"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "used": used,
        "nbr": nbr,
        "pu": pu,
        "prix": prix,
      };
}
