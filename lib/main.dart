import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/app/controllers/agence_controller.dart';
import '/app/controllers/appro_controller.dart';
import '/app/controllers/article_controller.dart';
import '/app/controllers/client_controller.dart';
import '/app/controllers/portable_controller.dart';
import '/app/controllers/stock_controller.dart';
import '/app/controllers/user_controller.dart';
import '/app/controllers/vente_controller.dart';
import '/app/services/app_services/app_service.dart';
import '/app/services/app_services/init_services.dart';
import '/res/theme/theme.dart';
import '/screens/home/ui/home.dart';
import '/screens/intro/intro.dart';
import '/screens/login/ui/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseDatabase.instance.setPersistenceEnabled(true);
  await FirebaseAppCheck.instance.activate();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppServices appServices = AppServices.instance;

    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(1080, 1920),
      builder: () => GetMaterialApp(
        title: 'MMG GN',
        theme: buildLightThemeData(),
        locale: const Locale("fr"),
        fallbackLocale: const Locale("fr"),
        supportedLocales: const [Locale("fr")],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        defaultTransition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        home: !appServices.intro.value
            ? const Intro()
            : appServices.hasUser.value
                ? Home(user: appServices.user!)
                : const Login(),
        initialBinding: BindingsBuilder(() {
          Get.put(UserController());
          Get.put(StockController());
          Get.put(PortableController());
          Get.put(AgenceController());
          Get.put(ArticleController());
          Get.put(VenteController());
          Get.put(ClientsController());
          Get.put(ApproController());
        }),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
