import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_input_formatter/money_input_controller.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/vente_controller.dart';
import '/app/models/acc.dart';
import '/app/models/article.dart';
import '/app/utils/formats/mask_formater.dart';
import '/res/assets_files.dart';
import '/res/theme/styles/btn_styles.dart';

class EditArticleDialog extends StatefulWidget {
  const EditArticleDialog({Key? key, required this.article, required this.acc})
      : super(key: key);
  final Article article;
  final Acc acc;

  @override
  _EditArticleDialogState createState() => _EditArticleDialogState();
}

class _EditArticleDialogState extends State<EditArticleDialog> {
  final _moneyController = MoneyInputController();
  VenteController venteController = VenteController.instance;
  String montant = "";
  int nbr = 0;
  int prixToIn = 0;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.article.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    setState(() {
                      nbr = int.parse(value);
                    });
                  } else {
                    setState(() {
                      nbr = 0;
                    });
                  }
                },
                inputFormatters: [prixMaskFormatter],
                decoration: const InputDecoration(labelText: "Nbr"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                controller: _moneyController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  setState(() {
                    montant = _moneyController.numberValue.toInt().toString();
                    prixToIn = _moneyController.numberValue.toInt();
                  });
                },
                inputFormatters: prixInputFormatters(),
                decoration: const InputDecoration(labelText: "Prix/Unité"),
              ),
            ),
            Dimensions.y8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: buildCancelBtnStyle(),
                    child: SvgPicture.asset(
                      MmgAssets.cancel,
                      height: 28,
                      color: Theme.of(context).primaryColor,
                    )),
                ElevatedButton(
                    onPressed: _moneyController.text != "" &&
                            montant.isNumericOnly &&
                            nbr != 0 &&
                            nbr <= widget.acc.qte &&
                            prixToIn > 0 &&
                            montant.trim().isNotEmpty
                        ? () async {
                            widget.article.prix = int.parse(montant) * nbr;
                            widget.article.pu = int.parse(montant);
                            widget.article.nbr = nbr;
                            Get.back(result: widget.article);
                            venteController.listArticle.add(widget.article);
                          }
                        : null,
                    style: buildValidateBtnStyle(),
                    child: SvgPicture.asset(
                      MmgAssets.ok,
                      height: 28,
                      color: Colors.white,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
