import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/productController.dart';
import 'package:mitt_arv_e_commerce_app/screens/cart_screen.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';
import 'package:mitt_arv_e_commerce_app/widgets/button.dart';

class ProductDetailScreen extends StatefulWidget {
  final int Id;
  ProductDetailScreen({super.key, required this.Id});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductController productController = Get.put(ProductController());

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
            child: IconButton(
              icon: Icon(Icons.shopping_cart, color: Template.button_clr),
              onPressed: () => Get.to(() => CartScreen()),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 20.h),
          child: SingleChildScrollView(
            child: Obx(() {
              var product = productController.product.value;
              log(product.toString());

              if (product == null) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle potential null values safely
              double rating = product['rating']?['rate']?.toDouble() ?? 0.0;
              int ratingCount = product['rating']?['count'] ?? 0;
              double price = product['price']?.toDouble() ?? 0.0;
              String imageUrl = product['image'] ?? '';
              String title = product['title'] ?? 'No Title';
              String description = product['description'] ?? 'No Description';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.network(
                        imageUrl,
                        height: 500.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        "₹ ${price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: rating,
                        itemBuilder: (context, index) =>
                            const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 20,
                      ),
                      Text(" ($ratingCount)"),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Text(description),
                  SizedBox(height: 15.h),
                  Text(
                    "Reviews",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15.h),
                  _buildReviewSection(),
                ],
              );
            }),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
        child: CustomButton(
          text: "Add to Cart",
          onPressed: () {
            var product = productController.product.value;
            if (product != null) {
              productController.addToCart({
                'id': product['id'],
                'title': product['title'],
                'price': product['price'],
                'image': product['image'],
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    return SizedBox(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 10.h),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.h),
                    const Text(
                      "Amrut Khochikar",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBarIndicator(
                          rating: 4,
                          itemBuilder: (context, index) =>
                              const Icon(Icons.star, color: Colors.amber),
                          itemCount: 5,
                          itemSize: 18,
                        ),
                        const Text("29-06-2024"),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                      style: TextStyle(fontSize: 15.sp, color: Colors.black),
                    ),
                  ],
                ),
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
    );
  }
}
