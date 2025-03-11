import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Template {
  // ignore: non_constant_identifier_names
  static Color primary_clr = const Color.fromARGB(255, 36, 162, 187);
  // ignore: non_constant_identifier_names
  static Color button_clr = const Color.fromARGB(255, 4, 51, 71);
  static void showSnackbar({
    required String title,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    SnackPosition snackPosition = SnackPosition.TOP,
    Duration duration = const Duration(milliseconds: 700),
    IconData? icon,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      backgroundColor: backgroundColor ?? Template.button_clr.withOpacity(0.7),
      colorText: textColor ?? Colors.white,
      borderRadius: 10.r,
      margin: EdgeInsets.all(10.h),
      duration: duration,
      icon: icon != null ? Icon(icon, color: Colors.white) : null,
    );
  }
}
