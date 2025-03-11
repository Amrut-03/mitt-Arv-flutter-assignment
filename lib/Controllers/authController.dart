import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mitt_arv_e_commerce_app/Screens/Auth/signin_screen.dart';
import 'package:mitt_arv_e_commerce_app/Utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mitt_arv_e_commerce_app/Screens/home_screen.dart';

class Authcontroller extends GetxController {
  var isLoading = false.obs;

  Future<void> signin({required String name, required String password}) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));

      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
          'POST', Uri.parse('https://fakestoreapi.com/auth/login'));
      request.bodyFields = {'username': name, 'password': password};
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        log(responseBody);

        var token =
            responseBody.split(':')[1].replaceAll('"', '').replaceAll('}', '');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        Template.showSnackbar(
          title: "Success",
          message: "Login successful!",
          icon: Icons.check_circle,
        );
        Get.offAll(() => HomeScreen());
      } else {
        log("Login failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Template.showSnackbar(
      title: "Success",
      message: "Log-out successful!",
      icon: Icons.check_circle,
    );
    Get.offAll(() => const SigninScreen());
  }

  Future<bool> isTokenValid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    return token != null;
  }

  var userData = Rxn<Map<String, dynamic>>();
  Future<void> decodeToken() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token');
    if (token == null || token.isEmpty) {
      log("Token is missing");
      userData.value = null;
      return;
    }
    final decodedToken = JwtDecoder.decode(token);
    log("Token decoded successfully: $decodedToken");
    log(userData.value!['id']);

    userData.value = decodedToken;
  }

  var obscureText = true.obs;
  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }
}
