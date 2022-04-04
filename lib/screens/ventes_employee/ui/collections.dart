import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/vente_controller.dart';
import '/app/utils/formats/money.dart';
import '/screens/ventes_employee/ui/select_client.dart';
import '/screens/ventes_employee/ui/select_products.dart';
import '/screens/ventes_employee/widgets/item_collect_article.dart';
import '/screens/ventes_employee/widgets/item_collect_portable.dart';

class Collections extends StatefulWidget {
  const Collections({Key? key}) : super(key: key);

  @override
  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  VenteController venteController = VenteController.instance;

  final GlobalKey<AnimatedListState> _list1Key = GlobalKey();
  final GlobalKey<AnimatedListState> _list2Key = GlobalKey();

  @override
  void initState() {
    venteController.cleanLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter les produits"),
        ),
        body: Obx(() {
          return Column(
            mainAxisAlignment: venteController.listPortable.isNotEmpty ||
                    venteController.listArticle.isNotEmpty
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Expanded(
                flex: venteController.listPortable.isNotEmpty ||
                        venteController.listArticle.isNotEmpty
                    ? 1
                    : 0,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (venteController.listPortable.isNotEmpty)
                        Column(
                          children: [
                            Text(
                              "Portables",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            AnimatedList(
                                key: _list1Key,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                initialItemCount:
                                    venteController.listPortable.length,
                                itemBuilder: (_, i, anim) {
                                  const Duration(seconds: 1);
                                  return ItemCollectPortable(
                                      venteController: venteController,
                                      list1Key: _list1Key,
                                      portable: venteController.listPortable[i],
                                      i: i,
                                      anim: anim);
                                }),
                          ],
                        ),
                      if (venteController.listArticle.isNotEmpty)
                        Column(
                          children: [
                            Text(
                              "Accessoires",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            AnimatedList(
                                key: _list2Key,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                initialItemCount:
                                    venteController.listArticle.length,
                                itemBuilder: (_, i, anim) {
                                  const Duration(seconds: 1);
                                  return ItemCollectArticle(
                                      list2Key: _list2Key,
                                      venteController: venteController,
                                      article: venteController.listArticle[i],
                                      i: i,
                                      anim: anim);
                                }),
                          ],
                        ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: venteController.listArticle.isNotEmpty ||
                                      venteController.listPortable.isNotEmpty
                                  ? 10
                                  : 0),
                          child: FloatingActionButton(
                            onPressed: () {
                              Get.to<int>(() => const SelectProducts())!
                                  .then((value) async {
                                if (value != null) {
                                  if (value == 1) {
                                    if (_list1Key.currentState != null) {
                                      await .5.delay();
                                      _list1Key.currentState!.insertItem(
                                          venteController.listPortable.length -
                                              1);
                                    }
                                  }
                                  if (value == 2) {
                                    if (_list2Key.currentState != null) {
                                      await .5.delay();
                                      _list2Key.currentState!.insertItem(
                                          venteController.listArticle.length -
                                              1);
                                    }
                                  }
                                  await venteController.getTotal();
                                }
                              });
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: venteController.listPortable.isNotEmpty ||
                      venteController.listArticle.isNotEmpty,
                  child: Material(
                    elevation: 10,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total : ${setMoney(venteController.total.value.toInt())}",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Get.to(() => const SelectClient());
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 48)),
                              child: const Text("Continuer"))
                        ],
                      ),
                    ),
                  )),
            ],
          );
        }),
      ),
    );
  }
}
