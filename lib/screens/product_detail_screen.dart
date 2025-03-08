import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/productController.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';
import 'package:mitt_arv_e_commerce_app/widgets/button.dart';

class ProductDetailScreen extends StatefulWidget {
  var Id;
  ProductDetailScreen({super.key, required this.Id});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    productController.getSingleProduct(widget.Id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: Template.button_clr),
        actions: [
          Padding(
            padding: EdgeInsets.all(15.h),
            child: Icon(
              Icons.shopping_cart,
              size: 25.w,
              color: Template.button_clr,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 20.h),
          child: SingleChildScrollView(child: Obx(() {
            var product = productController.product.value;
            log(product.toString());
            if (product == null) {
              return const Center(child: CircularProgressIndicator());
            }
            double rating = (product['rating']['rate'] is int)
                ? (product['rating']['rate'] as int).toDouble()
                : (product['rating']['rate'] is double)
                    ? product['rating']['rate']
                    : double.tryParse(product['rating']['rate'].toString()) ??
                        0.0;
            double price = (product['price'] is int)
                ? (product['price'] as int).toDouble()
                : (product['price'] is double)
                    ? product['price']
                    : double.tryParse(product['price'].toString()) ?? 0.0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.network(
                      product["image"],
                      height: 500.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        product["title"],
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.visible, // Allow text to wrap
                        maxLines: 2, // Optional: Limit the text to 2 lines
                      ),
                    ),
                    Text(
                      "₹ ${price.toString()}",
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: rating,
                      itemBuilder: (context, index) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 20,
                    ),
                    Text("(${product["rating"]["count"].toString()})")
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(product["description"]),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "Reviews",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, left: 10.h),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    const Text(
                                      "Amrut Khochikar",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RatingBarIndicator(
                                          rating: 4,
                                          itemBuilder: (context, index) =>
                                              const Icon(Icons.star,
                                                  color: Colors.amber),
                                          itemCount: 5,
                                          itemSize: 18,
                                        ),
                                        const Text("29-06-2024")
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                                      style: TextStyle(
                                          fontSize: 15.sp, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          })),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
        child: CustomButton(text: "Add to Cart", onPressed: () {}),
      ),
    );
  }
}
