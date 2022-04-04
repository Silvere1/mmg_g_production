import 'package:get/get.dart';

import '../../controllers/menu_controlller.dart';
import '../../controllers/network_controller.dart';
import 'app_service.dart';

Future<void> initServices() async {
  await Get.putAsync(() => AppServices().init());
  Get.put(MenuController());
  Get.put(NetworkController());
}
