import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/NewScreens/join.dart';
import 'package:hafiz_diary/NewScreens/new_create_profile.dart';
import 'package:hafiz_diary/admin/admin_checkfees.dart';
import 'package:hafiz_diary/admin/class_detail.dart';
import 'package:hafiz_diary/admin/defaulter_students.dart';
import 'package:hafiz_diary/admin/staff_detail.dart';
import 'package:hafiz_diary/admin/users_approval.dart';
import 'package:hafiz_diary/constants.dart';
import 'package:hafiz_diary/notification/notification_screen.dart';
import 'package:hafiz_diary/widget/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key, required this.madrisaName}) : super(key: key);

  final String? madrisaName;

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String? uId;
  // ignore: non_constant_identifier_names
  String? madrasah_name;

  @override
  void initState() {
    uId = FirebaseAuth.instance.currentUser!.uid;

    initialize();

    super.initState();
  }

  initialize() async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uId).get();

    madrasah_name = doc.get('madrasah_name');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Prevent going back to the login screen
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uId)
                        .get(),
                    builder: (context, snap) {
                      if (snap.hasData && snap.data!.exists) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hi, ${snap.data!.get("name")}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text("${snap.data!.get("madrasah_name")}",
                                style: const TextStyle(
                                  fontSize: 10,
                                )),
                          ],
                        );
                      } else if (snap.hasError) {
                        return const Text("Error");
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  NotificationScreen(madrisaName: madrasah_name!,)));
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  /*  Navigator.push(context, MaterialPageRoute(builder: (context){
             return SplashScreen();
           }));*/

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("currentUserId");

                  FirebaseAuth.instance.signOut();

                  // if (mounted) {
                  //   Navigator.pushReplacement(context,
                  //       MaterialPageRoute(builder: ((context) {
                  //     return const Join();
                  //   })));
                  // }
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(defPadding),
                bottomLeft: Radius.circular(defPadding),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(defPadding),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 350,
                      height: 50,
                      // width: width,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return NewProfile(madrisaName: madrasah_name!);
                          }));
                        },
                        child: lang == "en"
                            ? const Text("Create Profile")
                            : const Text("پروفائل بنائیں"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 350,
                      height: 50,
                      // width: width,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CheckFeesPage(
                                madrasahName: widget.madrisaName!);
                          }));
                        },
                        child: lang == "en"
                            ? const Text("Check Fees")
                            : const Text("فیس چیک کریں"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 350,
                      height: 50,
                      // width: width,

                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => UserApproval(
                                        madrisaName: widget.madrisaName!,
                                      ))));
                        },
                        child: lang == "en"
                            ? const Text("Manage Your Madrasah")
                            : const Text("اپنے مدرسے کا انتظام کریں"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        lang == "en"
                            ? const Text("Teachers")
                            : const Text("اساتذہ"),
                      ],
                    ),
                    SizedBox(
                      height: defPadding / 2,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("status", isEqualTo: true)
                            .where("remarks", isEqualTo: "approved")
                            .where("type", isEqualTo: "1")
                            .where("madrasah_name",
                                isEqualTo: widget.madrisaName)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> staffList =
                                snapshot.data!.docs;
                            return SizedBox(
                              height: 100,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: staffList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StaffDetail(
                                                        staffID:
                                                            staffList[index].id,
                                                      )));
                                        },
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 70,
                                              width: 70,
                                              child: staffList[index]
                                                          .get("img_url") !=
                                                      ""
                                                  ? CircleAvatar(
                                                      radius: 50,
                                                      backgroundImage:
                                                          NetworkImage(staffList[
                                                                  index]
                                                              .get("img_url")),
                                                    )
                                                  : ClipOval(
                                                      child: Image.asset(
                                                      "assets/images/profile.png",
                                                      fit: BoxFit.cover,
                                                    )),
                                            ),
                                            Text(
                                              staffList[index].get("name"),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        lang == "en"
                            ? const Text("Classes",
                                style: TextStyle(fontSize: 18))
                            : const Text(
                                "کلاس",
                                style: TextStyle(fontSize: 18),
                              ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DefaulterStudents(
                                    madrasahName: madrasah_name!),
                              ),
                            );
                          },
                          child: lang == "en"
                              ? const Text("Defaulter",
                                  style: TextStyle(fontSize: 18))
                              : const Text(
                                  "ڈیفالٹر",
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: defPadding / 2,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("classes")
                            .where("madrasah_name",
                                isEqualTo: widget.madrisaName)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<DocumentSnapshot> classList =
                                snapshot.data!.docs;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: classList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ClassDetail(
                                            classID: classList[index].id,
                                            classCode: classList[index]
                                                .get("class_code"),
                                            className: classList[index]
                                                .get("class_name"),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(defPadding / 2),
                                      margin: EdgeInsets.symmetric(
                                          vertical: defPadding / 2),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(defPadding),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                offset: const Offset(0, 0),
                                                spreadRadius: 2,
                                                blurRadius: 1)
                                          ]),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/model.png",
                                            height: 70,
                                            width: 70,
                                          ),
                                          SizedBox(
                                            width: defPadding / 2,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data!.docs[index]
                                                    .get("class_name"),
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      .get("class_desc"),
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
