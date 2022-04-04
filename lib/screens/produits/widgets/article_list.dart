import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/app/controllers/article_controller.dart';
import '/app/models/article.dart';
import 'item_article.dart';

class ArticlesList extends StatelessWidget {
  const ArticlesList({
    Key? key,
    required this.articleController,
  }) : super(key: key);

  final ArticleController articleController;

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: articleController.queryArticles(),
      reverse: true,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      defaultChild: const Center(child: CircularProgressIndicator()),
      duration: const Duration(seconds: 1),
      itemBuilder: (_, snapshot, anim, i) {
        if (kDebugMode) {
          print(snapshot.value);
        }
        final article = Article.fromJson(snapshot.value!);
        return ItemArticle(article: article, anim: anim);
      },
    );
  }
}
