import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';

class SortDropdownMenu extends StatelessWidget {
  final bool check;
  final String? defaultValue;
  final ValueChanged<String?> onchange;

  const SortDropdownMenu({
    super.key,
    required this.check,
    required this.defaultValue,
    required this.onchange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.h),
      height: 40.h,
      width: 250.w,
      decoration: BoxDecoration(
        color: Template.button_clr,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
              blurRadius: 1.r,
              color: Colors.black12,
              offset: const Offset(5, 5),
              spreadRadius: 1.r)
        ],
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.black,
        value: check ? defaultValue : null,
        hint: Text(
          "Sort by",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        isExpanded: true,
        underline: const SizedBox(),
        items: [
          'None',
          'Price: Low to High',
          'Price: High to Low',
          'Rating: High to Low',
          'Buyer Count: High to Low',
        ].map((sortOption) {
          return DropdownMenuItem<String>(
            value: sortOption,
            child: Text(sortOption),
          );
        }).toList(),
        onChanged: onchange,
      ),
    );
  }
}
