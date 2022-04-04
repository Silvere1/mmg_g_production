import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '/app/models/article.dart';

class ArticleController extends GetxController {
  final DatabaseReference _reference =
      FirebaseDatabase.instance.ref().child("article");
  static ArticleController get instance => Get.find();
  var name = "".obs;

  void cleanVar() {
    name("");
  }

  Future<void> nameArticleEditing(String str) async {
    name(str);
  }

  Future<bool> createArticle() async {
    Article article = Article(
        id: "id",
        name: name.value,
        used: false,
        nbr: null,
        pu: null,
        prix: null);
    var _articles = await _reference.get();
    var articles =
        _articles.children.map((e) => Article.fromJson(e.value!)).toList();
    if (articles
        .any((e) => e.name.toLowerCase() == article.name.toLowerCase())) {
      return false;
    } else {
      String? id = _reference.push().key;

      article.id = id!;

      _reference.child(id).set(article.toJson());
      cleanVar();
      return true;
    }
  }

  Future<void> setArticleUsed(List<Article> articles) async {
    await _reference.runTransaction((value) {
      for (var e in articles) {
        _reference.child(e.id).update({"used": true});
      }
      return Transaction.abort();
    }, applyLocally: false);
  }

  deleteArticle(Article articleX) {
    _reference.child(articleX.id).remove();
  }

  Future<List<Article>> getArticles(String str) async {
    name(str);
    var _articles = await _reference.get();
    var articles =
        _articles.children.map((e) => Article.fromJson(e.value!)).toList();
    var result = <Article>[];
    for (var e in articles) {
      if (e.name.toLowerCase().contains(str.trim().toLowerCase())) {
        result.add(e);
      }
    }
    return result;
  }

  Future<List<Article>> getListArticles() async {
    var _articles = await _reference.get();
    var articles =
        _articles.children.map((e) => Article.fromJson(e.value!)).toList();
    return articles;
  }

  Query queryArticles() => _reference;
}
