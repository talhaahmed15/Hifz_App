import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/constants.dart';
import 'package:hafiz_diary/widget/TextFormField.dart';
import 'package:hafiz_diary/widget/app_text.dart';
import 'package:hafiz_diary/widget/common_button.dart';

class ParentsApplication extends StatefulWidget {
  const ParentsApplication({Key? key}) : super(key: key);

  @override
  State<ParentsApplication> createState() => _ParentsApplicationState();
}

class _ParentsApplicationState extends State<ParentsApplication> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Prevent going back to the login screen
          return false;
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AppBar(
              backgroundColor: primaryColor,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: AppText(
                text: "Submit Application",
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(defPadding),
                child: Column(
                  children: [
                    SizedBox(
                      height: defPadding * 3,
                    ),
                    CustomTextField(
                      validation: false,
                      controller: controller,
                      maxLines: 15,
                    ),
                    SizedBox(
                      height: defPadding,
                    ),
                    CommonButton(
                      text: "Submit Application",
                      onTap: () {
                        if (controller.text.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection("applications")
                              .add({
                            "data": controller.text,
                            "date": DateTime.now()
                                .toString()
                                .characters
                                .take(10)
                                .toString(),
                            "added_by": FirebaseAuth.instance.currentUser!.uid,
                            "approved": false,
                            "mark_read": false
                          }).whenComplete(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: AppText(
                              text: "You Application Has Been Submitted",
                            )));
                            controller.clear();
                          });
                        }
                      },
                      color: primaryColor,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
