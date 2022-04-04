import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../app/controllers/client_controller.dart';
import '../../../app/models/client.dart';
import '../../../res/assets_files.dart';
import '../widgets/item_client.dart';
import '../widgets/item_client_search.dart';
import 'edit_client.dart';

class FavorClient extends StatefulWidget {
  const FavorClient({Key? key}) : super(key: key);

  @override
  State<FavorClient> createState() => _FavorClientState();
}

class _FavorClientState extends State<FavorClient> {
  ClientsController clientsController = ClientsController.instance;
  final _editingController = TextEditingController();
  bool openSearch = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Align(
            alignment: Alignment.centerRight,
            widthFactor: double.infinity,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: openSearch ? MediaQuery.of(context).size.width - 20 : 48,
              alignment: Alignment.centerRight,
              child: openSearch
                  ? TypeAheadField<Client>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _editingController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Rechercher un client",
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
                        return await clientsController.getClientsFilter(
                            pattern.trim(), true);
                      },
                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      getImmediateSuggestions: true,
                      minCharsForSuggestions: 1,
                      itemBuilder: (context, suggestion) {
                        return ItemClientSearch(client: suggestion);
                      },
                      onSuggestionSelected: (suggestion) {
                        FocusScopeNode().unfocus();
                        setState(() {
                          openSearch = !openSearch;
                          _editingController.clear();
                        });
                        Get.to(() => EditClient(client: suggestion));
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
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              FirebaseAnimatedList(
                query: clientsController.queryClientsFavor(),
                reverse: true,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                defaultChild: SizedBox(
                  height: Get.height * .9,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                duration: const Duration(seconds: 1),
                itemBuilder: (_, snapshot, anim, i) {
                  final client = Client.fromJson(snapshot.value!);
                  return ItemClient(client: client, anim: anim);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
