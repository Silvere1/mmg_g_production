import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Attention",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text("Vous serez déconnecté !"),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text("Non")),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text("Oui")),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
