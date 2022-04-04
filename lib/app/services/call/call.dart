import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class Call {
  phone(String num) async {
    final tel = "tel:" + num;
    if (await canLaunch(tel)) {
      await launch(tel);
    } else {
      throw 'Could not launch $num';
    }
  }

  openWhatsapp(String whatsapp) async {
    var ios = "whatsapp://send?phone=" + whatsapp + "&text=";
    var android = "https://wa.me/$whatsapp?text=${Uri.parse("")}";
    if (Platform.isAndroid) {
      // for iOS phone only
      // if (await canLaunch(android)) {
      await launch(android);
      //  }
    } else {
      // android , web
      if (await canLaunch(ios)) {
        await launch(ios);
      }
    }
  }
}
