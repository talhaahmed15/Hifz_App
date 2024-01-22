import 'package:flutter/material.dart';
import 'package:hafiz_diary/admin/admin_home.dart';
import 'package:hafiz_diary/widget/TextFormField.dart';
import 'package:hafiz_diary/widget/common_button.dart';

import '../constants.dart';
import '../widget/app_text.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                  text: "Admin",
                  clr: primaryColor,
                  fontWeight: FontWeight.bold,
                  size: 22),
              AppText(
                text: "Add your information down below",
                clr: Colors.grey,
              ),
              SizedBox(
                height: defPadding * 2,
              ),
              CustomTextField(
                  validation: false, controller: controller, lableText: "Name"),
              SizedBox(
                height: defPadding / 2,
              ),
              CustomTextField(
                  validation: false,
                  controller: controller,
                  lableText: "Name of Madrasah"),
              SizedBox(
                height: defPadding / 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppText(
                    text: "Copy link to invite",
                    clr: Colors.grey,
                  ),
                ],
              ),
              SizedBox(
                height: defPadding / 2,
              ),
              CustomTextField(
                  validation: false,
                  controller: controller,
                  lableText: "hfjhjhfsjfhjfhjhd"),
              SizedBox(
                height: defPadding * 3,
              ),
              CommonButton(
                text: "Continue",
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const AdminHome(),
                  //   ),
                  // );
                },
                color: primaryColor,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
