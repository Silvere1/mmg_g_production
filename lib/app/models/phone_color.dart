import 'package:flutter/cupertino.dart';

///Cyan => 2bfafa
///Wave => 6591c9
///Black => 000000
///Gold => ffd700
///Grey => 606060
///White => ffffff
///Blue => 0080ff
///Green => 008000
///Red => ff0000
///Pink => ffc0cb
///Gray => 808080
///Polar night => 4f4539
///Orange => ff7f00
///Sky => 87ceeb

class PhoneColor {
  String title;
  Color color;
  PhoneColor({required this.title, required this.color});
}

List<PhoneColor> phoneColors = [
  PhoneColor(
    title: "Black",
    color: const Color(0xff000000),
  ),
  PhoneColor(
    title: "Grey",
    color: const Color(0xff606060),
  ),
  PhoneColor(
    title: "Gray",
    color: const Color(0xff808080),
  ),
  PhoneColor(
    title: "White",
    color: const Color(0xffffffff),
  ),
  PhoneColor(
    title: "Blue",
    color: const Color(0xff0080ff),
  ),
  PhoneColor(
    title: "Cyan",
    color: const Color(0xff2bfafa),
  ),
  PhoneColor(
    title: "Wave",
    color: const Color(0xff6591c9),
  ),
  PhoneColor(
    title: "Gold",
    color: const Color(0xffffd700),
  ),
  PhoneColor(
    title: "Green",
    color: const Color(0xff008000),
  ),
  PhoneColor(
    title: "Red",
    color: const Color(0xffff0000),
  ),
  PhoneColor(
    title: "Pink",
    color: const Color(0xffffc0cb),
  ),
  PhoneColor(
    title: "Orange",
    color: const Color(0xffff7f00),
  ),
  PhoneColor(
    title: "Sky",
    color: const Color(0xff87ceeb),
  ),
  PhoneColor(
    title: "Polar Night",
    color: const Color(0xff4f4539),
  ),
];

Color getPhoneColor(String str) {
  return phoneColors.firstWhere((e) => e.title == str).color;
}
