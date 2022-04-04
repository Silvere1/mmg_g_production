import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/controllers/vente_controller.dart';
import '/app/models/acc.dart';
import '/app/models/article.dart';
import '/res/assets_files.dart';
import '/screens/ventes_employee/components/edit_article_dialog.dart';

class ItemSelectArticle extends StatefulWidget {
  const ItemSelectArticle({Key? key, required this.acc}) : super(key: key);
  final Acc acc;

  @override
  State<ItemSelectArticle> createState() => _ItemSelectArticleState();
}

class _ItemSelectArticleState extends State<ItemSelectArticle> {
  VenteController venteController = VenteController.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              if (widget.acc.qte > 0) {
                if (venteController.listArticle
                    .any((e) => e.id == widget.acc.id)) {
                  Get.snackbar(
                    "Attention",
                    "Ce accessoire est déjà ajouté dans votre liste.",
                    colorText: Colors.white,
                    duration: const Duration(seconds: 4),
                  );
                } else {
                  final article = Article(
                      id: widget.acc.id,
                      name: widget.acc.name,
                      used: true,
                      nbr: null,
                      pu: null,
                      prix: null);
                  showDialog<Article>(
                      context: context,
                      builder: (_) => EditArticleDialog(
                            article: article,
                            acc: widget.acc,
                          )).then((value) {
                    if (value != null) {
                      Get.back(result: 2);
                    }
                  });
                }
              } else {
                Get.snackbar(
                    "Attention", "Ce produit est en rupture de stock !",
                    duration: const Duration(seconds: 4),
                    colorText: Colors.white);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffffdcd8),
                      ),
                      child: SvgPicture.asset(
                        MmgAssets.electronic,
                        color: Theme.of(context).primaryColor,
                        height: 20,
                      )),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      widget.acc.name,
                      style: Theme.of(context).textTheme.headline4,
                    ),
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
