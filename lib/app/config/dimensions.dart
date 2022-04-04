import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimensions {
  /// Use these widgets for space along X-Axis (for width)
  static Widget x0 = SizedBox(width: 0.5.w);
  static Widget x1 = SizedBox(width: 1.0.w);
  static Widget x2 = SizedBox(width: 2.0.w);
  static Widget x3 = SizedBox(width: 3.0.w);
  static Widget x4 = SizedBox(width: 4.0.w);
  static Widget x5 = SizedBox(width: 5.0.w);
  static Widget x6 = SizedBox(width: 6.0.w);
  static Widget x7 = SizedBox(width: 7.0.w);
  static Widget x8 = SizedBox(width: 8.0.w);
  static Widget x9 = SizedBox(width: 9.0.w);
  static Widget x10 = SizedBox(width: 10.0.w);
  static Widget x16 = SizedBox(width: 16.0.w);

  /// User these widgets for space along Y-Axis (for height)
  static Widget y0 = SizedBox(height: 0.5.h);
  static Widget y1 = SizedBox(height: 1.0.h);
  static Widget y2 = SizedBox(height: 2.0.h);
  static Widget y3 = SizedBox(height: 3.0.h);
  static Widget y4 = SizedBox(height: 4.0.h);
  static Widget y5 = SizedBox(height: 5.0.h);
  static Widget y6 = SizedBox(height: 6.0.h);
  static Widget y7 = SizedBox(height: 7.0.h);
  static Widget y8 = SizedBox(height: 8.0.h);
  static Widget y9 = SizedBox(height: 9.0.h);
  static Widget y10 = SizedBox(height: 10.0.h);
  static Widget y14 = SizedBox(height: 14.0.h);
  static Widget y28 = SizedBox(height: 28.0.h);
  static Widget y36 = SizedBox(height: 36.0.h);
  static Widget y40 = SizedBox(height: 40.0.h);
  static Widget y46 = SizedBox(height: 46.0.h);
  static Widget y52 = SizedBox(height: 52.0.h);

  static Widget y1_0 = SizedBox(height: 1.5.h);
  static Widget y2_0 = SizedBox(height: 2.5.h);

  /// [y10] Margin values from top of the status bar to the first element
  /// Use this value when there is no action bar like in Language selection screen

  /// Use this when there is action bar like home screens
  static final topMarginWithActionBar = 4.0.h;
  static final defaultHorizontalPadding = 5.0.w;

  static EdgeInsets getHoriPadding() {
    return EdgeInsets.symmetric(horizontal: defaultHorizontalPadding);
  }

  static Widget getCustomeHeight(num value) {
    return SizedBox(
      height: value.h,
    );
  }

  static Widget getCustomeWidth(num value) {
    return SizedBox(
      width: value.w,
    );
  }

  static double normX(double x) => x.w;

  static double normY(double y) => y.h;

  static double normSP(double unit) => unit.sp;
}
