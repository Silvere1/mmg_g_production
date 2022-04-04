import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '/app/controllers/menu_controlller.dart';
import '/app/controllers/user_controller.dart';
import '/app/models/title.dart';
import '/res/assets_files.dart';
import '/res/theme/colors/constants.dart';
import '/screens/profile/ui/profile.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    Key? key,
    required this.menuController,
    required this.userController,
  }) : super(key: key);
  final MenuController menuController;
  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: primColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: SvgPicture.asset(MmgAssets.userSecured),
              ),
              arrowColor: Colors.transparent,
              onDetailsPressed: () {
                Get.back();
                Get.to(() => const Profile());
              },
              accountName: Text(userController.user!.fullName),
              accountEmail: Text("${userController.user!.tel}")),
          ...adminTitles
              .map(
                (e) => Container(
                  margin: const EdgeInsets.only(right: 8, bottom: 4),
                  child: Material(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: e.select ? Colors.white : Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        menuController.onChangeMenu(
                            e, adminTitles.indexOf(e), true);
                        Get.back();
                      },
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: SvgPicture.asset(
                                e.select ? e.icA : e.ic,
                                color: e.select ? null : Colors.black45,
                                height: 24,
                              ),
                            ),
                            Text(
                              e.title,
                              style: e.select
                                  ? TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: primColor)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
