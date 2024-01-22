import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/constants.dart';
import 'package:hafiz_diary/widget/app_text.dart';

import '../widget/common_button.dart';

// ignore: must_be_immutable
class StaffDetail extends StatefulWidget {
  final String staffID;
  StaffDetail({Key? key, required this.staffID}) : super(key: key);

  List<TextEditingController> controllers = [];

  @override
  State<StaffDetail> createState() => _StaffDetailState();
}

class _StaffDetailState extends State<StaffDetail> {
  bool? editable;
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();

  @override
  void initState() {
    editable = false;

    // TODO: implement initState
    super.initState();
  }

  Future<void> deleteUser() async {
    // This function just deactivates the user.

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.staffID)
        .update({'remarks': "pending"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang == "en" ? "Teacher Detail" : "ٹیچر کی تفصیل",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              lang == "en" ? "Manage Teacher Here" : "یہاں ٹیچر کا انتظام کریں",
              style: const TextStyle(
                fontSize: 10,
                color: Color.fromARGB(255, 209, 207, 207),
                fontWeight: FontWeight.bold,
              ),
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(defPadding),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.staffID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        snapshot.data!.get("img_url").toString() == ""
                            ? const CircleAvatar(
                                radius: 50,
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(snapshot.data?.get("img_url")),
                              ),
                        SizedBox(
                          height: defPadding,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data!.get("name"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: defPadding / 2,
                            ),
                            SizedBox(
                              width: defPadding / 2,
                            ),
                            // Icon(Icons.edit_note_sharp)
                          ],
                        ),
                        Text(
                          lang == "en" ? "Staff" : "استاد",
                        ),
                        const Divider(
                          color: Color.fromARGB(255, 151, 150, 150),
                          thickness: 1,
                        ),
                        SizedBox(
                          height: defPadding / 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(lang == "en"
                                    ? 'Class Name'
                                    : "کلاس کا نام")),
                            SizedBox(
                              width: defPadding / 2,
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    lang == "en" ? 'Class Code' : "کلاس کوڈ")),
                          ],
                        ),
                        SizedBox(
                          height: defPadding / 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: snapshot.data!['class_name'],
                                ),
                                enabled: editable,
                              ),
                            ),
                            SizedBox(
                              width: defPadding / 2,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: controller1,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: snapshot.data!['class_code'],
                                ),
                                enabled: editable,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(lang == "en"
                                    ? 'Number of Students'
                                    : "طلباء کی تعداد")),
                            SizedBox(
                              width: defPadding / 2,
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(lang == "en" ? 'Address' : "پتہ")),
                          ],
                        ),
                        SizedBox(
                          height: defPadding / 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: controller2,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: snapshot.data!['class_strength'],
                                ),
                                enabled: editable,
                              ),
                            ),
                            SizedBox(
                              width: defPadding / 2,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: controller3,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: snapshot.data!['addresss'],
                                ),
                                enabled: editable,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(lang == "en"
                                    ? 'Phone Number'
                                    : "فون نمبر")),
                          ],
                        ),
                        SizedBox(
                          height: defPadding / 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: controller4,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: snapshot.data!['phone'],
                                ),
                                enabled: editable,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: defPadding,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: CommonButton(
                                  color: primaryColor,
                                  textColor: Colors.white,
                                  text: lang == 'en' ? 'Edit' : "ترمیم",
                                  onTap: () {
                                    setState(() {
                                      editable = true;
                                    });
                                  },
                                )),
                            SizedBox(
                              width: defPadding / 2,
                            ),
                            Expanded(
                                flex: 1,
                                child: CommonButton(
                                  color: primaryColor,
                                  textColor: Colors.white,
                                  text: lang == 'en'
                                      ? 'Save Changes'
                                      : "تبدیلیاں محفوظ کریں",
                                  onTap: () {
                                    setState(() {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget.staffID)
                                          .set({
                                        "class_name": controller.text,
                                        "class_code": controller1.text,
                                        "class_strength": controller2.text,
                                        "addresss": controller3.text,
                                        "contact_no": controller4.text,
                                      }, SetOptions(merge: true));

                                      editable = false;
                                    });
                                  },
                                ))
                          ],
                        ),
                        SizedBox(
                          height: defPadding,
                        ),
                        CommonButton(
                          color: const Color.fromARGB(255, 179, 30, 20),
                          textColor: Colors.white,
                          text: lang == 'en'
                              ? 'Delete Teacher'
                              : "ٹیچر کو ختم کریں",
                          onTap: () {
                            deleteUser();
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
