import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/controllers/user_controller.dart';
import '/app/models/user.dart';
import '/screens/employees/components/add_employee.dart';
import '/screens/employees/widgets/item_employee.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          FirebaseAnimatedList(
            query: userController.getEmployee(),
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
              final user = User.fromJson(snapshot.value!);
              return ItemEmployee(user: user, anim: anim);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userController.cleanVar();
          Get.to(() => const AddEmployee());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
