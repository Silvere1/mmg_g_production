import 'dart:convert';

class UpdateVente {
  String userName;
  String raison;
  DateTime at;
  UpdateVente({
    required this.userName,
    required this.raison,
    required this.at,
  });

  factory UpdateVente.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return UpdateVente(
        userName: json["userName"],
        raison: json["raison"],
        at: DateTime.parse(json["at"]));
  }

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "raison": raison,
        "at": at.toIso8601String(),
      };
}
