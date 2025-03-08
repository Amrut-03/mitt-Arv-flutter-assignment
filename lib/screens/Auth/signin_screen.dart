import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mitt_arv_e_commerce_app/Controllers/authController.dart';
import 'package:mitt_arv_e_commerce_app/screens/Auth/signup_screen.dart';
import 'package:mitt_arv_e_commerce_app/utils/constant.dart';
import 'package:mitt_arv_e_commerce_app/widgets/button.dart';
import 'package:mitt_arv_e_commerce_app/widgets/textfield.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Authcontroller authController = Get.put(Authcontroller());

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Template.background_clr,
      appBar: AppBar(
        backgroundColor: Template.background_clr,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Sign In",
                  style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomTextField(
                labelText: "Username",
                controller: nameController,
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextField(
                labelText: "Password",
                controller: passwordController,
                obscureText: true,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () => Get.to(() => SignupScreen()),
                  child: Text(
                    "I don't have any account",
                    textAlign: TextAlign.end,
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 15.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Obx(
                () {
                  return authController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          text: "Sign-In",
                          onPressed: () {
                            authController.signin(
                              name: nameController.text,
                              password: passwordController.text,
                            );
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
