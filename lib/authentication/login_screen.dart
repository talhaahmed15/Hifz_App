import 'package:flutter/material.dart';
import 'package:hafiz_diary/NewScreens/new_sign_up.dart';
import 'package:hafiz_diary/authentication/forgot_password.dart';
import 'package:hafiz_diary/services/auth_services.dart';

import 'package:hafiz_diary/widget/TextFormField.dart';
import 'package:hafiz_diary/widget/app_text.dart';
import 'package:hafiz_diary/widget/common_button.dart';

import '../constants.dart';
import 'sign_up.dart';

class LoginScreen extends StatefulWidget {
  final bool isAdmin;
  final String accountType;
  const LoginScreen(
      {Key? key, required this.isAdmin, required this.accountType})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(defPadding),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    // height: 300,
                  ),
                  AppText(
                    text: "Log in",
                    fontWeight: FontWeight.bold,
                    clr: primaryColor,
                    size: 22,
                  ),
                  AppText(
                    text: "Welcome Back to Hifz Online Diary",
                    clr: Colors.black,
                  ),
                  SizedBox(
                    height: defPadding,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: emailController,
                      lableText: "Email"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: passwordController,
                      lableText: "Password"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
                    },
                    child: AppText(
                      text: "Forgot Password?",
                      clr: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: defPadding,
                  ),
                  CommonButton(
                    text: "Login",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        authServices.login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            context: context);
                      }
                    },
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  widget.isAdmin
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: "Don't have an account?",
                              clr: Colors.black,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const NewSignUp()),
                                );
                              },
                              child: AppText(
                                text: "Sign Up",
                                clr: primaryColor,
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
