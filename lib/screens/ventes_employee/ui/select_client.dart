import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/client_controller.dart';
import '/app/controllers/network_controller.dart';
import '/app/controllers/vente_controller.dart';
import '/app/models/client.dart';
import '/app/utils/formats/mask_formater.dart';
import '/app/utils/formats/money.dart';
import '/res/assets_files.dart';
import '/screens/components/entry.dart';
import '/screens/components/no_internet.dart';
import '/screens/ventes_employee/components/confirm_vente_dialog.dart';
import '/screens/ventes_employee/widgets/item_no_pay_all_phone_edit.dart';

class SelectClient extends StatefulWidget {
  const SelectClient({Key? key}) : super(key: key);

  @override
  _SelectClientState createState() => _SelectClientState();
}

class _SelectClientState extends State<SelectClient> {
  final _editingController = TextEditingController();
  final _telController = TextEditingController();
  ClientsController clientsController = ClientsController.instance;
  VenteController venteController = VenteController.instance;
  NetworkController networkController = NetworkController.instance;
  Client? _client;
  String name = "";
  String tel = "";
  bool noPaiAll = false;

  @override
  void initState() {
    super.initState();
    venteController.cleanVar();
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
    _telController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Client"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Entry(
                text: Text(
                  "Nom et Prénom",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TypeAheadField<Client>(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: _editingController,
                      inputFormatters: [nameMaskFormatter],
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (_client != null) {
                          name = "";
                          tel = "";
                          if (value.trim() != _client!.fullName!) {
                            _client = null;
                            _telController.clear();
                          }
                        } else {
                          if (value.trim().isNotEmpty) {
                            name = value.trim();
                          } else {
                            name = "";
                          }
                        }
                        setState(() {});
                      }),
                  autoFlipDirection: true,
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      borderRadius: BorderRadius.circular(10)),
                  noItemsFoundBuilder: (_) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Ce client n'est pas encore enregistré !"),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await clientsController.getClients(pattern);
                  },
                  getImmediateSuggestions: true,
                  itemBuilder: (context, suggestion) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          color: Colors.black12,
                          child: ListTile(
                            title: Text(suggestion.fullName!),
                            subtitle: Text("Tel: ${suggestion.tel!}"),
                            trailing: suggestion.canDette
                                ? SvgPicture.asset(
                                    MmgAssets.garanti,
                                    height: 28,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    venteController.cleanVar();
                    venteController.getTotal();
                    _editingController.text = suggestion.fullName!;
                    _telController.text = suggestion.tel!;
                    _client = suggestion;
                    name = "";
                    tel = "";
                    noPaiAll = false;
                    setState(() {});
                  },
                ),
              ),
              Entry(
                text: Text(
                  "Téléphone",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TextField(
                  controller: _telController,
                  enabled:
                      _client != null && _client!.tel != null ? false : true,
                  onChanged: (value) {
                    if (value.trim().isNotEmpty) {
                      tel = value.trim();
                    } else {
                      tel = "";
                    }
                  },
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                ),
              ),
              Dimensions.y14,
              Visibility(
                visible: _client != null &&
                    _client!.canDette &&
                    venteController.listPortable.isNotEmpty,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      noPaiAll = !noPaiAll;
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                          value: noPaiAll,
                          onChanged: (value) {
                            setState(() {
                              noPaiAll = !noPaiAll;
                            });
                          }),
                      const Text("Veut pas tout payer maintenant")
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _client != null && _client!.canDette && noPaiAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (venteController.listPortable.isNotEmpty)
                      ListView.builder(
                          itemCount: venteController.listPortable.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, i) => ItemNoPayAllPhoneEdit(i: i)),
                    Dimensions.y28,
                    if (venteController.listArticle.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            "Minimum à payer : ${setMoney(venteController.soldeArticle.value.toInt())}",
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      color: Colors.red,
                                    ),
                          ),
                          Dimensions.y6,
                        ],
                      ),
                    Text(
                      "Net à payer : ${setMoney(venteController.total.value.toInt())}",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Dimensions.y6,
                    Obx(() => Text(
                          "Reste à payer : ${setMoney(venteController.total.value.toInt() - venteController.some.value - venteController.soldeArticle.value)}",
                          style: Theme.of(context).textTheme.headline3,
                        )),
                  ],
                ),
              ),
              Dimensions.y52,
              Obx(() => ElevatedButton(
                    onPressed: !venteController.cirC.value &&
                            venteController.some.value <=
                                venteController.total.value &&
                            venteController.somValid.value
                        ? () async {
                            showDialog(
                                    context: context,
                                    builder: (_) => const ConfirmVenteDialog())
                                .then((value) async {
                              if (value == true) {
                                if (networkController.isOk) {
                                  if (_client != null) {
                                    await venteController.createVente(
                                        client: _client!, noPayAll: noPaiAll);
                                  } else {
                                    if (name != "" && tel == "") {
                                      Get.snackbar("Attention",
                                          "Veuillez bien fournir le nom et le numéro de téléphone du client pour continuer !",
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 5));
                                    }
                                    if (name != "" && tel != "") {
                                      await venteController.createVente(
                                          clientName: name, tel: tel);
                                    }
                                    if (name == "" && tel == "") {
                                      await venteController.createVente();
                                    }
                                  }
                                } else {
                                  buildNoInternet(context);
                                }
                              }
                            });
                          }
                        : null,
                    child: venteController.cirC.value
                        ? const CircularProgressIndicator()
                        : const Text("Valider la vente"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
