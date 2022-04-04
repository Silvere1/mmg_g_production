import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/models/agence.dart';
import '/res/assets_files.dart';
import '/screens/procurements/ui/collection_appro.dart';

class ItemSelectMagasinAppro extends StatelessWidget {
  const ItemSelectMagasinAppro(
      {Key? key, required this.anim, required this.agence})
      : super(key: key);
  final Animation<double> anim;
  final Agence agence;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: anim,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Get.to(() => CollectionAppro(agence: agence));
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffffdcd8),
                        ),
                        child: SvgPicture.asset(
                          MmgAssets.magasin,
                          height: 20,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            agence.name,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          //const SizedBox(height: 8),
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
