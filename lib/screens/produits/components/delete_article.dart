import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/article_controller.dart';
import '/app/controllers/user_controller.dart';
import '/app/models/article.dart';
import '/screens/components/entry.dart';

class DeleteArticle extends StatefulWidget {
  const DeleteArticle({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  State<DeleteArticle> createState() => _DeleteArticleState();
}

class _DeleteArticleState extends State<DeleteArticle> {
  UserController userController = UserController.instance;
  ArticleController articleController = ArticleController.instance;

  @override
  void initState() {
    super.initState();
    userController.cleanVar();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Supprimer",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                widget.article.name + " ?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
              Entry(
                text: Text(
                  "Entrez votre mot de passe",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TextField(
                  onChanged: (value) {
                    userController.editingPassW(value.trim());
                  },
                  textInputAction: TextInputAction.done,
                  obscureText: userController.eye.value,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        userController.eye.toggle();
                      },
                      child: Icon(userController.eye.value
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off_outlined),
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              Dimensions.y14,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () => Get.back(), child: const Text("Non")),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: userController.passW.value.length >= 4
                            ? () {
                                Get.back();
                                userController.checkPassword().then((value) {
                                  if (value == true) {
                                    articleController
                                        .deleteArticle(widget.article);
                                  }
                                });
                              }
                            : null,
                        child: const Text("Oui")),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
