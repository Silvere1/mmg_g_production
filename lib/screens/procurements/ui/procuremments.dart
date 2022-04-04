import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/appro_controller.dart';
import '/res/theme/colors/constants.dart';
import '/screens/procurements/ui/agence_procure_admin.dart';
import '/screens/procurements/ui/global_procure.dart';
import '/screens/procurements/ui/select_magasin_appro.dart';

class Procurements extends StatefulWidget {
  const Procurements({Key? key}) : super(key: key);

  @override
  State<Procurements> createState() => _ProcurementsState();
}

class _ProcurementsState extends State<Procurements> {
  ApproController approController = ApproController.instance;

  final _tab = const <Tab>[
    Tab(text: "Global"),
    Tab(text: "Par Magasin"),
  ];

  final _tabPages = const <Widget>[
    GlobalProcure(),
    AgenceProcureAdmin(),
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
            Get.to(() => const SelectMagasinAppro());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
