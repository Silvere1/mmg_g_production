import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '/app/controllers/portable_controller.dart';
import '/app/models/portable.dart';
import '/screens/components/entry.dart';
import '/screens/global/widgets/name_existe.dart';

class AddPortable extends StatefulWidget {
  const AddPortable({Key? key}) : super(key: key);

  @override
  _AddPortableState createState() => _AddPortableState();
}

class _AddPortableState extends State<AddPortable> {
  PortableController portableController = PortableController.instance;
  final TextEditingController _editingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  void initState() {
    super.initState();
    portableController.cleanVar();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter un Portable"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Entry(
                text: Text(
                  "Désignation du portable (Nom & Modèle)",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TypeAheadField<Portable>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _editingController,
                    keyboardType: TextInputType.name,
                    //inputFormatters: [nameAndNumMaskFormatter],
                  ),
                  noItemsFoundBuilder: (_) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("N'existe pas encore."),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await portableController.getPortables(pattern);
                  },
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  getImmediateSuggestions: true,
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.name!),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _editingController.text = suggestion.name!;
                    portableController.namePortableEditing(suggestion.name!);
                    Get.snackbar("Attention", "Ce produit existe déjà !",
                        colorText: Colors.white);
                  },
                ),
              ),
              const SizedBox(
                height: 146,
              ),
              Obx(() => ElevatedButton(
                    onPressed: portableController.name.value != ""
                        ? () {
                            portableController.createPortable().then((value) {
                              if (value == true) {
                                Get.back();
                              } else {
                                nameExiste();
                              }
                            });
                          }
                        : null,
                    child: const Text("Enregistrer"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
