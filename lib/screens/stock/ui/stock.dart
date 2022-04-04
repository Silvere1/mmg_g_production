import 'package:flutter/material.dart';

import '/res/theme/colors/constants.dart';
import '/screens/stock/ui/agence_stock_admin.dart';
import '/screens/stock/ui/global_stock.dart';

class Stock extends StatefulWidget {
  const Stock({Key? key}) : super(key: key);

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  final _tab = const <Tab>[
    Tab(text: "Global"),
    Tab(text: "Par Magasin"),
  ];

  final _tabPages = const <Widget>[
    GlobalStock(),
    AgenceStockAdmin(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1.5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: Theme.of(context).primaryColor,
                  child: TabBar(
                    tabs: _tab,
                    physics: const NeverScrollableScrollPhysics(),
                    indicatorColor: backGround,
                    indicatorWeight: 6,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: _tabPages,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
