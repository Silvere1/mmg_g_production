import 'package:flutter/material.dart';

import '/screens/magasins/ui/magasins.dart';

class SelectMagasin extends StatelessWidget {
  const SelectMagasin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sélectionner un Magasin"),
        ),
        body: const Magasins(select: true),
      ),
    );
  }
}
