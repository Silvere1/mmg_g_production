import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '/app/controllers/stock_controller.dart';
import '/app/models/stock_m.dart';
import '/screens/stock/widgets/item_agence_stock.dart';

class AgenceStockAdmin extends StatefulWidget {
  const AgenceStockAdmin({Key? key}) : super(key: key);

  @override
  State<AgenceStockAdmin> createState() => _AgenceStockAdminState();
}

class _AgenceStockAdminState extends State<AgenceStockAdmin> {
  final stockController = StockController.instance;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        FirebaseAnimatedList(
          query: stockController.getAgenceStock(),
          reverse: true,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          defaultChild: const Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
          ),
          duration: const Duration(seconds: 1),
          itemBuilder: (_, snapshot, anim, i) {
            final stockM = StockM.fromJson(snapshot.value!);

            return ItemAgenceStock(
                stockM: stockM, anim: anim, theKey: snapshot.key!);
          },
        ),
      ],
    );
  }
}
