import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widget/app_text.dart';

class DefaulterStudents extends StatefulWidget {
  DefaulterStudents({required this.madrasahName, Key? key}) : super(key: key);

  String madrasahName;

  @override
  State<DefaulterStudents> createState() => _DefaulterStudentsState();
}

class _DefaulterStudentsState extends State<DefaulterStudents> {
  bool isWidgetVisible = false;
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
              text: lang == "en" ? "Defaulter" : "ڈیفالٹر",
              clr: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: lang == "en"
                  ? "Each Student who didn't tested sabaq"
                  : "ہر وہ طالب علم جس نے صباق کا امتحان نہیں لیا",
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isWidgetVisible = !isWidgetVisible;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      isWidgetVisible ? "Hide Other" : "Show Other",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Visibility(
                    visible: isWidgetVisible,
                    maintainState: true,
                    child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("attendance")
                            .where("Attendance", isEqualTo: "present")
                            .where("date",
                                isEqualTo: DateTime.now()
                                    .toString()
                                    .characters
                                    .take(10)
                                    .toString())
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    lang == 'en'
                                        ? Text(
                                            'Sabaq',
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          )
                                        : Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              'سبق ',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          )
                                  ],
                                ),
                                SizedBox(
                                  height: defPadding / 2,
                                ),
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.docs
                                          .where((snap) =>
                                              snap.get("Sabaq")['para'] == '')
                                          .length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        if (snapshot.data!.docs[index]
                                            .get("Sabaq")['para']
                                            .toString()
                                            .isEmpty) {
                                          return FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(snapshot
                                                      .data!.docs[index]
                                                      .get("studentId"))
                                                  .get(),
                                              builder: (context, futurSnap) {
                                                if (snapshot.hasData) {
                                                  return Column(
                                                    children: [
                                                      futurSnap.data!
                                                              .get("img_url")
                                                              .toString()
                                                              .isEmpty
                                                          ? Image.asset(
                                                              "assets/images/profile.png",
                                                              height: 70,
                                                              width: 70,
                                                            )
                                                          : Image.network(
                                                              futurSnap.data!
                                                                  .get(
                                                                      "img_url"),
                                                              height: 70,
                                                              width: 70,
                                                            ),
                                                      Text(futurSnap.data!
                                                          .get("name"))
                                                    ],
                                                  );
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              });
                                        }
                                        return null;
                                      }),
                                ),
                                SizedBox(
                                  height: defPadding / 2,
                                ),
                                Row(
                                  children: [
                                    lang == "en"
                                        ? Text(
                                            "Sabqi",
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          )
                                        : Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              "سبقی",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: defPadding / 2,
                                ),
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.docs
                                          .where((snap) =>
                                              snap.get("Sabqi") == false)
                                          .length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        if (!snapshot.data!.docs[index]
                                            .get("Sabqi")) {
                                          return FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(snapshot
                                                      .data!.docs[index]
                                                      .get("studentId"))
                                                  .get(),
                                              builder: (context, futurSnap) {
                                                if (snapshot.hasData) {
                                                  return Column(
                                                    children: [
                                                      futurSnap.data!
                                                              .get("img_url")
                                                              .toString()
                                                              .isEmpty
                                                          ? Image.asset(
                                                              "assets/images/profile.png",
                                                              height: 70,
                                                              width: 70,
                                                            )
                                                          : Image.network(
                                                              futurSnap.data!
                                                                  .get(
                                                                      "img_url"),
                                                              height: 70,
                                                              width: 70,
                                                            ),
                                                      Text(futurSnap.data!
                                                          .get("name"))
                                                    ],
                                                  );
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              });
                                        }
                                        return null;
                                      }),
                                ),
                                SizedBox(
                                  height: defPadding / 2,
                                ),
                                Row(
                                  children: [
                                    lang == "en"
                                        ? Text(
                                            "Manzil",
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          )
                                        : Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text(
                                              "منزل",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: defPadding / 2,
                                ),
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.docs
                                          .where((snap) =>
                                              snap.get("Manzil") == false)
                                          .length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        if (!snapshot.data!.docs[index]
                                            .get("Manzil")) {
                                          return FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(snapshot
                                                      .data!.docs[index]
                                                      .get("studentId"))
                                                  .get(),
                                              builder: (context, futurSnap) {
                                                if (snapshot.hasData) {
                                                  return Column(
                                                    children: [
                                                      futurSnap.data!
                                                              .get("img_url")
                                                              .toString()
                                                              .isEmpty
                                                          ? Image.asset(
                                                              "assets/images/profile.png",
                                                              height: 70,
                                                              width: 70,
                                                            )
                                                          : Image.network(
                                                              futurSnap.data!
                                                                  .get(
                                                                      "img_url"),
                                                              height: 70,
                                                              width: 70,
                                                            ),
                                                      Text(futurSnap.data!
                                                          .get("name"))
                                                    ],
                                                  );
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              });
                                        }
                                        return null;
                                      }),
                                )
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })),
                SizedBox(
                  height: defPadding / 2,
                ),
                lang == 'en'
                    ? Text(
                        'Absent',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    : Text(
                        'غیر حاضر',
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                SizedBox(
                  height: defPadding / 2,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .where('madrasah_name', isEqualTo: widget.madrasahName)
                      .get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Return a loading indicator or some placeholder
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Handle error
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      // No data available
                      return Text('No data available');
                    } else {
                      // Data is available
                      return SizedBox(
                        height: 120,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            // Access the document data
                            var userData = snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                            return Column(
                              children: [
                                userData.containsKey('image_url')
                                    ? Image.network(
                                        userData['image_url'],
                                        height: 70,
                                        width: 70,
                                      )
                                    : Image.asset(
                                        "assets/images/profile.png",
                                        height: 70,
                                        width: 70,
                                      ),
                                Text(userData.toString()),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
