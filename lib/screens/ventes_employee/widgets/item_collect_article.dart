import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/vente_controller.dart';
import '/app/models/article.dart';
import '/app/utils/formats/money.dart';
import '/res/assets_files.dart';

class ItemCollectArticle extends StatelessWidget {
  const ItemCollectArticle(
      {Key? key,
      required this.list2Key,
      required this.venteController,
      required this.article,
      required this.i,
      required this.anim})
      : super(key: key);
  final GlobalKey<AnimatedListState> list2Key;
  final VenteController venteController;
  final Article article;
  final int i;
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: anim,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  article.name,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Dimensions.y2,
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Text("PU : ${setMoney(article.pu!)}"),
                    Text("Nbr : ${article.nbr}"),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("Total : ${setMoney(article.prix!)}"),
                    InkWell(
                      onTap: () async {
                        list2Key.currentState!.removeItem(
                            i,
                            (_, animation) => ItemCollectArticle(
                                list2Key: list2Key,
                                venteController: venteController,
                                article: article,
                                i: i,
                                anim: animation));
                        await 1.delay();
                        await venteController.deleteArticleOfList(i);
                      },
                      child: SvgPicture.asset(
                        MmgAssets.delete,
                        height: 24,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
