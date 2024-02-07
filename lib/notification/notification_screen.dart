import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/notification/applications.dart';
import 'package:hafiz_diary/notification/new_para.dart';

import '../constants.dart';
import '../widget/app_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
              text: "Notifications",
              clr: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: "Manage Alerts Here",
              clr: Colors.white60,
              size: 11,
            ),
          ],
        ),
        // actions: [
        //   InkWell(
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const NewPara(),
        //         ),
        //       );
        //     },
        //     child: const Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: Icon(
        //         Icons.book,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        //   InkWell(
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const Applications(),
        //         ),
        //       );
        //     },
        //     child: const Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: Icon(
        //         Icons.sick,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(defPadding),
            bottomLeft: Radius.circular(defPadding),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(defPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppText(
                //   text: "Today",
                //   fontWeight: FontWeight.bold,
                //   size: 18,
                // ),
                // AppText(
                //   text: "You have 3 notifications today",
                // ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewPara(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.book,
                            color: Colors.white,
                          ),
                          SizedBox(
                              height: 4), // Add spacing between icon and text
                          Text(
                            'New Para',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        width: 16), // Add spacing between the buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Applications(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.sick,
                            color: Colors.white,
                          ),
                          SizedBox(
                              height: 4), // Add spacing between icon and text
                          Text(
                            'Applications',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("type", isEqualTo: 2)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  int length = await fetchDocuments(
                                      studentID: snapshot.data!.docs[index].id);

                                  if (length >= 39) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: AppText(
                                        text: "Studied 40 Namaz",
                                      )));
                                    }
                                  } else {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: AppText(
                                        text: "Did not studied 40 Namaz",
                                      )));
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
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
                                      snapshot.data!.docs[index]
                                              .get("img_url")
                                              .toString()
                                              .isEmpty
                                          ? const CircleAvatar(
                                              radius: 30,
                                            )
                                          : CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  snapshot.data!.docs[index]
                                                      .get("img_url")),
                                            ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: AppText(
                                          text: snapshot.data!.docs[index]
                                              .get("name"),
                                          maxLines: 3,
                                        ),
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
                    }),
                SizedBox(
                  height: defPadding,
                ),
                // ListView.builder(
                //     shrinkWrap: true,
                //     itemCount: 5,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemBuilder: (context, index) {
                //       return Container(
                //         margin: EdgeInsets.symmetric(vertical: defPadding / 2),
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //             color: Colors.grey,
                //           ),
                //           borderRadius: BorderRadius.circular(defPadding),
                //         ),
                //         child: Row(
                //           children: [
                //             Image.asset(
                //               "assets/images/model.png",
                //               height: 100,
                //               width: 100,
                //             ),
                //             SizedBox(
                //               width: MediaQuery.of(context).size.width * 0.6,
                //               child: AppText(
                //                 text:
                //                     "Ainal Aimaz Offers all Prayers for 40 days",
                //                 maxLines: 3,
                //               ),
                //             )
                //           ],
                //         ),
                //       );
                //     })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> fetchDocuments({String? studentID}) async {
    DateTime currentDate = DateTime.now();
    DateTime startDate = currentDate.subtract(const Duration(days: 40));

    Timestamp startTimestamp = Timestamp.fromDate(startDate);
    Timestamp endTimestamp = Timestamp.fromDate(currentDate);
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .where("studentId",
            isEqualTo: studentID) // Replace with your collection name
        .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
        .where("timestamp", isLessThanOrEqualTo: endTimestamp)
        .get();

    // Filter the documents further to include only those with no false values
    final List<DocumentSnapshot> filteredDocuments = querySnapshot.docs
        .where((doc) => !(doc.get("Namaz") as List<dynamic>).contains(false))
        .toList();

    return filteredDocuments.length;
  }
}
