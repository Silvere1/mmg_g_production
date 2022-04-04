import 'dart:convert';

class Client {
  String id;
  String? fullName;
  String? tel;
  bool canDette;
  double solde;

  Client({
    required this.id,
    required this.fullName,
    required this.tel,
    required this.canDette,
    required this.solde,
  });

  factory Client.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return Client(
      id: json["id"],
      fullName: json["fullName"],
      tel: json["tel"],
      canDette: json["canDette"],
      solde: double.parse(json["solde"].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "tel": tel,
        "canDette": canDette,
        "solde": solde,
      };
}
