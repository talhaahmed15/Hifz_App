import 'package:flutter/material.dart';
import 'package:hafiz_diary/NewScreens/new_login.dart';
import 'package:hafiz_diary/services/auth_services.dart';
import '../constants.dart';
import '../widget/TextFormField.dart';
import '../widget/common_button.dart';

class NewSignUp extends StatefulWidget {
  const NewSignUp({
    Key? key,
  }) : super(key: key);

  @override
  State<NewSignUp> createState() => _NewSignUpState();
}

class _NewSignUpState extends State<NewSignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController madrisaNameController = TextEditingController();

  String selectedValue = "Admin";
  String valuex = "0";

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AuthServices authServices = AuthServices();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(defPadding * 2),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    height: 200,
                    // height: 300,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    lang == "en" ? "Signup" : "سائن اپ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    lang == "en"
                        ? "Signup for Hifz Online Diary"
                        : "حفظ آن لائن ڈائری کے لیے سائن اپ کریں",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: defPadding,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: nameController,
                      lableText: lang == "en" ? "Name" : "نام"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: emailController,
                      lableText: lang == "en" ? "Email" : "ای میل"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: phoneController,
                      lableText: lang == "en" ? "Phone Number" : "فون نمبر"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defPadding / 3),
                        border: Border.all(color: Colors.grey, width: 2)),
                    child: DropdownButton(
                        borderRadius: BorderRadius.circular(defPadding),
                        isExpanded: true,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        value: selectedValue,
                        items: [
                          DropdownMenuItem(
                            value: "Admin",
                            child: lang == "en"
                                ? const Text('Admin')
                                : const Text('ایڈمن'),
                          ),
                          DropdownMenuItem(
                            value: "Staff",
                            child: lang == "en"
                                ? const Text('Teacher')
                                : const Text('استاد'),
                          ),
                          DropdownMenuItem(
                            value: "Student",
                            child: lang == "en"
                                ? const Text('Student')
                                : const Text('طالب علم'),
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (value == "Admin") {
                              selectedValue = "Admin";
                              valuex = "0";
                            } else if (value == "Staff") {
                              valuex = "1";
                              selectedValue = "Staff";
                            } else if (value == "Student") {
                              valuex = "2";
                              selectedValue = "Student";
                            }
                          });
                        }),
                  ),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: madrisaNameController,
                      lableText:
                          lang == "en" ? "Madrasah Name" : "مدرسہ کا نام"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: passwordController,
                      lableText: lang == "en" ? "Password" : "پاس ورڈ"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: confirmPasswordController,
                      lableText: lang == "en"
                          ? "Confirm Password"
                          : "پاس ورڈ کی تصدیق کریں"),
                  SizedBox(
                    height: defPadding * 3,
                  ),
                  CommonButton(
                    text: lang == "en" ? "Sign Up" : "سائن اپ",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        authServices.signup(
                            data: {
                              "name": nameController.text,
                              "email": emailController.text,
                              "phone": phoneController.text,
                              "type": valuex,
                              "status": valuex == "0" ? true : false,
                              "remarks": valuex == "0" ? "approved" : "pending",
                              "img_url": "",
                              "madrasah_name": madrisaNameController.text,
                            },
                            context: context,
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                      }
                    },
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lang == "en"
                            ? "Already have an Account?"
                            : "پہلے سے ہی اکاؤنٹ ہے؟",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewLogin()),
                          );
                        },
                        child: Text(
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: primaryColor,
                          ),
                          lang == "en" ? "Login" : "لاگ ان",
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
