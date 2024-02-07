import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../constants.dart';
import '../widget/app_text.dart';

class UserApproval extends StatefulWidget {
  const UserApproval({Key? key, required this.madrisaName}) : super(key: key);

  final String? madrisaName;

  @override
  State<UserApproval> createState() => _UserApprovalState();
}

class _UserApprovalState extends State<UserApproval> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Hi, Abdul",
              clr: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: "Manage Users Requests",
              clr: Colors.white60,
              size: 11,
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(defPadding),
            bottomLeft: Radius.circular(defPadding),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("status", isEqualTo: false)
                    .where("remarks", isEqualTo: "pending")
                    .where("madrasah_name", isEqualTo: widget.madrisaName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error loading data"));
                  } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(lang == "en"
                          ? "No Staff/Student Needs Approval"
                          : "کسی عملے/طالب علم کو منظوری کی ضرورت نہیں ہے"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage("assets/images/profile.png"),
                                ),
                                SizedBox(
                                  width: defPadding,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index].get("name"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                        "Account Created As: ${snapshot.data!.docs[index].get("type") == "1" ? "Staff" : "Student"}"),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(snapshot.data!.docs[index].id)
                                          .set(
                                        {"remarks": "approved", "status": true},
                                        SetOptions(merge: true),
                                      );
                                    });
                                  },
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(
                                  width: defPadding,
                                ),
                                InkWell(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(snapshot.data!.docs[index].id)
                                        .set(
                                      {"remarks": "rejected", "status": false},
                                      SetOptions(merge: true),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
