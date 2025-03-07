import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mitt_arv_e_commerce_app/screens/Auth/signin.dart';
import 'package:mitt_arv_e_commerce_app/screens/home_screen.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';
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
      backgroundColor: Template.background_clr,
      appBar: AppBar(
        backgroundColor: Template.background_clr,
        // iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sign Up",
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomTextField(
              labelText: "Name",
              controller: email_controller,
            ),
            CustomTextField(
              labelText: "Email",
              controller: email_controller,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              labelText: "Phone Number",
              controller: email_controller,
              keyboardType: TextInputType.number,
            ),
            CustomTextField(
              labelText: "Password",
              controller: password_controller,
              obscureText: true,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.to(SigninScreen());
                  },
                  child: Text(
                    "Alredy have an account?",
                    textAlign: TextAlign.end,
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 15.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            CustomButton(
                text: "Sign-up",
                onPressed: () {
                  Get.to(const HomeScreen());
                })
          ],
        ),
      )),
    );
  }
}
