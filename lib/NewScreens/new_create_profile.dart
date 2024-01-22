import 'package:flutter/material.dart';
import 'package:hafiz_diary/widget/TextFormField.dart';
import 'package:hafiz_diary/widget/common_button.dart';
import '../constants.dart';
import '../services/auth_services.dart';
import '../widget/app_text.dart';

class NewProfile extends StatefulWidget {
  const NewProfile({Key? key}) : super(key: key);

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController madrisaController = TextEditingController();
  List<String> Role = [
    "Parent",
    'Teacher',
  ];
  String _selectedValue = "Parent";
  final formKey = GlobalKey<FormState>();
  AuthServices authServices = AuthServices();
  String accountType = "2";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(defPadding),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lang == "en" ? "Create Profile" : "پروفائل بنائیں",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  Text(
                    lang == "en" ? "Create Profile" : "پروفائل بنائیں",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: defPadding * 5,
                  ),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      lang == "en" ? "Select Role" : "کردار منتخب کریں",
                      style: TextStyle(color: primaryColor, fontSize: 18),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10, left: 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const <BoxShadow>[]),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                        value: _selectedValue,
                        items: Role.map((e) {
                          return DropdownMenuItem<String>(
                              value: e,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  e.toString(),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedValue = newValue as String;
                            if (_selectedValue == "Teacher") {
                              setState(() {
                                accountType = "1";
                              });
                            } else {
                              setState(() {
                                accountType = "2";
                              });
                            }
                          });
                        },
                        isExpanded: true,
                      ))),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      lang == "en" ? "Set Credentials" : "اسناد مرتب کریں",
                      style: TextStyle(color: primaryColor, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: defPadding / 2,
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
                  CustomTextField(
                      validation: false,
                      controller: madrisaController,
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
                    height: defPadding * 3,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          authServices.signup(
                              data: {
                                "name": nameController.text,
                                "email": emailController.text,
                                "phone": phoneController.text,
                                "madrasah_name": madrisaController.text,
                                "type": accountType,
                                "status": true,
                                "remarks": "approved",
                                "img_url": ""
                              },
                              context: context,
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());
                        }
                      },
                      child: lang == "en"
                          ? const Text("Create Profile")
                          : const Text("پروفائل بنائیں"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
