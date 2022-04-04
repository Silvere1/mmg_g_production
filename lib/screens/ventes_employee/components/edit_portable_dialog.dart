import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_input_formatter/money_input_controller.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/vente_controller.dart';
import '/app/models/phone_color.dart';
import '/app/models/portable.dart';
import '/app/utils/formats/mask_formater.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';
import '/res/theme/styles/btn_styles.dart';

class EditPortableDialog extends StatefulWidget {
  const EditPortableDialog({Key? key, required this.portable})
      : super(key: key);
  final Portable portable;

  @override
  _EditPortableDialogState createState() => _EditPortableDialogState();
}

class _EditPortableDialogState extends State<EditPortableDialog> {
  VenteController venteController = VenteController.instance;
  final _moneyController = MoneyInputController();
  String nameColor = "Black";
  Color colorX = Colors.black;
  int imei = 0;
  String prix = "";
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
              widget.portable.name!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                onChanged: (value) {
                  if (value.length == 4) {
                    imei = int.parse(value);
                  } else {
                    imei = 0;
                  }
                  setState(() {});
                },
                inputFormatters: [imeiMaskFormatter],
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Imei"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                controller: _moneyController,
                onChanged: (value) {
                  setState(() {
                    prix = _moneyController.numberValue.toInt().toString();
                    prixToIn = _moneyController.numberValue.toInt();
                  });
                },
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: prixInputFormatters(),
                decoration: const InputDecoration(labelText: "Prix"),
              ),
            ),
            Row(
              children: [
                Text(
                  nameColor,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Dimensions.x10,
                PopupMenuButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          height: 16,
                          width: 16,
                          color: colorX,
                        ),
                      ),
                    ),
                    color: backGround,
                    itemBuilder: (_) => phoneColors
                        .map(
                          (e) => PopupMenuItem(
                            onTap: () {
                              setState(() {
                                nameColor = e.title;
                                colorX = e.color;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.title),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    height: 16,
                                    width: 16,
                                    color: e.color,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                        .toList())
              ],
            ),
            Dimensions.y10,
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
                    onPressed: imei != 0 &&
                            prix.isNumericOnly &&
                            prixToIn > 0 &&
                            prix.trim().isNotEmpty
                        ? () async {
                            widget.portable.prix = int.parse(prix);
                            widget.portable.imei = imei;
                            widget.portable.color = nameColor;
                            Get.back(result: widget.portable);
                            venteController.addPortable(widget.portable);
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
