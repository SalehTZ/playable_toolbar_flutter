import 'package:flutter/animation.dart';

class Constants {
  static const Duration longPressAnimationDuration =
      Duration(milliseconds: 400);
  static const Duration scrollScaleAnimationDuration =
      Duration(milliseconds: 700);

  static const Curve longPressAnimationCurve = Curves.easeOutSine;
  static const Curve scrollScaleAnimationCurve = Curves.ease;
}
