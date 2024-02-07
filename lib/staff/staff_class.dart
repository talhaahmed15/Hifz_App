import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/staff/staff_student_attendance.dart';

import '../constants.dart';

class StaffClass extends StatefulWidget {
  final String classCode;
  final String className;
  const StaffClass({Key? key, required this.classCode, required this.className})
      : super(key: key);

  @override
  State<StaffClass> createState() => _StaffClassState();
}

class _StaffClassState extends State<StaffClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
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
                      if (snapshot.hasData && snapshot.data != null) {
                        final classdoc = snapshot.data!;
                        return Column(children: [
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
                              itemCount: snapshot.data!.docs.first
                                  .get("students")
                                  .length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext ctx, index) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(snapshot.data!.docs.first
                                            .get("students")[index])
                                        .get(),
                                    builder: (context, futureSnap) {
                                      if (futureSnap.hasData &&
                                          futureSnap.data != null) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    StaffStudentAttendance(
                                                  isAdmin: false,
                                                  studentID:
                                                      futureSnap.data!.id,
                                                  studentName: futureSnap.data!
                                                      .get("name"),
                                                  imgURL: futureSnap.data!
                                                      .get("img_url"),
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
                                                  : Image.network(
                                                      futureSnap.data!
                                                          .get("img_url"),
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                              SizedBox(
                                                height: defPadding / 2,
                                              ),
                                              Text(futureSnap.data!.get("name"))
                                            ],
                                          ),
                                        );
                                      } else if (snapshot.hasData) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }),
                        ]);
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
