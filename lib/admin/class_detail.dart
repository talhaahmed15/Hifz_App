import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/staff/staff_student_attendance.dart';

import '../constants.dart';
import '../widget/app_text.dart';
// import '../widget/app_text.dart';

class ClassDetail extends StatefulWidget {
  final String classCode;
  final String className;
  final String classID;
  const ClassDetail(
      {Key? key,
      required this.classCode,
      required this.className,
      required this.classID})
      : super(key: key);

  @override
  State<ClassDetail> createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.className,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            lang == "en"
                ? const Text("See Details of Each Student",
                    style: TextStyle(fontSize: 11))
                : const Text(
                    "ہر طالب علم کی تفصیلات دیکھیں",
                    style: TextStyle(fontSize: 11),
                  ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              FirebaseFirestore.instance
                  .collection("classes")
                  .doc(widget.classID)
                  .delete()
                  .then((value) => Navigator.pop(context));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          )
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(defPadding),
            bottomLeft: Radius.circular(defPadding),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("classes")
                        .where("class_code", isEqualTo: widget.classCode)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        final classdoc = snapshot.data!;
                        return Column(
                          children: [
                            SizedBox(
                              height: defPadding,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                lang == "en"
                                    ? const Text("Class Code",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))
                                    : const Text(
                                        "کلاس کوڈ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                Text(classdoc.docs.first.get("class_code"),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ],
                            ),
                            SizedBox(
                              height: defPadding,
                            ),
                            GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 3 / 2.5,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount:
                                    classdoc.docs.first.get("students").length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, index) {
                                  return FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(classdoc.docs.first['students']
                                            [index])
                                        .get(),
                                    builder: (context, futureSnap) {
                                      if (futureSnap.connectionState ==
                                              ConnectionState.done &&
                                          futureSnap.hasData) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    StaffStudentAttendance(
                                                  isAdmin: true,
                                                  studentID:
                                                      futureSnap.data!.id,
                                                  studentName:
                                                      futureSnap.data!['name'],
                                                  imgURL: futureSnap
                                                      .data!["img_url"],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              futureSnap.data!
                                                          .get("img_url")
                                                          .toString() ==
                                                      ""
                                                  ? Image.asset(
                                                      "assets/images/profile.png",
                                                      height: 100,
                                                      width: 100,
                                                    )
                                                  : Expanded(
                                                      child: FastCachedImage(
                                                        url: futureSnap.data!
                                                            .get("img_url"),
                                                        height: 100,
                                                        width: 100,
                                                      ),
                                                    ),
                                              SizedBox(
                                                height: defPadding / 2,
                                              ),
                                              Text(futureSnap.data!.get("name"))
                                            ],
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  );
                                }),
                          ],
                        );
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
    );
  }
}
