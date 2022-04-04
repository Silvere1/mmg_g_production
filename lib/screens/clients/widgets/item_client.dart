import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/models/client.dart';
import '/res/assets_files.dart';
import '/screens/clients/ui/edit_client.dart';

class ItemClient extends StatelessWidget {
  const ItemClient({Key? key, required this.client, required this.anim})
      : super(key: key);
  final Client client;
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: anim,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Get.to(() => EditClient(client: client));
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffffdcd8),
                        ),
                        child: SvgPicture.asset(
                          MmgAssets.client,
                          height: 35,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            client.fullName!,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                spacing: 14,
                                children: [
                                  Text(client.tel!),
                                  if (client.solde < 0)
                                    Text(
                                      "En dette",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(color: Colors.red),
                                    )
                                ],
                              ),
                              if (client.canDette)
                                SvgPicture.asset(
                                  MmgAssets.garanti,
                                  height: 22,
                                )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
