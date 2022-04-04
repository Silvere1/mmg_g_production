import 'package:intl/intl.dart';

DateFormat get date => DateFormat.yMMMMEEEEd("fr").add_Hm();
DateFormat get jour => DateFormat.yMMMMEEEEd("fr");
DateFormat get jours => DateFormat.yMMMMEEEEd("fr");

extension GetOnlyDate on DateTime {
  DateTime onlyDate() => DateTime(year, month, day);
}

/// abbreviation

extension CompareOnlyDate on DateTime {
  bool isSameDate(DateTime other) =>
      (year == other.year && month == other.month && day == other.day);
}

extension DiffOnlyDay on DateTime {
  int difOnlyDay(DateTime other) => DateTime(year, month, day)
      .difference(DateTime(other.year, other.month, other.day))
      .inDays;
}
