import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/menu_controlller.dart';
import '/app/controllers/user_controller.dart';
import '/app/models/title.dart';
import '/app/models/user.dart';
import '/res/theme/ui/ui_overlay_style.dart';
import '/screens/clients/ui/clients.dart';
import '/screens/dashboard/ui/admin_dash.dart';
import '/screens/dashboard/ui/employee_dash.dart';
import '/screens/dettes/ui/dettes.dart';
import '/screens/dettes_employee/ui/dettes_employee.dart';
import '/screens/employees/ui/employees.dart';
import '/screens/home/components/admin_drawer.dart';
import '/screens/home/components/employee_drawer.dart';
import '/screens/infos/ui/info.dart';
import '/screens/inventaire_magasin/ui/inventaire_magasin.dart';
import '/screens/login/ui/login.dart';
import '/screens/magasins/ui/magasins.dart';
import '/screens/procurements/ui/procuremments.dart';
import '/screens/procurements_employee/ui/procurements_employee.dart';
import '/screens/produits/ui/produits.dart';
import '/screens/stock/ui/stock.dart';
import '/screens/stock_employee/ui/stock_employee.dart';
import '/screens/ventes/ui/ventes.dart';
import '/screens/ventes_employee/ui/ventes_employee.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<ScaffoldState> key = GlobalKey();
  MenuController menuController = MenuController.instance;
  UserController userController = UserController.instance;

  final List<Widget> _adminWidgets = const [
    AdminDash(),
    Magasins(),
    Ventes(),
    Dettes(),
    Produits(),
    Procurements(),
    Stock(),
    Employees(),
    Clients(),
    Info(),
  ];
  final List<Widget> _employeeWidgets = const [
    EmployeeDash(),
    VentesEmployee(),
    DettesEmployee(),
    InventaireMagasin(),
    ProcurementEmployee(),
    StockEmployee(),
    Info(),
  ];

  Future<bool> _onWillPop() async {
    if (key.currentState!.isDrawerOpen) {
      Get.back();
      return false;
    } else {
      if (menuController.indexPage.value != 0) {
        if (widget.user.admin == true) {
          await menuController.onChangeMenu(adminTitles[0], 0, true);
        } else {
          await menuController.onChangeMenu(employeeTitles[0], 0, false);
        }
        return false;
      } else {
        return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => Dialog(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Attention",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Fermer l'application ?"),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: OutlinedButton(
                                  onPressed: () => Get.back(result: false),
                                  child: const Text("Non"))),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () => Get.back(result: true),
                                  child: const Text("Oui"))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ) ??
            false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: AnnotatedRegion(
            child: SafeArea(
              child: widget.user.admin == false && widget.user.agenceId == null
                  ? Scaffold(
                      appBar: AppBar(
                        title: const Text("Pas d'accès"),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Vous ne pouvez pas accéder au contenu pour l'instant.\nVeuillez contacter votre suppérieur hiérachique.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                                width: 80,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Get.offAll(() => const Login());
                                    },
                                    child: const Text("Ok")))
                          ],
                        ),
                      ),
                    )
                  : Scaffold(
                      key: key,
                      drawer: widget.user.admin!
                          ? AdminDrawer(
                              userController: userController,
                              menuController: menuController,
                            )
                          : EmployeeDrawer(
                              userController: userController,
                              menuController: menuController,
                            ),
                      appBar: AppBar(
                        title: Obx(() => Text(menuController.barTitle.value)),
                      ),
                      body: Obx(() => widget.user.admin!
                          ? _adminWidgets[menuController.indexPage.value]
                          : _employeeWidgets[menuController.indexPage.value]),
                    ),
            ),
            value: MyOverlayStyle.forConnexion),
        onWillPop: _onWillPop);
  }
}
