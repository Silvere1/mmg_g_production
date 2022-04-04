import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/appro_controller.dart';
import '/app/controllers/article_controller.dart';
import '/app/controllers/network_controller.dart';
import '/app/controllers/portable_controller.dart';
import '/app/models/acc.dart';
import '/app/models/agence.dart';
import '/app/models/article.dart';
import '/app/models/phone.dart';
import '/app/models/portable.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';
import '/screens/components/no_internet.dart';
import '/screens/procurements/widgets/item_acc_collection_appro.dart';
import '/screens/procurements/widgets/item_phone_collection_appro.dart';

class CollectionAppro extends StatefulWidget {
  const CollectionAppro({Key? key, required this.agence}) : super(key: key);
  final Agence agence;

  @override
  State<CollectionAppro> createState() => _CollectionApproState();
}

class _CollectionApproState extends State<CollectionAppro> {
  final approController = ApproController.instance;
  final portableController = PortableController.instance;
  final articleController = ArticleController.instance;
  final networkController = NetworkController.instance;

  final GlobalKey<AnimatedListState> _list1Key = GlobalKey();
  final GlobalKey<AnimatedListState> _list2Key = GlobalKey();
  final _editingController = TextEditingController();

  final List<String> item = ["Téléphone", "Accessoire"];
  String tri = "Téléphone";
  final tel = "Téléphone";

  @override
  void initState() {
    approController.cleanList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Appro. ${widget.agence.name}"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              tri + "s",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (_) => item
                                .map((e) => PopupMenuItem(
                                    child: Text(e + "s"),
                                    onTap: () {
                                      setState(() {
                                        _editingController.clear();
                                        tri = e;
                                      });
                                    }))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Dimensions.y4,
                  tri == tel
                      ? TypeAheadField<Portable>(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _editingController,
                              keyboardType: TextInputType.name,
                              //inputFormatters: [nameAndNumMaskFormatter],
                              decoration: const InputDecoration(
                                  hintText: "Rechercher un téléphone")),
                          noItemsFoundBuilder: (_) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("N'existe pas !"),
                          ),
                          suggestionsCallback: (pattern) async {
                            return await portableController
                                .getPortables(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion.name!),
                            );
                          },
                          autoFlipDirection: true,
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          getImmediateSuggestions: true,
                          onSuggestionSelected: (suggestion) async {
                            _editingController.text = "";
                            if (approController.listPhone
                                .any((e) => e.id == suggestion.id)) {
                              Get.snackbar("Attention",
                                  "Ce produit est déjà ajouté à votre collection !",
                                  colorText: Colors.white);
                            } else {
                              if (suggestion.used == false) {
                                approController.addPortableNoUsed(suggestion);
                              }
                              approController.addPhone(Phone(
                                  id: suggestion.id,
                                  name: suggestion.name!,
                                  qte: 1));
                              if (_list1Key.currentState != null) {
                                await .5.delay();
                                _list1Key.currentState!.insertItem(
                                    approController.listPhone.length - 1);
                              }
                            }
                          },
                        )
                      : TypeAheadField<Article>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _editingController,
                            keyboardType: TextInputType.name,
                            //inputFormatters: [nameAndNumMaskFormatter],
                            decoration: const InputDecoration(
                                hintText: "Rechercher un accessoire"),
                          ),
                          noItemsFoundBuilder: (_) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("N'existe pas !"),
                          ),
                          suggestionsCallback: (pattern) async {
                            return await articleController.getArticles(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion.name),
                            );
                          },
                          autoFlipDirection: true,
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          getImmediateSuggestions: true,
                          onSuggestionSelected: (suggestion) async {
                            _editingController.text = "";
                            if (approController.listAcc
                                .any((e) => e.id == suggestion.id)) {
                              Get.snackbar("Attention",
                                  "Ce produit est déjà ajouté à votre collection !",
                                  colorText: Colors.white);
                            } else {
                              if (suggestion.used == false) {
                                approController.addArticleNoUsed(suggestion);
                              }
                              approController.addAcc(Acc(
                                  id: suggestion.id,
                                  name: suggestion.name,
                                  qte: 1));
                              if (_list2Key.currentState != null) {
                                await .5.delay();
                                _list2Key.currentState!.insertItem(0);
                              }
                            }
                          },
                        ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              approController.listPhone.isNotEmpty
                                  ? Column(
                                      children: [
                                        Text(
                                          "Portables",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                        AnimatedList(
                                            key: _list1Key,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            initialItemCount: approController
                                                .listPhone.length,
                                            itemBuilder: (_, i, anim) {
                                              const Duration(seconds: 1);
                                              return ItemPhoneCollectionAppro(
                                                  listKey: _list1Key,
                                                  i: i,
                                                  anim: anim,
                                                  phone: approController
                                                      .listPhone[i],
                                                  approController:
                                                      approController);
                                            }),
                                      ],
                                    )
                                  : const SizedBox(),
                              approController.listAcc.isNotEmpty
                                  ? Column(
                                      children: [
                                        Text(
                                          "Accessoires",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                        AnimatedList(
                                            key: _list2Key,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            initialItemCount:
                                                approController.listAcc.length,
                                            itemBuilder: (_, i, anim) {
                                              const Duration(seconds: 1);
                                              return ItemAccCollectionAppro(
                                                  listKey: _list2Key,
                                                  i: i,
                                                  anim: anim,
                                                  acc: approController
                                                      .listAcc[i],
                                                  approController:
                                                      approController);
                                            }),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Visibility(
                  visible: approController.listPhone.isNotEmpty ||
                      approController.listAcc.isNotEmpty,
                  child: Material(
                    elevation: 10,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total :",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              Text(
                                "Téléphones : ${approController.nbrPhone}",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              Text(
                                "Accessoires : ${approController.nbrAcc}",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: !approController.cirBar.value
                                  ? () async {
                                      if (networkController.isOk) {
                                        showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CircleAvatar(
                                                          child:
                                                              SvgPicture.asset(
                                                            MmgAssets
                                                                .procurementRegular,
                                                            height: 34,
                                                          ),
                                                          radius: 30,
                                                          backgroundColor:
                                                              backGroundSvg,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Wrap(
                                                            spacing: 10,
                                                            children: [
                                                              if (approController
                                                                      .nbrPhone
                                                                      .value !=
                                                                  0)
                                                                Text(
                                                                    "Téléphone(s) : ${approController.nbrPhone.value}"),
                                                              if (approController
                                                                      .nbrAcc
                                                                      .value !=
                                                                  0)
                                                                Text(
                                                                    "Accessoire(s) : ${approController.nbrAcc.value}")
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          "Voulez-vous enregistrer ?",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline3,
                                                        ),
                                                        const SizedBox(
                                                          height: 18,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: OutlinedButton(
                                                                    onPressed: () =>
                                                                        Get.back(
                                                                            result:
                                                                                false),
                                                                    child: const Text(
                                                                        "Non"))),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    ElevatedButton(
                                                              onPressed: () =>
                                                                  Get.back(
                                                                      result:
                                                                          true),
                                                              child: const Text(
                                                                  "Oui"),
                                                            ))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )).then((value) async {
                                          if (value == true) {
                                            await approController
                                                .addApp(widget.agence)
                                                .then((value) {
                                              Get.back();
                                              Get.back();
                                            });
                                          }
                                        });
                                      } else {
                                        buildNoInternet(context);
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 48)),
                              child: approController.cirBar.value
                                  ? const CircularProgressIndicator()
                                  : const Text("Continuer"))
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
