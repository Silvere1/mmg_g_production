import 'package:intl/intl.dart';

final money = NumberFormat("#,##0.0", "fr_FR");

final moneyIn = NumberFormat("#,##0", "fr_FR");

String setMoney(int value) => (value.ceil() == value.floor())
    ? moneyIn.format(value) + " CFA"
    : money.format(value) + " CFA";
