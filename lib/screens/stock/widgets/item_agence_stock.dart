import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '/app/controllers/stock_controller.dart';
import '/app/models/stock_m.dart';
import '../../../app/config/dimensions.dart';
import '../../../app/models/acc.dart';
import '../../../app/models/phone.dart';
import '../../../res/assets_files.dart';
import 'item_acc_stock_agence.dart';
import 'item_acc_stock_search.dart';
import 'item_phone_stock_agence.dart';
import 'item_phone_stock_search.dart';

class ItemAgenceStock extends StatefulWidget {
  const ItemAgenceStock(
      {Key? key,
      required this.stockM,
      required this.anim,
      required this.theKey})
      : super(key: key);
  final StockM stockM;
  final Animation<double> anim;
  final String theKey;

  @override
  State<ItemAgenceStock> createState() => _ItemAgenceStockState();
}

class _ItemAgenceStockState extends State<ItemAgenceStock> {
  final stockController = StockController.instance;
  final _editingControllerPhone = TextEditingController();
  bool openSearchPhone = false;
  final _editingControllerAcc = TextEditingController();
  bool openSearchAcc = false;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.anim,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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
                      widget.stockM.name!,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  if (widget.stockM.nbrPhone > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Dimensions.y4,
                        Text("Nbr Téléphones : ${widget.stockM.nbrPhone}"),
                      ],
                    ),
                  if (widget.stockM.nbrAcc > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Dimensions.y4,
                        Text("Nbr Accessoires : ${widget.stockM.nbrAcc}"),
                      ],
                    ),
                  if (widget.stockM.nbrPhone > 0)
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text("Téléphone(s)"),
                      onExpansionChanged: (value) {
                        setState(() {
                          openSearchPhone = false;
                          _editingControllerPhone.clear();
                        });
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
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
                                          fillColor: Colors.black12,
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              setState(() {
                                                openSearchPhone =
                                                    !openSearchPhone;
                                                _editingControllerPhone.clear();
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                            .getPhoneAgenceSearchAdmin(
                                                pattern.trim(), widget.theKey);
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
                                        color: Colors.black12,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              openSearchPhone =
                                                  !openSearchPhone;
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
                            query: stockController
                                .getAgencePhoneStock(widget.theKey),
                            reverse: true,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            defaultChild: const Center(
                                child: CircularProgressIndicator()),
                            duration: const Duration(seconds: 1),
                            itemBuilder: (_, snapshot, anim, i) {
                              if (kDebugMode) {
                                print(snapshot.value);
                                print(snapshot.key);
                              }
                              final phone = Phone.fromJson(snapshot.value!);

                              return ItemPhoneStockAgence(
                                  anim: anim, phone: phone);
                            })
                      ],
                    ),
                  if (widget.stockM.nbrAcc > 0)
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text("Accessoire(s)"),
                      onExpansionChanged: (value) {
                        setState(() {
                          openSearchAcc = false;
                          _editingControllerAcc.clear();
                        });
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
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
                                          fillColor: Colors.black12,
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              setState(() {
                                                openSearchAcc = !openSearchAcc;
                                                _editingControllerAcc.clear();
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                            .getAccAgenceAdminSearch(
                                                pattern.trim(), widget.theKey);
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
                                        color: Colors.black12,
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
                            query: stockController
                                .getAgenceAccStock(widget.theKey),
                            reverse: true,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            defaultChild: const Center(
                                child: CircularProgressIndicator()),
                            duration: const Duration(seconds: 1),
                            itemBuilder: (_, snapshot, anim, i) {
                              if (kDebugMode) {
                                print(snapshot.value);
                                print(snapshot.key);
                              }
                              final acc = Acc.fromJson(snapshot.value!);

                              return ItemAccStockAgence(anim: anim, acc: acc);
                            })
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
