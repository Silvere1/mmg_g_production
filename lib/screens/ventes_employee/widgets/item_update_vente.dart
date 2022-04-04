import 'package:flutter/material.dart';

import '/app/config/dimensions.dart';
import '/app/models/update_vente.dart';
import '/app/utils/formats/date.dart';

class ItemUpdateVente extends StatelessWidget {
  const ItemUpdateVente({Key? key, required this.updateVente})
      : super(key: key);
  final UpdateVente updateVente;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.white70,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                updateVente.raison,
                style: Theme.of(context).textTheme.headline3,
              ),
              Dimensions.y2,
              Text("Effectué par : ${updateVente.userName}"),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  date.format(updateVente.at),
                  style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
