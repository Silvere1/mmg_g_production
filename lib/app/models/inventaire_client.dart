import 'dart:convert';

class InventaireClient {
  DateTime theDay;
  InventaireClient({required this.theDay});

  factory InventaireClient.fromJson(Object object) {
    final json = jsonDecode(jsonEncode(object));
    return InventaireClient(
        theDay: DateTime.fromMillisecondsSinceEpoch(int.parse(json)));
  }
}
