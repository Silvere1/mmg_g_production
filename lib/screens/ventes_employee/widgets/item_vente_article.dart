import 'package:flutter/material.dart';

import '/app/config/dimensions.dart';
import '/app/models/article.dart';
import '/app/utils/formats/money.dart';

class ItemVenteArticle extends StatelessWidget {
  const ItemVenteArticle({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
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
              Text("Total : ${setMoney(article.prix!)}")
            ],
          ),
        ),
      ),
    );
  }
}
