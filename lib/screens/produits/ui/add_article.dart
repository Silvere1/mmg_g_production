import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '/app/controllers/article_controller.dart';
import '/app/models/article.dart';
import '/screens/components/entry.dart';
import '/screens/global/widgets/name_existe.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({Key? key}) : super(key: key);

  @override
  _AddArticleState createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  final TextEditingController _editingController = TextEditingController();
  ArticleController articleController = ArticleController.instance;

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  void initState() {
    super.initState();
    articleController.cleanVar();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter un Article"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Entry(
                text: Text(
                  "Désignation de l'article",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TypeAheadField<Article>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _editingController,
                    keyboardType: TextInputType.name,
                    //inputFormatters: [nameAndNumMaskFormatter],
                  ),
                  noItemsFoundBuilder: (_) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("N'existe pas encore."),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await articleController.getArticles(pattern);
                  },
                  getImmediateSuggestions: true,
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.name),
                    );
                  },
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSuggestionSelected: (suggestion) {
                    _editingController.text = suggestion.name;
                    articleController.nameArticleEditing(suggestion.name);
                    Get.snackbar("Attention", "Ce produit existe déjà !",
                        colorText: Colors.white);
                  },
                ),
              ),
              const SizedBox(
                height: 146,
              ),
              Obx(() => ElevatedButton(
                    onPressed: articleController.name.value != ""
                        ? () {
                            articleController.createArticle().then((value) {
                              if (value == true) {
                                Get.back();
                              } else {
                                nameExiste();
                              }
                            });
                          }
                        : null,
                    child: const Text("Enregistrer"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
