import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/authController.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/productController.dart';
import 'package:mitt_arv_e_commerce_app/Screens/cart_screen.dart';
import 'package:mitt_arv_e_commerce_app/Screens/product_detail_screen.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';
import 'package:mitt_arv_e_commerce_app/widgets/filter_bottom_sheet.dart';
import 'package:mitt_arv_e_commerce_app/widgets/search_bar.dart';
import 'package:mitt_arv_e_commerce_app/widgets/sort_dropdownMenu.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ProductController productController = Get.put(ProductController());
  final Authcontroller authcontroller = Get.put(Authcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GestureDetector(
            onTap: () => authcontroller.signout(),
            child: SizedBox(
              child: Row(
                children: [
                  Text(
                    "Log-out",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  const Icon(Icons.logout_outlined)
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Template.button_clr,
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
        child: RefreshIndicator(
          backgroundColor: Template.button_clr,
          color: Colors.white,
          onRefresh: () async {
            productController.getAllProducts();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Obx(
                  () => SearchBarWidget(
                    searchcontroller: productController.searchController,
                    onChange: (query) {
                      productController.searchProducts(query);
                    },
                    suffixCheck: productController.searchQuery.isNotEmpty,
                    onClickForIcon: () {
                      productController.clearSearch();
                    },
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Template.button_clr,
                      child: IconButton(
                        icon: const Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () {
                          FilterBottomSheet.show(context);
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Obx(
                      () => SortDropdownMenu(
                        check: productController
                            .selectedSortOption.value.isNotEmpty,
                        defaultValue:
                            productController.selectedSortOption.value,
                        onchange: (newValue) async {
                          if (newValue != null) {
                            if (newValue == 'None') {
                              productController
                                  .resetSort(); // Call reset function
                            } else {
                              productController.sortProducts(newValue);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Expanded(
                  child: Obx(() {
                    if (productController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Template.button_clr,
                        ),
                      );
                    }

                    var products = productController.filteredProducts;
                    // log(products.toString());
                    if (products.isEmpty) {
                      return Center(
                        child: Text(
                          "No products available",
                          style: GoogleFonts.inter(
                            color: Colors.black54,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        var product = products[index];

                        int productId =
                            int.tryParse(product["id"].toString()) ??
                                product["id"];
                        double rating = (product['rating']['rate'] is int)
                            ? (product['rating']['rate'] as int).toDouble()
                            : (product['rating']['rate'] is double)
                                ? product['rating']['rate']
                                : double.tryParse(
                                        product['rating']['rate'].toString()) ??
                                    0.0;

                        return GestureDetector(
                          onTap: () {
                            Get.to(ProductDetailScreen(Id: productId));
                            log("Product ID Type: ${productId.runtimeType}");
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 145.h,
                                  width: 150.w,
                                  decoration: BoxDecoration(
                                    color: Template.button_clr,
                                    borderRadius: BorderRadius.circular(8.r),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 1.r,
                                        color: Colors.black12,
                                        offset: const Offset(5, 5),
                                        spreadRadius: 1.r,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Image.network(
                                      product["image"],
                                      height: 100.h,
                                      width: 100.w,
                                      fit: BoxFit.contain,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                SizedBox(height: 5.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: Text(
                                            product["title"],
                                            style: GoogleFonts.inter(
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Text("⭐ $rating"),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "₹ ${product["price"].toString()}",
                                      style: GoogleFonts.inter(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
