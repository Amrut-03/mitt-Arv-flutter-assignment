import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.onToggleObscure,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.ubuntu(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: Colors.black26, width: 2.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.w),
            borderRadius: BorderRadius.circular(10.r),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
          contentPadding:
              EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        ),
      ),
    );
  }
}
