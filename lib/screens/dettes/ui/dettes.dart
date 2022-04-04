import 'package:flutter/material.dart';

import '/app/controllers/client_controller.dart';
import '/app/models/client.dart';
import '/screens/dettes/widgets/item_client_has_dettes.dart';

class Dettes extends StatefulWidget {
  const Dettes({Key? key}) : super(key: key);

  @override
  State<Dettes> createState() => _DettesState();
}

class _DettesState extends State<Dettes> {
  ClientsController clientsController = ClientsController.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Client>>(
        future: clientsController.getClientsHasDettes(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var _clients = snapshot.data!;
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _clients.length,
                itemBuilder: (_, i) =>
                    ItemClientHasDettes(client: _clients[i]));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
