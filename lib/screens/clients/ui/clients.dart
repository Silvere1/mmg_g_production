import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/client_controller.dart';
import '/screens/clients/ui/all_clients.dart';
import '/screens/clients/ui/create_client.dart';
import '/screens/clients/ui/favor_clients.dart';
import '/screens/clients/ui/ordinar_clients.dart';
import '../../../res/theme/colors/constants.dart';

class Clients extends StatefulWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  _ClientsState createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  ClientsController clientsController = ClientsController.instance;

  final _tab = const <Tab>[
    Tab(text: "Tous"),
    Tab(text: "Favoris"),
    Tab(text: "Ordinaires"),
  ];

  final _tabPages = const <Widget>[
    AllClients(),
    FavorClient(),
    OrdinarClients(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1.5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: Theme.of(context).primaryColor,
                  child: TabBar(
                    tabs: _tab,
                    physics: const NeverScrollableScrollPhysics(),
                    indicatorColor: backGround,
                    indicatorWeight: 6,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: _tabPages,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => const CreateClient());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
