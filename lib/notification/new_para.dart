import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widget/app_text.dart';
import '../widget/common_button.dart';

class NewPara extends StatefulWidget {
  const NewPara({super.key});

  @override
  State<NewPara> createState() => _NewParaState();
}

class _NewParaState extends State<NewPara> {
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
              text: "New Para",
              clr: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: "View New Para Details Here",
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
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("attendance")
                        .where("notify", isEqualTo: true)
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
                                  borderRadius: BorderRadius.circular(defPadding),
                                ),
                                child: Row(
                                  children: [
                                    FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(snapshot.data!.docs[index]
                                                .get("studentId"))
                                            .get(),
                                        builder: (context, snap) {
                                          if (snap.hasData) {
                                            return Row(
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6,
                                                      child: AppText(
                                                        text:
                                                            "${snap.data?.get("name")} started a new para",
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
                                                                        "attendance")
                                                                    .doc(snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .id)
                                                                    .set(
                                                                        {
                                                                      "notify":false
                                                                    },
                                                                        SetOptions(
                                                                            merge:
                                                                                true));
                                                              },
                                                              textColor:
                                                                  Colors.white,
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
                                                              text: "Not Allow",
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
                                                                    .set(
                                                                        {
                                                                          "notify":false
                                                                    },
                                                                        SetOptions(
                                                                            merge:
                                                                                true));
                                                              },
                                                              textColor:
                                                                  Colors.white,
                                                              color:
                                                                  primaryColor),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            );
                                          } else {
                                            return const Center(
                                              child: CircularProgressIndicator(),
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
    );
  }
}
