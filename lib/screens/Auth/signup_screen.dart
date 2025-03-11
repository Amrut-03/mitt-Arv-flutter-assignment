// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mitt_arv_e_commerce_app/Screens/home_screen.dart';
import 'package:mitt_arv_e_commerce_app/widgets/button.dart';
import 'package:mitt_arv_e_commerce_app/widgets/textfield.dart';

// ignore: must_be_immutable
class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController phone_number_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Create Account",
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  "Fill your information below or register with your social account.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Colors.black54,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              CustomTextField(
                labelText: "Name",
                controller: name_controller,
              ),
              CustomTextField(
                labelText: "Email",
                controller: email_controller,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                labelText: "Phone Number",
                controller: phone_number_controller,
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                obscureText: true,
                labelText: "Password",
                controller: password_controller,
              ),
              SizedBox(
                height: 40.h,
              ),
              CustomButton(
                text: "Sign-up",
                onPressed: () {
                  Get.to(() => HomeScreen());
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
