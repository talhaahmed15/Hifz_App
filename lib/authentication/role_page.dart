import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hafiz_diary/NewScreens/new_login.dart';
import 'package:hafiz_diary/widget/app_text.dart';
import '../constants.dart';

class RolePage extends StatefulWidget {
  const RolePage({Key? key}) : super(key: key);

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              lang == "en"
                  ? Text(
                      "Choose your role",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    )
                  : Text(
                      "اپنا کردار منتخب کریں",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
              lang == "en"
                  ? const Text(
                      "Choose who you are to manage this diary",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  : const Text(
                      "منتخب کریں کہ آپ اس ڈائری کو سنبھالنے کے لیے کون ہیں",
                      style: TextStyle(color: Colors.grey),
                    ),
              SizedBox(
                height: defPadding * 2,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewLogin()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(defPadding),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defPadding),
                            border: Border.all(color: Colors.grey, width: 2)),
                        child: Column(
                          children: [
                            Image.asset("assets/images/admin_logo.png"),
                            lang == "en"
                                ? Text("ADMIN",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))
                                : Text("ایڈمن",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: defPadding / 2,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewLogin(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(defPadding),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defPadding),
                            border: Border.all(color: Colors.grey, width: 2)),
                        child: Column(
                          children: [
                            Image.asset("assets/images/staff_logo.png"),
                            lang == "en"
                                ? Text("TEACHER",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))
                                : Text("ٹیچر",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: defPadding / 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewLogin(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(defPadding),
                      height: 180,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(defPadding),
                          border: Border.all(color: Colors.grey, width: 2)),
                      child: Column(
                        children: [
                          Image.asset("assets/images/people_logo.png"),
                          lang == "en"
                              ? Text("PARENT",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15))
                              : Text("والدین",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
