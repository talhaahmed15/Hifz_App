import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/widget/common_button.dart';

import '../constants.dart';
import '../widget/app_text.dart';

class Applications extends StatefulWidget {
  const Applications({super.key});

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // Prevent going back to the login screen
      return false;
    },
    child:
    Scaffold(
      appBar:
      AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Applications",
              clr: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: "Manage Applications Here",
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("applications")
                        // .orderBy("date", descending: true)
                        .where("mark_read", isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                margin: EdgeInsets.symmetric(
                                    vertical: defPadding / 2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(defPadding),
                                ),
                                child: Row(
                                  children: [
                                    FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(snapshot.data!.docs[index]
                                                .get("added_by"))
                                            .get(),
                                        builder: (context, snap) {
                                          if (snap.hasData) {
                                            return InkWell(
                                              onTap: () {
                                                _dialogBuilder(
                                                    context,
                                                    snapshot.data!.docs[index]
                                                        .get("data"),
                                                    snapshot
                                                        .data!.docs[index].id);
                                              },
                                              child: Row(
                                                children: [
                                                  snap.data!
                                                          .get("img_url")
                                                          .toString()
                                                          .isEmpty
                                                      ? const CircleAvatar(
                                                          radius: 30,
                                                        )
                                                      : CircleAvatar(
                                                          radius: 30,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            snap.data!
                                                                .get("img_url"),
                                                          ),
                                                        ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                        child: AppText(
                                                          text:
                                                              "${snap.data?.get("name")} requested a sick leave",
                                                          maxLines: 3,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.25,
                                                            child: CommonButton(
                                                                text: "Allow",
                                                                onTap: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "applications")
                                                                      .doc(snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .id)
                                                                      .set({
                                                                    "mark_read":
                                                                        true,
                                                                    "approved":
                                                                        true
                                                                  }, SetOptions(merge: true));
                                                                },
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                color:
                                                                    primaryColor),
                                                          ),
                                                          SizedBox(
                                                            width: defPadding,
                                                          ),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.25,
                                                            child: CommonButton(
                                                                text:
                                                                    "Not Allow",
                                                                onTap: () {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "applications")
                                                                      .doc(snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .id)
                                                                      .set({
                                                                    "mark_read":
                                                                        true,
                                                                    "approved":
                                                                        false
                                                                  }, SetOptions(merge: true));
                                                                },
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                color:
                                                                    primaryColor),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        }),
                                  ],
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

  Future<void> _dialogBuilder(
      BuildContext context, String text, String applicationID) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppText(text: "Sick Leave"),
          content: AppText(
            text: text,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: AppText(text: "Not Allow"),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("applications")
                    .doc(applicationID)
                    .set({"mark_read": true, "approved": false},
                        SetOptions(merge: true));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: AppText(text: "Allow"),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("applications")
                    .doc(applicationID)
                    .set({"mark_read": true, "approved": true},
                        SetOptions(merge: true));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
