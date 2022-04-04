import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_input_formatter/money_input_controller.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/network_controller.dart';
import '/app/controllers/vente_controller.dart';
import '/app/models/phone_color.dart';
import '/app/models/portable.dart';
import '/app/models/vente.dart';
import '/app/utils/formats/mask_formater.dart';
import '/app/utils/formats/money.dart';
import '/res/assets_files.dart';
import '/res/theme/styles/btn_styles.dart';
import '/screens/components/entry.dart';
import '/screens/components/no_internet.dart';

class ReglementDialog extends StatefulWidget {
  const ReglementDialog(
      {Key? key, required this.i, required this.portable, required this.vente})
      : super(key: key);
  final int i;
  final Portable portable;
  final Vente vente;

  @override
  State<ReglementDialog> createState() => _ReglementDialogState();
}

class _ReglementDialogState extends State<ReglementDialog> {
  VenteController venteController = VenteController.instance;
  NetworkController networkController = NetworkController.instance;

  final _moneyController = MoneyInputController();
  bool backed = false;
  bool payed = false;
  int montant = 0;

  @override
  void initState() {
    super.initState();
    venteController.cirC(false);
  }

  @override
  void dispose() {
    super.dispose();
    _moneyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.portable.name!,
              style: Theme.of(context).textTheme.headline4,
            ),
            Dimensions.y2,
            Wrap(
              spacing: 14,
              children: [
                Text("imei : ${widget.portable.imei!}"),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.portable.color!),
                    Dimensions.x6,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(.5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 16,
                            width: 16,
                            color: getPhoneColor(widget.portable.color!),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Dimensions.y2,
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Text("Prix : ${setMoney(widget.portable.prix!)}"),
                const SizedBox(
                  height: 14,
                  child: VerticalDivider(
                    width: 0,
                    thickness: 3,
                    color: Colors.black38,
                  ),
                ),
                Text(
                  "reste : ${setMoney(widget.portable.prix! - widget.portable.montantRemis!)}",
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.red),
                ),
              ],
            ),
            Dimensions.y6,
            Obx(() => !venteController.cirC.value
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (widget.portable.montantRemis == 0)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  backed = !backed;
                                  payed = false;
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: backed,
                                      onChanged: (value) {
                                        setState(() {
                                          backed = !backed;
                                          payed = false;
                                        });
                                      }),
                                  const Text("Ramener")
                                ],
                              ),
                            ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                payed = !payed;
                                backed = false;
                              });
                            },
                            autofocus: true,
                            child: Row(
                              children: [
                                Checkbox(
                                    value: payed,
                                    onChanged: (value) {
                                      setState(() {
                                        payed = !payed;
                                        backed = false;
                                      });
                                    }),
                                const Text("Payer")
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (backed)
                        const Text(
                          "Rassurez vous d'avoir retiré le téléphone chez le client !",
                          textAlign: TextAlign.center,
                        ),
                      Visibility(
                        visible: payed,
                        child: Column(
                          children: [
                            Entry(
                              text: Text(
                                "Montant remis",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              editText: TextField(
                                controller: _moneyController,
                                inputFormatters: prixInputFormatters(),
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  if (value.trim().isNotEmpty) {
                                    montant =
                                        _moneyController.numberValue.toInt();
                                  } else {
                                    montant = 0;
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                            if (montant + widget.portable.montantRemis! ==
                                widget.portable.prix!)
                              const Text(
                                "Rassurez vous d'avoir encaissé tout le reste à payer car"
                                " ce téléphone sera marqué comme Payé !",
                                textAlign: TextAlign.center,
                              )
                          ],
                        ),
                      ),
                      Dimensions.y14,
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
                              onPressed: _moneyController.text.trim() != "" &&
                                          montant <=
                                              widget.portable.prix! -
                                                  widget
                                                      .portable.montantRemis! ||
                                      backed
                                  ? () async {
                                      if (networkController.isOk) {
                                        if (backed == true) {
                                          await venteController.backedPortable(
                                              widget.vente,
                                              widget.portable,
                                              widget.i);
                                          Get.back();
                                        } else {
                                          await venteController
                                              .reglementPortable(
                                                  widget.vente,
                                                  widget.portable,
                                                  widget.i,
                                                  montant);
                                          Get.back();
                                        }
                                      } else {
                                        buildNoInternet(context);
                                      }
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
                  )
                : const Center(
                    child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  )))
          ],
        ),
      ),
    );
  }
}
