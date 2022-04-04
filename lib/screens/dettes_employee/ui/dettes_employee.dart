import 'package:flutter/material.dart';

import '/app/controllers/client_controller.dart';
import '/app/controllers/user_controller.dart';
import '/screens/dettes_employee/widgets/item_client_has_dettes_employee.dart';
import '../../../app/models/client.dart';

class DettesEmployee extends StatefulWidget {
  const DettesEmployee({Key? key}) : super(key: key);

  @override
  State<DettesEmployee> createState() => _DettesEmployeeState();
}

class _DettesEmployeeState extends State<DettesEmployee> {
  ClientsController clientsController = ClientsController.instance;
  UserController userController = UserController.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Client>>(
        future: clientsController
            .getClientsHasDettesAgence(userController.user!.agenceId!),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var _clients = snapshot.data!;
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: _clients.length,
                itemBuilder: (_, i) =>
                    ItemClientHasDettesEmployee(client: _clients[i]));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
