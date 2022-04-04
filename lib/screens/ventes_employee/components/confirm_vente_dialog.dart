import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmVenteDialog extends StatelessWidget {
  const ConfirmVenteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        //color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Valider la vente",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Êtes-vous sûr ?"),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text("Non"),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text("Oui"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
