import 'dart:convert';

class User {
  String? idUser;
  String fullName;
  String password;
  int tel;
  bool? admin;
  String? agenceId;
  String? agenceName;
  DateTime createAt;
  DateTime? updateAt;

  User({
    required this.idUser,
    required this.fullName,
    required this.password,
    required this.tel,
    required this.admin,
    required this.agenceId,
    required this.agenceName,
    required this.createAt,
    required this.updateAt,
  });

  factory User.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return User(
      idUser: json["idUser"],
      fullName: json["fullName"],
      password: json["password"],
      tel: json["tel"],
      admin: json["admin"],
      agenceId: json["agenceId"],
      agenceName: json["agenceName"],
      createAt: DateTime.parse(json["createAt"]),
      updateAt:
          json["updateAt"] == null ? null : DateTime.parse(json["updateAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "fullName": fullName,
        "password": password,
        "tel": tel,
        "admin": admin,
        "agenceId": agenceId,
        "agenceName": agenceName,
        "createAt": createAt.toIso8601String(),
        "updateAt": updateAt == null ? null : updateAt!.toIso8601String(),
      };
}
