import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/res/assets_files.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        /*Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),*/
        SvgPicture.asset(
          MmgAssets.pieChart,
          height: size,
          color: color,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
