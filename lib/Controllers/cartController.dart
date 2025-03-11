import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';

class CartController extends GetxController {
  var cart = <Map<String, dynamic>>[].obs;

  void addToCart(Map<String, dynamic> product) {
    int index = cart.indexWhere((item) => item['id'] == product['id']);
    if (index != -1) {
      cart[index]['quantity'] += 1;
      cart[index]['totalPrice'] =
          cart[index]['quantity'] * cart[index]['price'];
      cart.refresh();
    } else {
      cart.add({
        'id': product['id'],
        'title': product['title'],
        'price': product['price'],
        'image': product['image'],
        'quantity': 1,
        'totalPrice': product['price'],
      });
      cart.refresh();
    }

    Template.showSnackbar(
      title: "Added to Cart",
      message: "${product['title']} added!",
    );
  }

  void removeFromCart(int id) {
    int index = cart.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      if (cart[index]['quantity'] > 1) {
        cart[index]['quantity'] -= 1;
        cart[index]['totalPrice'] =
            cart[index]['quantity'] * cart[index]['price'];

        Template.showSnackbar(
          title: "Cart Updated",
          message: "Quantity reduced: ${cart[index]['title']}",
          icon: Icons.remove_circle_outline,
          backgroundColor: Colors.orangeAccent,
        );
      } else {
        String removedItem = cart[index]['title'];
        cart.removeAt(index);

        Template.showSnackbar(
          title: "Removed from Cart",
          message: "$removedItem removed from your cart",
          icon: Icons.delete_outline,
          backgroundColor: Colors.redAccent,
        );
      }
      cart.refresh();
    }
  }

  double get totalCartPrice =>
      cart.fold(0, (sum, item) => sum + item['totalPrice']);
}
