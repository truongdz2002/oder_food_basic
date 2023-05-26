import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecoration {
  static final left010B10Blue10 = [
    BoxShadow(
      offset: const Offset(0, 10),
      blurRadius: 10,
      color: AppColors.blue10,
    )
  ];
  static final right1010B10Blue10 = [
    BoxShadow(
      offset: const Offset(10, 10),
      blurRadius: 10,
      color: AppColors.blue10,
    )
  ];
  static final avatar04B16Blue15 = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 16,
      color: AppColors.blue15,
    )
  ];
  static final scaffold01B10Blue25 = [
    BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: 10,
      color: AppColors.blue25,
    )
  ];
  static final offset04B24Black10 = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 24,
      color: AppColors.black10,
    )
  ];
  static final blue04B24 = [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 24,
      color: AppColors.blue10,
    )
  ];
}
