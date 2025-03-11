import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/cartController.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/productController.dart';
import 'package:mitt_arv_e_commerce_app/Screens/cart_screen.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';
import 'package:mitt_arv_e_commerce_app/widgets/button.dart';
import 'package:mitt_arv_e_commerce_app/widgets/reviews.dart';

class ProductDetailScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final int Id;
  // ignore: non_constant_identifier_names
  const ProductDetailScreen({super.key, required this.Id});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    productController.getSingleProduct(widget.Id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Template.button_clr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.w),
        ),
        title: Text(
          "E-Commerce App",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () => Get.to(() => CartScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            var product = productController.product.value;
            log(product.toString());

            if (product == null) {
              return Center(
                  child: CircularProgressIndicator(
                color: Template.button_clr,
              ));
            }

            double rating = product['rating']?['rate']?.toDouble() ?? 0.0;
            int ratingCount = product['rating']?['count'] ?? 0;
            String imageUrl = product['image'] ?? '';
            String title = product['title'] ?? 'No Title';
            String description = product['description'] ?? 'No Description';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(20.h),
                  child: Container(
                    height: 400.h,
                    width: 400.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Template.button_clr,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.h),
                  color: Template.button_clr,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: rating,
                            unratedColor: Colors.white,
                            itemBuilder: (context, index) =>
                                const Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 20,
                          ),
                          Text(
                            " ($ratingCount)",
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        "Reviews",
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      const Reviews(),
                      SizedBox(height: 15.h),
                      const Reviews(),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.all(15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () {
                var product = productController.product.value;
                double price = (product?['price']?.toDouble() ?? 0.0);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Price",
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "₹${price.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: CustomButton(
                color: Colors.black,
                textStyle: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                text: "Add to Cart",
                onPressed: () {
                  var product = productController.product.value;
                  if (product != null) {
                    cartController.addToCart({
                      'id': product['id'],
                      'title': product['title'],
                      'price': product['price'],
                      'image': product['image'],
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
