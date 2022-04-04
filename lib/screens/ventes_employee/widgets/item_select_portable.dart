import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/controllers/vente_controller.dart';
import '/app/models/phone.dart';
import '/app/models/portable.dart';
import '/res/assets_files.dart';
import '/screens/ventes_employee/components/edit_portable_dialog.dart';

class ItemSelectPortable extends StatefulWidget {
  const ItemSelectPortable({Key? key, required this.phone}) : super(key: key);
  final Phone phone;

  @override
  State<ItemSelectPortable> createState() => _ItemSelectPortableState();
}

class _ItemSelectPortableState extends State<ItemSelectPortable> {
  VenteController venteController = VenteController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              if (widget.phone.qte > 0) {
                final portable = Portable(
                    id: widget.phone.id,
                    name: widget.phone.name,
                    used: true,
                    imei: null,
                    color: null,
                    backed: null,
                    payer: false,
                    prix: null,
                    montantRemis: 0);
                if (venteController.listPhones
                    .any((e) => e.id == widget.phone.id)) {
                  if (venteController.listPhones.any((e) =>
                      e.id == widget.phone.id && e.qte < widget.phone.qte)) {
                    showDialog<Portable>(
                            context: context,
                            builder: (_) =>
                                EditPortableDialog(portable: portable))
                        .then((value) {
                      if (value != null) {
                        Get.back(result: 1);
                      }
                    });
                  } else {
                    Get.snackbar("Attention",
                        "Vous ne pouvez pas dépasser la quantité en stock !",
                        duration: const Duration(seconds: 4),
                        colorText: Colors.white);
                  }
                } else {
                  showDialog<Portable>(
                      context: context,
                      builder: (_) =>
                          EditPortableDialog(portable: portable)).then((value) {
                    if (value != null) {
                      Get.back(result: 1);
                    }
                  });
                }
              } else {
                Get.snackbar(
                    "Attention", "Ce produit est en rupture de stock !",
                    duration: const Duration(seconds: 4),
                    colorText: Colors.white);
              }
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
                        MmgAssets.portable,
                        color: Theme.of(context).primaryColor,
                        height: 20,
                      )),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      widget.phone.name,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
