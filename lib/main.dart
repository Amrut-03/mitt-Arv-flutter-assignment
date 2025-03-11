import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/authController.dart';
import 'package:mitt_arv_e_commerce_app/Screens/Auth/signin_screen.dart';
import 'package:mitt_arv_e_commerce_app/Screens/home_screen.dart';
import 'package:mitt_arv_e_commerce_app/Utils/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 868),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: FutureBuilder<bool>(
            future: Authcontroller().isTokenValid(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Center(
                        child: CircularProgressIndicator(
                  color: Template.button_clr,
                )));
              } else if (snapshot.hasData && snapshot.data == true) {
                return HomeScreen();
              } else {
                return const SigninScreen();
              }
            },
          ),
        );
      },
    );
  }
}
