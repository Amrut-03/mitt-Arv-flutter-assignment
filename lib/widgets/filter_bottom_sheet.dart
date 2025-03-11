import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/productController.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';

class FilterBottomSheet {
  static void show(BuildContext context) {
    final ProductController productController = Get.find();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(15.h),
        decoration: BoxDecoration(
          color: Template.button_clr,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              /// **Category Filter**
              Text(
                "Category",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 10.w,
                runSpacing: 8.h,
                children: [
                  "Electronics",
                  "Jewelery",
                  "Men's Clothing",
                  "Women's Clothing"
                ]
                    .map((category) => Obx(() => FilterChip(
                          label: Text(
                            category,
                            style: GoogleFonts.inter(
                              color: productController.selectedCategories
                                      .contains(category)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          selected: productController.selectedCategories
                              .contains(category),
                          selectedColor: Colors.black,
                          checkmarkColor: Colors.white,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(color: Colors.black, width: 1.w),
                          ),
                          onSelected: (isSelected) {
                            if (isSelected) {
                              productController.selectedCategories
                                  .add(category);
                            } else {
                              productController.selectedCategories
                                  .remove(category);
                            }
                            productController.applyFilters();
                          },
                        )))
                    .toList(),
              ),
              SizedBox(height: 10.h),

              /// **Price Filter (With Checkbox)**
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: productController.isPriceFilterEnabled.value,
                            onChanged: (value) {
                              productController.isPriceFilterEnabled.value =
                                  value!;
                            },
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                          ),
                          Text(
                            "Price Range: ₹${productController.minPrice.value} - ₹${productController.maxPrice.value}",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (productController.isPriceFilterEnabled.value)
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            valueIndicatorColor: Colors.white,
                            valueIndicatorTextStyle: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                            thumbColor: Colors.white,
                            overlayColor: Colors.black.withOpacity(0.2),
                          ),
                          child: RangeSlider(
                            values: RangeValues(
                              double.tryParse(
                                      productController.minPrice.value) ??
                                  1,
                              double.tryParse(
                                      productController.maxPrice.value) ??
                                  1000,
                            ),
                            min: 1,
                            max: 1000,
                            divisions: 100,
                            labels: RangeLabels(
                              "₹${productController.minPrice.value}",
                              "₹${productController.maxPrice.value}",
                            ),
                            onChanged: (RangeValues values) {
                              productController.minPrice.value =
                                  values.start.toStringAsFixed(0);
                              productController.maxPrice.value =
                                  values.end.toStringAsFixed(0);
                            },
                          ),
                        ),
                    ],
                  )),
              SizedBox(height: 10.h),

              /// **Rating Filter (With Checkbox & Fixed Slider)**
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: productController.isRatingFilterEnabled.value,
                          onChanged: (value) {
                            productController.isRatingFilterEnabled.value =
                                value!;
                          },
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                        ),
                        Text(
                          "Minimum Rating: ${productController.maxRating.value}",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (productController.isRatingFilterEnabled.value)
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          valueIndicatorColor: Colors.white,
                          valueIndicatorTextStyle: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          thumbColor: Colors.white,
                          overlayColor: Colors.black.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: double.tryParse(
                                  productController.maxRating.value) ??
                              1.0,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          label: productController.maxRating.value.toString(),
                          onChanged: (value) {
                            productController.maxRating.value =
                                value.toStringAsFixed(1);
                            log(productController.maxRating.value);
                          },
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              /// **Action Buttons**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Template.button_clr,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      productController.resetFilters();
                      Get.back();
                    },
                    child: Text(
                      "Reset",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Template.button_clr,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      "Apply",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      await productController.applyFilters();
                      Get.back();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
