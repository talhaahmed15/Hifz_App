import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/parents/parents_bottom_navigation.dart';

import '../admin/admin_home.dart';
import '../constants.dart';
import '../widget/TextFormField.dart';
import '../widget/app_text.dart';
import '../widget/common_button.dart';

class ParentsLogin extends StatefulWidget {
  final bool isApproved;
  const ParentsLogin({Key? key, required this.isApproved}) : super(key: key);

  @override
  State<ParentsLogin> createState() => _ParentsLoginState();
}

class _ParentsLoginState extends State<ParentsLogin> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return widget.isApproved
        ? Scaffold(
            body: Builder(builder: (context) {
              FirebaseFirestore.instance
                  .collection("classes")
                  .where("students",
                      arrayContains: FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                if (querySnapshot.docs.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ParentsBottomNavigation()),
                  );
                  print("Student Found");
                } else {
                  return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(defPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                              text: "Parents",
                              clr: primaryColor,
                              fontWeight: FontWeight.bold,
                              size: 22),
                          AppText(
                            text: "Enter Class Code to join Class",
                            clr: Colors.grey,
                          ),
                          SizedBox(
                            height: defPadding * 2,
                          ),
                          // CustomTextField(
                          //     validation: false,
                          //     controller: controller,
                          //     lableText: "Name"),
                          // SizedBox(
                          //   height: defPadding / 2,
                          // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppText(
                                text: "Class Code",
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
                              lableText: "00000"),
                          SizedBox(
                            height: defPadding * 3,
                          ),
                          CommonButton(
                            text: "Continue",
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection("classes")
                                  .where("class_code",
                                      isEqualTo: controller.text)
                                  .get()
                                  .then(
                                (value) {
                                  if (!value.docs.first
                                      .get("students")
                                      .toString()
                                      .contains(FirebaseAuth
                                          .instance.currentUser!.uid)) {
                                    FirebaseFirestore.instance
                                        .collection("classes")
                                        .doc(value.docs.first.id)
                                        .set(
                                      {
                                        "students": FieldValue.arrayUnion([
                                          FirebaseAuth.instance.currentUser!.uid
                                        ])
                                      },
                                      SetOptions(merge: true),
                                    ).then(
                                      (value) => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ParentsBottomNavigation(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ).catchError((e) => print(e.message));
                            }
                            // {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) =>
                            //           const ParentsBottomNavigation(),
                            //     ),
                            //   );
                            // }
                            ,
                            color: primaryColor,
                            textColor: Colors.white,
                          )
                        ],
                      ),
                    ),
                  );
                }
              }).catchError((error) {
                // Handle any errors that occur during the query
                print("Error: $error");
              });
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(defPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                          text: "Parents",
                          clr: primaryColor,
                          fontWeight: FontWeight.bold,
                          size: 22),
                      AppText(
                        text: "Enter Class Code to join Class",
                        clr: Colors.grey,
                      ),
                      SizedBox(
                        height: defPadding * 2,
                      ),
                      // CustomTextField(
                      //     validation: false,
                      //     controller: controller,
                      //     lableText: "Name"),
                      // SizedBox(
                      //   height: defPadding / 2,
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppText(
                            text: "Class Code",
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
                          lableText: "00000"),
                      SizedBox(
                        height: defPadding * 3,
                      ),
                      CommonButton(
                        text: "Continue",
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("classes")
                              .where("class_code", isEqualTo: controller.text)
                              .get()
                              .then(
                            (value) {
                              if (!value.docs.first
                                  .get("students")
                                  .toString()
                                  .contains(
                                      FirebaseAuth.instance.currentUser!.uid)) {
                                FirebaseFirestore.instance
                                    .collection("classes")
                                    .doc(value.docs.first.id)
                                    .set(
                                  {
                                    "students": FieldValue.arrayUnion([
                                      FirebaseAuth.instance.currentUser!.uid
                                    ])
                                  },
                                  SetOptions(merge: true),
                                ).then(
                                  (value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ParentsBottomNavigation(),
                                    ),
                                  ),
                                );
                              }
                            },
                          ).catchError((e) => print(e.message));
                        }
                        // {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) =>
                        //           const ParentsBottomNavigation(),
                        //     ),
                        //   );
                        // }
                        ,
                        color: primaryColor,
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              );
            }),
          )
        : const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Text("Wait Until your account is approved by admin"))
              ],
            ),
          );
  }
}
