import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widget/app_text.dart';

class DefaulterStudents extends StatefulWidget {
  const DefaulterStudents({required this.madrasahName, Key? key})
      : super(key: key);

  final String madrasahName;

  @override
  State<DefaulterStudents> createState() => _DefaulterStudentsState();
}

class _DefaulterStudentsState extends State<DefaulterStudents> {
  bool isWidgetVisible = false;

  Future<List> getData() async {
    List docIds = [];
    List finalList = [];

    var firstCollection = await FirebaseFirestore.instance
        .collection('users')
        .where(
          'madrasah_name',
          isEqualTo: widget.madrasahName,
        )
        .where('type', isEqualTo: "2")
        .get();

    for (int i = 0; i < firstCollection.docs.length; i++) {
      docIds.add(firstCollection.docs[i].id);
    }

    List secondList = [];

    for (int i = 0; i < docIds.length; i++) {
      DocumentSnapshot secondCollection = await FirebaseFirestore.instance
          .collection('users')
          .doc(docIds[i])
          .collection('attendance')
          .doc(DateTime.now().toString().characters.take(10).toString())
          .get();

      if (secondCollection.data() != null) {
        final value = secondCollection.data();
        print(value);
      } else {
        finalList.add({
          'id': docIds[i],
          'name': firstCollection.docs[i].get('name'),
          'img_url': firstCollection.docs[i].get('img_url'),
        });
      }
    }

    return finalList;
  }

  Widget buildSection(
      {required String title,
      required List<DocumentSnapshot> data,
      required String key}) {
    return Column(
      children: [
        Row(
          children: [
            lang == 'en'
                ? Text(
                    title,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                : Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(data[index].id)
                    .collection('attendance')
                    .doc(DateTime.now()
                        .toString()
                        .characters
                        .take(10)
                        .toString()) // Replace with the actual document ID for each user
                    .get(),
                builder: (context, attendanceSnapshot) {
                  if (attendanceSnapshot.hasData) {
                    Map<String, dynamic>? attendanceData =
                        attendanceSnapshot.data?.data();

                    bool hasKey = attendanceData?.containsKey(key) ?? false;
                    if (!hasKey) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            data[index].get("img_url").toString().isEmpty
                                ? Image.asset(
                                    "assets/images/profile.png",
                                    height: 70,
                                    width: 70,
                                  )
                                : Image.network(
                                    data[index].get("img_url"),
                                    height: 70,
                                    width: 70,
                                  ),
                            Text(data[index].get("name")),
                          ],
                        ),
                      );
                    }
                  }
                  return const SizedBox(); // Return an empty SizedBox if the key is present or data is not available
                },
              );
            },
          ),
        ),
        SizedBox(
          height: defPadding / 2,
        ),
      ],
    );
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
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Visibility(
                  visible: isWidgetVisible,
                  maintainState: true,
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .where("madrasah_name", isEqualTo: widget.madrasahName)
                        .where("type", isEqualTo: "2")
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            // Sabaq Section
                            buildSection(
                              title: lang == 'en' ? 'Sabaq' : 'سبق',
                              data: snapshot.data!.docs,
                              key: 'Sabaq',
                            ),

                            // Sabqi Section
                            buildSection(
                              title: lang == 'en' ? 'Sabqi' : 'سبقی',
                              data: snapshot.data!.docs,
                              key: 'Sabki',
                            ),

                            // Manzil Section
                            buildSection(
                              title: lang == 'en' ? 'Manzil' : 'منزل',
                              data: snapshot.data!.docs,
                              key: 'Manzil',
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),

// Helper function to build each section

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
                FutureBuilder<List>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data == null) {
                      return const Text('No data available');
                    } else if (snapshot.hasData) {
                      final absentList = snapshot.data;
                      if (absentList != null) {
                        return SizedBox(
                            height: 500,
                            child: ListView.builder(
                                itemCount: absentList.length,
                                itemBuilder: ((context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        absentList[index]['img_url'] == ''
                                            ? SizedBox(
                                                height: 50,
                                                child: Image.asset(
                                                    "assets/images/profile.png"))
                                            : SizedBox(
                                                height: 50,
                                                child: Image.network(
                                                    absentList[index]
                                                        ['img_url'])),
                                        const SizedBox(width: 8),
                                        Text(absentList[index]['name']),
                                      ],
                                    ),
                                  );
                                })));
                      } else {
                        return const Text("List is empty");
                      }
                    } else {
                      return const Text("data");
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
