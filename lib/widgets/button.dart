import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color? iconColor;

  CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Template.button_clr,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle ??
              TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
        ),
      ),
    );
  }
}
