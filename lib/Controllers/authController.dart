import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mitt_arv_e_commerce_app/screens/Auth/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mitt_arv_e_commerce_app/screens/home_screen.dart';

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

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Get.offAll(() => SigninScreen());
  }

  var obscureText = true.obs; // ✅ Make sure it's an observable

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }
}
