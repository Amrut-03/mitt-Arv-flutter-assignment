import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mitt_arv_e_commerce_app/Utils/constant.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchcontroller;
  final ValueChanged<String> onChange;
  final bool suffixCheck;
  final VoidCallback onClickForIcon;

  const SearchBarWidget({
    super.key,
    required this.searchcontroller,
    required this.onChange,
    required this.suffixCheck,
    required this.onClickForIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.black,
      onChanged: onChange,
      controller: searchcontroller,
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: suffixCheck
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.black),
                onPressed: onClickForIcon,
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Template.button_clr, width: 2.w),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      ),
    );
  }
}
