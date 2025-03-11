import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/cartController.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/productController.dart';
import 'package:mitt_arv_e_commerce_app/Screens/product_detail_screen.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';
import 'package:mitt_arv_e_commerce_app/widgets/button.dart';

class CartScreen extends StatelessWidget {
  final ProductController productController = Get.find();
  final CartController cartController = Get.put(CartController());

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        backgroundColor: Template.button_clr,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20.w),
        ),
        title: Text(
          "My Cart",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () {
          if (cartController.cart.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty.",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.all(10.h),
            child: ListView.builder(
              itemCount: cartController.cart.length,
              itemBuilder: (context, index) {
                var item = cartController.cart[index];

                String title = item['title'] ?? "Unknown Product";
                String imageUrl = item['image'] ?? "";
                log(imageUrl);
                double totalPrice = (item['totalPrice'] ?? 0).toDouble();
                int quantity = (item['quantity'] ?? 1).toInt();

                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Template.button_clr,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5.r,
                        spreadRadius: 1.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Get.to(ProductDetailScreen(Id: item['id'])),
                        child: Container(
                          padding: EdgeInsets.all(8.h),
                          height: 80.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: imageUrl.isNotEmpty
                              ? Image.network(imageUrl, fit: BoxFit.cover)
                              : const Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "₹${totalPrice.toStringAsFixed(2)}",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.white),
                            onPressed: () =>
                                cartController.removeFromCart(item['id']),
                          ),
                          Text(
                            "$quantity",
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: Colors.white),
                            onPressed: () => cartController.addToCart(item),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Obx(() => Container(
            color: Colors.white,
            padding: EdgeInsets.all(15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Price",
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "₹${cartController.totalCartPrice.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: CustomButton(
                    color: Colors.black,
                    textStyle: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    text: "Checkout",
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
