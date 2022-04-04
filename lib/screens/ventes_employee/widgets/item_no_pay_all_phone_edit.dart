import 'package:flutter/material.dart';
import 'package:money_input_formatter/money_input_controller.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/vente_controller.dart';
import '/app/utils/formats/mask_formater.dart';
import '/app/utils/formats/money.dart';
import '/res/theme/colors/constants.dart';

class ItemNoPayAllPhoneEdit extends StatefulWidget {
  const ItemNoPayAllPhoneEdit({Key? key, required this.i}) : super(key: key);
  final int i;

  @override
  State<ItemNoPayAllPhoneEdit> createState() => _ItemNoPayAllPhoneEditState();
}

class _ItemNoPayAllPhoneEditState extends State<ItemNoPayAllPhoneEdit> {
  VenteController venteController = VenteController.instance;
  final _editText = MoneyInputController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  venteController.listPortable[widget.i].name!,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Dimensions.y2,
                Text(
                  "Prix : ${setMoney(venteController.listPortable[widget.i].prix!)}",
                  style: Theme.of(context).textTheme.headline3,
                ),
                Dimensions.y2,
                TextField(
                  controller: _editText,
                  onChanged: (value) async {
                    if (value.trim().isNotEmpty) {
                      final some = _editText.numberValue.toInt();
                      await venteController.editSomeRemi(widget.i, some);
                    } else {
                      await venteController.editSomeRemi(widget.i, 0);
                    }
                    setState(() {});
                  },
                  inputFormatters: prixInputFormatters(),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      fillColor: backGround,
                      hintStyle: Theme.of(context).textTheme.headline3,
                      hintText: "Entrer le montant remis "),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
