import 'dart:convert';

import '/app/models/user.dart';

class Agence {
  String id;
  String name;
  List<User>? employers;

  Agence({
    required this.id,
    required this.name,
    required this.employers,
  });

  factory Agence.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return Agence(
      id: json["id"],
      name: json["name"],
      employers: json["employers"] == null
          ? null
          : List<User>.from(json["employers"].map((x) => User.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "employers": employers == null
            ? null
            : List<dynamic>.from(employers!.map((e) => e.toJson())),
      };
}
