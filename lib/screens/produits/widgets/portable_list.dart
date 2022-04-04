import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/portable_controller.dart';
import '/app/models/portable.dart';
import 'item_portable.dart';

class PortableList extends StatelessWidget {
  const PortableList({
    Key? key,
    required this.portableController,
  }) : super(key: key);

  final PortableController portableController;

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: portableController.queryPortables(),
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
        final portable = Portable.fromJson(snapshot.value!);
        return ItemPortable(portable: portable, anim: anim);
      },
    );
  }
}
