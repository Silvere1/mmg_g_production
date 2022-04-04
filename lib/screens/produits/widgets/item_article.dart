import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/app/models/article.dart';
import '/res/assets_files.dart';
import '/screens/global/widgets/product_is_used.dart';
import '/screens/produits/components/delete_article.dart';

class ItemArticle extends StatelessWidget {
  const ItemArticle({Key? key, required this.article, required this.anim})
      : super(key: key);
  final Article article;
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: anim,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                ///
              },
              onLongPress: () {
                if (article.used) {
                  productIsUsed();
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => DeleteArticle(article: article));
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
                        article.name,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
