import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/agence_controller.dart';
import '/app/models/agence.dart';
import '/screens/magasins/components/add_magasin.dart';
import '/screens/magasins/widgets/item_magasin.dart';

class Magasins extends StatefulWidget {
  const Magasins({Key? key, this.select = false}) : super(key: key);
  final bool? select;
  @override
  _MagasinsState createState() => _MagasinsState();
}

class _MagasinsState extends State<Magasins> {
  AgenceController agenceController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          FirebaseAnimatedList(
            query: agenceController.queryAgences(),
            reverse: true,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            defaultChild: SizedBox(
              height: Get.height * .9,
              child: const Center(child: CircularProgressIndicator()),
            ),
            duration: const Duration(seconds: 1),
            itemBuilder: (_, snapshot, anim, i) {
              if (kDebugMode) {
                print(snapshot.value);
              }
              final agence = Agence.fromJson(snapshot.value!);
              return ItemMagasin(
                  agence: agence, anim: anim, select: widget.select!);
            },
          ),
        ],
      ),
      floatingActionButton: widget.select == false
          ? FloatingActionButton(
              onPressed: () async {
                await agenceController.cleanVar();
                showDialog(
                    context: context,
                    builder: (_) => buildAddMagasin(_, agenceController));
              },
              child: const Icon(Icons.add),
            )
          : const SizedBox(),
    );
  }
}
