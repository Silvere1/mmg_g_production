import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/config/dimensions.dart';
import '/app/controllers/client_controller.dart';
import '/app/utils/formats/mask_formater.dart';
import '/screens/components/entry.dart';
import '/screens/global/widgets/name_or_tel_existe.dart';

class CreateClient extends StatefulWidget {
  const CreateClient({Key? key}) : super(key: key);

  @override
  _CreateClientState createState() => _CreateClientState();
}

class _CreateClientState extends State<CreateClient> {
  ClientsController clientsController = ClientsController.instance;
  bool canDette = false;

  @override
  void initState() {
    super.initState();
    clientsController.clenVar();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter un Client"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Entry(
                text: Text(
                  "Nom & Prénoms",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TextField(
                  onChanged: (value) {
                    clientsController.editingName(value);
                  },
                  inputFormatters: [nameAndNumMaskFormatter],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
              ),
              Entry(
                text: Text(
                  "Téléphone",
                  style: Theme.of(context).textTheme.headline3,
                ),
                editText: TextField(
                  onChanged: (value) {
                    clientsController.editingTel(value);
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                ),
              ),
              Dimensions.y14,
              TextButton(
                onPressed: () {
                  setState(() {
                    canDette = !canDette;
                  });
                },
                child: Row(
                  children: [
                    Checkbox(
                        value: canDette,
                        onChanged: (value) {
                          setState(() {
                            canDette = !canDette;
                          });
                        }),
                    const Text("Eligible aux dettes")
                  ],
                ),
              ),
              Dimensions.y40,
              Obx(
                () => ElevatedButton(
                  onPressed: clientsController.name.value != "" &&
                          clientsController.tel.value != "" &&
                          !clientsController.cirC.value
                      ? () async {
                          await clientsController
                              .createClient(canDette)
                              .then((value) {
                            if (value == false) {
                              nameOrTelExiste();
                            } else {
                              Get.back();
                            }
                          });
                        }
                      : null,
                  child: clientsController.cirC.value
                      ? const CircularProgressIndicator()
                      : const Text("Enregistrer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
