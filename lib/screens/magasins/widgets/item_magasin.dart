import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/models/agence.dart';
import '/screens/magasins/ui/detail_magasin.dart';

class ItemMagasin extends StatelessWidget {
  const ItemMagasin({
    Key? key,
    required this.agence,
    required this.anim,
    required this.select,
  }) : super(key: key);

  final Agence agence;
  final Animation<double> anim;
  final bool select;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: anim,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (select == true) {
                Get.back<Agence>(result: agence);
              } else {
                Get.to(() => DetailMagasin(agence: agence));
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffffdcd8),
                      ),
                      child: SvgPicture.asset(
                        "assets/svgs/online_store_regular.svg",
                        height: 35,
                      )),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agence.name,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                            "Employé(s) : ${agence.employers != null ? agence.employers!.length : "0"}")
                      ],
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
