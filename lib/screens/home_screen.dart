import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/authController.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/productController.dart';
import 'package:mitt_arv_e_commerce_app/screens/cart_screen.dart';
import 'package:mitt_arv_e_commerce_app/screens/product_detail_screen.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';

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
        child: TextButton(
          onPressed: () {
            authcontroller.logout();
          },
          child: Text("Log-out"),
        ),
      ),
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, color: Template.button_clr),
              onPressed: () => Get.to(() => CartScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Obx(
                () => TextField(
                  onChanged: (value) =>
                      productController.updateSearchQuery(value),
                  controller: TextEditingController(
                      text: productController.searchQuery.value)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(
                          offset: productController.searchQuery.value.length),
                    ),
                  decoration: InputDecoration(
                    hintText: "Search items...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: productController.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              productController.updateSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => SizedBox(
                        width: 200.w,
                        child: DropdownButton<String>(
                          value: productController
                                  .selectedSortOption.value.isNotEmpty
                              ? productController.selectedSortOption.value
                              : null,
                          hint: const Text("Sort by"),
                          isExpanded: true,
                          items: [
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
                          onChanged: (newValue) {
                            if (newValue != null) {
                              productController.sortProducts(newValue);
                              // productController.getAllProducts();
                            }
                          },
                        ),
                      )),
                  SizedBox(width: 10.w),
                  IconButton(
                    icon: Icon(Icons.filter_alt),
                    onPressed: () {
                      _showFilterDialog(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: Obx(() {
                  if (productController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var products = productController.filteredProducts;

                  if (products.isEmpty) {
                    return Center(child: Text("No products available"));
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];

                      int productId = int.tryParse(product["id"].toString()) ??
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
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12.r)),
                                child: Image.network(
                                  product["image"],
                                  height: 100.h,
                                  width: 100.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 200.w,
                                      child: Text(
                                        product["title"],
                                        style: GoogleFonts.ubuntu(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    RatingBarIndicator(
                                      rating: rating,
                                      itemBuilder: (context, index) =>
                                          Icon(Icons.star, color: Colors.amber),
                                      itemCount: 5,
                                      itemSize: 18,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "₹ ${product["price"].toString()}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
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
    );
  }

  var minPrice = "1".obs;
  var maxPrice = "1000".obs;
  var minRating = "1".obs;

  void _showFilterDialog(BuildContext context) {
    final ProductController productController = Get.find();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Filter Products"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category Filter
              Text("Category"),
              Wrap(
                children: [
                  "electronics",
                  "jewelery",
                  "men's clothing",
                  "women's clothing"
                ]
                    .map((category) => Obx(() => FilterChip(
                          label: Text(category),
                          selected: productController.selectedCategories
                              .contains(category),
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

              SizedBox(height: 10),

              // Price Range Slider
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Price Range: ₹${productController.minPrice.value} - ₹${productController.maxPrice.value}"),
                      RangeSlider(
                        values: RangeValues(
                          double.tryParse(productController.minPrice.value) ??
                              1,
                          double.tryParse(productController.maxPrice.value) ??
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
                    ],
                  )),

              SizedBox(height: 10),

// Rating Slider
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Minimum Rating: ${productController.minRating.value}"),
                      Slider(
                        value: double.tryParse(
                                productController.minRating.value) ??
                            1,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: productController.minRating.value,
                        onChanged: (value) {
                          productController.minRating.value =
                              value.toStringAsFixed(1);
                        },
                      ),
                    ],
                  )),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Reset"),
              onPressed: () {
                productController.resetFilters();
                Get.back();
              },
            ),
            TextButton(
              child: Text("Apply"),
              onPressed: () {
                productController.applyFilters();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
