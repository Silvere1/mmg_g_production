import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../app/controllers/vente_controller.dart';
import '../../../app/models/vente.dart';
import '../../../res/assets_files.dart';
import '../../ventes_employee/widgets/item_vente_employee_searche.dart';
import '../ui/detail_vente.dart';
import 'item_vente.dart';

class VenteDay extends StatefulWidget {
  const VenteDay({Key? key, required this.day}) : super(key: key);
  final String day;

  @override
  State<VenteDay> createState() => _VenteDayState();
}

class _VenteDayState extends State<VenteDay> {
  VenteController venteController = VenteController.instance;
  bool openSearch = false;
  final _editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.black12,
        child: ExpansionTile(
          title: const Text("Vente(s)"),
          onExpansionChanged: (value) {
            setState(() {
              openSearch = false;
              _editingController.clear();
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              child: Align(
                alignment: Alignment.centerRight,
                widthFactor: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  width:
                      openSearch ? MediaQuery.of(context).size.width - 20 : 48,
                  alignment: Alignment.centerRight,
                  child: openSearch
                      ? TypeAheadField<Vente>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _editingController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: "Entrer le nom du Client",
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    openSearch = !openSearch;
                                    _editingController.clear();
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
                            return await venteController.getVentesGlobalsSearch(
                                widget.day, pattern.trim());
                          },
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          getImmediateSuggestions: true,
                          minCharsForSuggestions: 1,
                          itemBuilder: (context, suggestion) {
                            return ItemVenteEmployeeSearch(vente: suggestion);
                          },
                          onSuggestionSelected: (suggestion) async {
                            FocusScopeNode().unfocus();
                            setState(() {
                              openSearch = !openSearch;
                              _editingController.clear();
                            });
                            Get.to(() => DetailVente(vente: suggestion));
                          },
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  openSearch = !openSearch;
                                });
                              },
                              child: Container(
                                width: !openSearch ? double.infinity : 0,
                                height: 48,
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
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
              query: venteController.queryAllVentes(widget.day),
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
                if (kDebugMode) {
                  print(snapshot.value);
                }
                final vente = Vente.fromJson(snapshot.value!);
                return ItemVente(anim: anim, vente: vente);
              },
            ),
          ],
        ),
      ),
    );
  }
}
