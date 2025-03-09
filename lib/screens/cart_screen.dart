import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/productController.dart';
import 'package:mitt_arv_e_commerce_app/screens/product_detail_screen.dart';

class CartScreen extends StatelessWidget {
  final ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Obx(
        () {
          if (productController.cart.isEmpty) {
            return const Center(child: Text("Your cart is empty."));
          }

          return ListView.builder(
            itemCount: productController.cart.length,
            itemBuilder: (context, index) {
              var item = productController.cart[index];

              String title = item['title'] ?? "Unknown Product";
              String imageUrl = item['image'] ?? "";
              log(imageUrl);
              double totalPrice = (item['totalPrice'] ?? 0).toDouble();
              int quantity = (item['quantity'] ?? 1).toInt();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            Get.to(ProductDetailScreen(Id: item['id']));
                          },
                          child: Image.network(imageUrl,
                              width: 50, height: 50, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.image_not_supported,
                          size: 50, color: Colors.grey),
                  title:
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text("₹${totalPrice.toStringAsFixed(2)}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () =>
                            productController.removeFromCart(item['id']),
                      ),
                      Text("$quantity"),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () => productController.addToCart(item),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Obx(() => Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "Total: ₹${productController.totalCartPrice.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
