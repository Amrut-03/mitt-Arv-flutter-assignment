import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/productController.dart';

class CartScreen extends StatelessWidget {
  final ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Obx(() {
        if (productController.cart.isEmpty) {
          return Center(child: Text("Your cart is empty."));
        }

        return ListView.builder(
          itemCount: productController.cart.length,
          itemBuilder: (context, index) {
            var item = productController.cart[index];
            return ListTile(
              title: Text(item['title']),
              subtitle:
                  Text("₹${item['totalPrice']} (Qty: ${item['quantity']})"),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => productController.removeFromCart(item['id']),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() => Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Total: ₹${productController.totalCartPrice}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
