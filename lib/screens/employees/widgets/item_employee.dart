import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '/app/models/user.dart';
import '/res/assets_files.dart';
import '/screens/employees/components/banned_employee.dart';
import '/screens/employees/components/delete_employee.dart';
import '/screens/employees/ui/employee_infos.dart';

class ItemEmployee extends StatelessWidget {
  const ItemEmployee({Key? key, required this.user, required this.anim})
      : super(key: key);
  final User user;
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
                Get.to(() => EmployeeInfos(user: user));
              },
              onLongPress: () async {
                if (user.agenceId == null) {
                  showDialog(
                      context: context,
                      builder: (_) => DeleteEmployee(user: user));
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => BannedEmployee(user: user));
                }
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
                          MmgAssets.employee,
                          height: 35,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            user.fullName,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("Tel : +229 ${user.tel}"),
                              if (user.agenceId != null)
                                SvgPicture.asset(
                                  MmgAssets.realAgent,
                                  height: 20,
                                ),
                            ],
                          ),
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
