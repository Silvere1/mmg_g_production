import 'package:flutter/material.dart';

import '/app/controllers/article_controller.dart';
import '/app/controllers/portable_controller.dart';
import '/app/controllers/stock_controller.dart';
import '/app/models/acc.dart';
import '/app/models/phone.dart';
import '/screens/ventes_employee/widgets/item_select_article.dart';
import '/screens/ventes_employee/widgets/item_select_portable.dart';

class SelectProducts extends StatefulWidget {
  const SelectProducts({Key? key}) : super(key: key);

  @override
  _SelectProductsState createState() => _SelectProductsState();
}

class _SelectProductsState extends State<SelectProducts> {
  final TextEditingController _editingController = TextEditingController();
  PortableController portableController = PortableController.instance;
  ArticleController articleController = ArticleController.instance;
  StockController stockController = StockController.instance;
  final List<String> item = ["Téléphone", "Accessoire"];
  String tri = "Téléphone";
  final tel = "Téléphone";

  bool searching = false;

  late Future<List<Phone>> _futurePortable;
  late Future<List<Acc>> _futureArticle;

  @override
  void initState() {
    _futurePortable = stockController.getPhones();
    _futureArticle = stockController.getAccs();
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sélectionner"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: TextField(
                controller: _editingController,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    if (tri == tel) {
                      _futurePortable =
                          stockController.getPhoneSearch(value.trim());
                    } else {
                      _futureArticle =
                          stockController.getAccSearch(value.trim());
                    }
                    setState(() {});
                  } else {
                    if (tri == tel) {
                      _futurePortable = stockController.getPhones();
                    } else {
                      _futureArticle = stockController.getAccs();
                    }
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  hintText: "Rechercher un $tri",
                ),
              ),
            ),
            tri == tel
                ? FutureBuilder<List<Phone>>(
                    future: _futurePortable,
                    builder: (_, snapshot) => snapshot.hasData
                        ? Expanded(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (_, i) => ItemSelectPortable(
                                    phone: snapshot.data![i])))
                        : const Center(child: CircularProgressIndicator()))
                : FutureBuilder<List<Acc>>(
                    future: _futureArticle,
                    builder: (_, snapshot) => snapshot.hasData
                        ? Expanded(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (_, i) =>
                                    ItemSelectArticle(acc: snapshot.data![i])))
                        : const Center(child: CircularProgressIndicator()))
          ],
        ),
      ),
    );
  }
}
