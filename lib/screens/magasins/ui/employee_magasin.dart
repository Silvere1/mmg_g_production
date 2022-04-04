import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/models/user.dart';
import '/app/services/call/call.dart';
import '/res/assets_files.dart';

class EmployeeMagasin extends StatelessWidget {
  const EmployeeMagasin({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 34,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  MmgAssets.realAgent,
                  height: 36,
                ),
              ),
            ),
            Text(
              user.fullName,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text("+229 ${user.tel}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        Call().phone(user.tel.toString());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          MmgAssets.icPhone,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        Call().openWhatsapp(user.tel.toString());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          MmgAssets.icWhatsapp,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
