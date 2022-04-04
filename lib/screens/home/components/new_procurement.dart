import 'package:flutter/material.dart';

import '/screens/procurements/ui/procuremments.dart';

class NewProcurement extends StatefulWidget {
  const NewProcurement({Key? key}) : super(key: key);

  @override
  State<NewProcurement> createState() => _NewProcurementState();
}

class _NewProcurementState extends State<NewProcurement> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Approvisionnements"),
        ),
        body: const Procurements(),
      ),
    );
  }
}
