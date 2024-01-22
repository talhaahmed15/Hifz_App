import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/widget/common_button.dart';

import '../constants.dart';
import '../widget/TextFormField.dart';
import '../widget/app_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defPadding),
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
                text: "Forgot Password",
                fontWeight: FontWeight.bold,
                clr: primaryColor,
                size: 22,
              ),
              // AppText(
              //   text: "Welcome Back to Hifz Online Diary",
              //   clr: Colors.black,
              // ),
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

              SizedBox(
                height: defPadding,
              ),
              CommonButton(
                text: "Forgot Password",
                onTap: () {
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: AppText(
                          text: "Enter email",
                        ),
                      ),
                    );
                  } else {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailController.text)
                        .then(
                          (value) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: AppText(
                                text: "Password reset email ha been sent",
                              ),
                            ),
                          ),
                        );
                  }

                },
                color: primaryColor,
                textColor: Colors.white,
              ),
              SizedBox(
                height: defPadding / 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
