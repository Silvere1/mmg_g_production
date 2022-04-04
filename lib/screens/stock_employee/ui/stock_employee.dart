import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/stock_controller.dart';
import '/app/controllers/user_controller.dart';
import '/app/models/acc.dart';
import '/app/models/phone.dart';
import '/app/models/stock_m.dart';
import '/screens/stock/widgets/item_acc_stock.dart';
import '/screens/stock/widgets/item_phone_stock.dart';
import '../../../res/assets_files.dart';
import '../../stock/widgets/item_acc_stock_search.dart';
import '../../stock/widgets/item_phone_stock_search.dart';

class StockEmployee extends StatefulWidget {
  const StockEmployee({Key? key}) : super(key: key);

  @override
  State<StockEmployee> createState() => _StockEmployeeState();
}

class _StockEmployeeState extends State<StockEmployee> {
  StockController stockController = StockController.instance;
  UserController userController = UserController.instance;
  final _editingControllerPhone = TextEditingController();
  bool openSearchPhone = false;
  final _editingControllerAcc = TextEditingController();
  bool openSearchAcc = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        FirebaseAnimatedList(
          query: stockController
              .getAgenceStockEmployee(userController.user!.agenceId!),
          reverse: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          defaultChild: const Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
          ),
          duration: const Duration(seconds: 1),
          itemBuilder: (_, snapshot, anim, i) {
            final stockM = StockM.fromJson(snapshot.value!);

            return Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Text(
                                stockM.name!,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            if (stockM.nbrPhone > 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Dimensions.y4,
                                  Text("Nbr Téléphones : ${stockM.nbrPhone}"),
                                ],
                              ),
                            if (stockM.nbrAcc > 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Dimensions.y4,
                                  Text("Nbr Accessoires : ${stockM.nbrAcc}"),
                                ],
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (stockM.nbrPhone > 0)
                  ExpansionTile(
                    title: const Text("Téléphone(s)"),
                    onExpansionChanged: (value) {
                      setState(() {
                        openSearchPhone = false;
                        _editingControllerPhone.clear();
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: double.infinity,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            width: openSearchPhone
                                ? MediaQuery.of(context).size.width - 20
                                : 48,
                            alignment: Alignment.centerRight,
                            child: openSearchPhone
                                ? TypeAheadField<Phone>(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: _editingControllerPhone,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        hintText: "Rechercher un Téléphone",
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              openSearchPhone =
                                                  !openSearchPhone;
                                              _editingControllerPhone.clear();
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset(
                                              MmgAssets.cancel,
                                              height: 26,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    noItemsFoundBuilder: (_) => const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("N'existe pas !"),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return await stockController
                                          .getPhoneSearch(pattern.trim());
                                    },
                                    suggestionsBoxDecoration:
                                        SuggestionsBoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    getImmediateSuggestions: true,
                                    minCharsForSuggestions: 1,
                                    itemBuilder: (context, suggestion) {
                                      return ItemPhoneStockSearch(
                                          phone: suggestion);
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      FocusScopeNode().unfocus();
                                      setState(() {
                                        openSearchPhone = !openSearchPhone;
                                        _editingControllerPhone.clear();
                                      });
                                    },
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            openSearchPhone = !openSearchPhone;
                                          });
                                        },
                                        child: Container(
                                          width: !openSearchPhone
                                              ? double.infinity
                                              : 0,
                                          height: 48,
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: SvgPicture.asset(
                                              MmgAssets.icSearch,
                                              height: 26,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      FirebaseAnimatedList(
                          query: stockController.getAgencePhoneStock(
                              userController.user!.agenceId!),
                          reverse: true,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          defaultChild:
                              const Center(child: CircularProgressIndicator()),
                          duration: const Duration(seconds: 1),
                          itemBuilder: (_, snapshot, anim, i) {
                            if (kDebugMode) {
                              print(snapshot.value);
                              print(snapshot.key);
                            }
                            final phone = Phone.fromJson(snapshot.value!);

                            return ItemPhoneStock(anim: anim, phone: phone);
                          })
                    ],
                  ),
                if (stockM.nbrAcc > 0)
                  ExpansionTile(
                    title: const Text("Accessoire(s)"),
                    onExpansionChanged: (value) {
                      setState(() {
                        openSearchAcc = false;
                        _editingControllerAcc.clear();
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: double.infinity,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            width: openSearchAcc
                                ? MediaQuery.of(context).size.width - 20
                                : 48,
                            alignment: Alignment.centerRight,
                            child: openSearchAcc
                                ? TypeAheadField<Acc>(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: _editingControllerAcc,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        hintText: "Rechercher un Accessoire",
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              openSearchAcc = !openSearchAcc;
                                              _editingControllerAcc.clear();
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset(
                                              MmgAssets.cancel,
                                              height: 26,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    noItemsFoundBuilder: (_) => const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("N'existe pas !"),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return await stockController
                                          .getAccSearch(pattern.trim());
                                    },
                                    suggestionsBoxDecoration:
                                        SuggestionsBoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    getImmediateSuggestions: true,
                                    minCharsForSuggestions: 1,
                                    itemBuilder: (context, suggestion) {
                                      return ItemAccStockSerach(
                                          acc: suggestion);
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      FocusScopeNode().unfocus();
                                      setState(() {
                                        openSearchAcc = !openSearchAcc;
                                        _editingControllerAcc.clear();
                                      });
                                    },
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            openSearchAcc = !openSearchAcc;
                                          });
                                        },
                                        child: Container(
                                          width: !openSearchAcc
                                              ? double.infinity
                                              : 0,
                                          height: 48,
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: SvgPicture.asset(
                                              MmgAssets.icSearch,
                                              height: 26,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      FirebaseAnimatedList(
                          query: stockController.getAgenceAccStock(
                              userController.user!.agenceId!),
                          reverse: true,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          defaultChild:
                              const Center(child: CircularProgressIndicator()),
                          duration: const Duration(seconds: 1),
                          itemBuilder: (_, snapshot, anim, i) {
                            if (kDebugMode) {
                              print(snapshot.value);
                              print(snapshot.key);
                            }
                            final acc = Acc.fromJson(snapshot.value!);

                            return ItemAccStock(anim: anim, acc: acc);
                          })
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
