import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/controllers/vente_controller.dart';
import '/app/models/vente.dart';
import '/app/utils/formats/date.dart';
import '/app/utils/formats/money.dart';
import '/res/assets_files.dart';
import '/screens/ventes_employee/ui/detail_vente_employee.dart';

class ItemVenteEmployee extends StatefulWidget {
  const ItemVenteEmployee({Key? key, required this.anim, required this.vente})
      : super(key: key);
  final Animation<double> anim;
  final Vente vente;

  @override
  State<ItemVenteEmployee> createState() => _ItemVenteEmployeeState();
}

class _ItemVenteEmployeeState extends State<ItemVenteEmployee> {
  VenteController venteController = VenteController.instance;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.anim,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () async {
                await venteController.cleanLists();
                await venteController.getVenteX(widget.vente);
                Get.to(() => DetailVenteEmployee(vente: widget.vente));
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
                          widget.vente.cancel != null &&
                                  widget.vente.cancel == true
                              ? MmgAssets.icNoCash
                              : MmgAssets.receiveCash,
                          color: Theme.of(context).primaryColor,
                          height: 30,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.vente.nameClient,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Wrap(
                            spacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                setMoney(widget.vente.netPayer),
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              if (widget.vente.netPayer - widget.vente.payer !=
                                  0)
                                const SizedBox(
                                  height: 14,
                                  child: VerticalDivider(
                                    width: 0,
                                    thickness: 3,
                                    color: Colors.black38,
                                  ),
                                ),
                              if (widget.vente.netPayer - widget.vente.payer !=
                                  0)
                                Text(
                                  setMoney(widget.vente.netPayer -
                                      widget.vente.payer),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(color: Colors.red),
                                ),
                            ],
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Wrap(
                                spacing: 10,
                                children: [
                                  if (widget.vente.portables != null)
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          MmgAssets.portable,
                                          height: 18,
                                        ),
                                        Text(
                                            "${widget.vente.portables!.length}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3),
                                      ],
                                    ),
                                  if (widget.vente.articles != null)
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          MmgAssets.electronic,
                                          height: 18,
                                        ),
                                        Text("${widget.vente.nbrAss}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3),
                                      ],
                                    ),
                                ],
                              ),
                              Text(
                                "Le ${date.format(widget.vente.craeteAt)}",
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
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
