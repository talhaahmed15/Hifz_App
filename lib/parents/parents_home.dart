import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/NewScreens/join.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../provider/provider_class.dart';
import '../widget/app_text.dart';
import '../widget/common_button.dart';

class ParentsHome extends StatefulWidget {
  const ParentsHome({Key? key}) : super(key: key);

  @override
  State<ParentsHome> createState() => _ParentsHomeState();
}

class _ParentsHomeState extends State<ParentsHome> {
  TextEditingController fromAyahController = TextEditingController();
  TextEditingController toAyahController = TextEditingController();

  String? selectedPara;
  String? fromSurah;
  String? toSurah;
  String? _sabaqType = 'Sabaq';

  bool? sabkiattendance = false;
  bool? sabaqattendance = false;
  bool? manzilattendance = false;

  @override
  void initState() {
    checkAttendance();

    // TODO: implement initState
    // checkAndCreateDocument(
    //     date: DateTime.now().toString().characters.take(10).toString(),
    //     studentId: FirebaseAuth.instance.currentUser!.uid);

    _fetchFeeStatus();

    super.initState();
  }

  Future<void> checkAttendance() async {
    // Check if a user is currently signed in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('attendance')
          .doc(DateTime.now().toString().substring(0, 10))
          .get();

      if (snapshot.data() != null) {
        if (snapshot.data()!.containsKey("Sabaq")) {
          setState(() {
            sabaqattendance = true;
          });
        }

        if (snapshot.data()!.containsKey("Sabki")) {
          setState(() {
            sabkiattendance = true;
          });
        }

        if (snapshot.data()!.containsKey("Manzil")) {
          setState(() {
            manzilattendance = true;
          });
        }
      }
    }
  }

  bool _feeSubmitted = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void _fetchFeeStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (mounted) {
        setState(() {
          _feeSubmitted = snapshot['feeSubmitted'] ?? false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(builder: (context, providerClass, child) {
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
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
                      builder: (context, snap) {
                        if (snap.hasData &&
                            snap.data!.exists &&
                            snap.data != null) {
                          return Text(
                            "Hi, ${snap.data!.get("name")}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (snap.data == null) {
                          return const Text("Loading");
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ],
              ),
              actions: [
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove("currentUserId");

                    // FirebaseAuth.instance.signOut().then(
                    //       (value) => Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => const Join(),
                    //         ),
                    //       ),
                    //     );

                    FirebaseAuth.instance
                        .signOut()
                        .then((value) => Navigator.pop(context));
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
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("attendance")
                          .where("studentId",
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .where("date",
                              isEqualTo: DateTime.now()
                                  .toString()
                                  .characters
                                  .take(10)
                                  .toString())
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .get(),
                                      builder: (context, snap) {
                                        if (snap.hasData) {
                                          return Column(
                                            children: [
                                              snap.data!
                                                      .get("img_url")
                                                      .toString()
                                                      .isEmpty
                                                  ? Image.asset(
                                                      "assets/images/profile.png",
                                                      height: 50,
                                                      width: 70,
                                                    )
                                                  : Image.network(
                                                      snap.data!.get("img_url"),
                                                      height: 50,
                                                      width: 70),
                                              Text(snap.data!.get("name"))
                                            ],
                                          );
                                        } else {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),
                                  SizedBox(
                                    width: defPadding,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Builder(builder: (context) {
                                        final formatter =
                                            intl.DateFormat('MMMM d, y');

                                        return AppText(
                                          text:
                                              formatter.format(DateTime.now()),
                                          clr: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          size: 22,
                                        );
                                      }),
                                      Builder(builder: (context) {
                                        final formatter =
                                            intl.DateFormat('EEEE');

                                        return AppText(
                                          text:
                                              formatter.format(DateTime.now()),
                                          clr: Colors.grey,
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: defPadding,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_feeSubmitted == false)
                                    Text(
                                      lang == "en"
                                          ? "Your fee is pending. Please clear your dues"
                                          : "آپ کی فیس باقی ہے۔ براہ کرم اپنے واجبات کو صاف کریں",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )
                                ],
                              ),
                              SizedBox(
                                height: defPadding,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        sabaqattendance!
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: primaryColor,
                                      ),
                                      SizedBox(
                                        width: defPadding / 2,
                                      ),
                                      lang == "en"
                                          ? const Text(
                                              "Sabaq",
                                            )
                                          : const Text(
                                              "سبق",
                                            ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        sabkiattendance!
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: primaryColor,
                                      ),
                                      SizedBox(
                                        width: defPadding / 2,
                                      ),
                                      lang == "en"
                                          ? const Text(
                                              "Sabqi",
                                            )
                                          : const Text(
                                              "سبکی",
                                            ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        manzilattendance!
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: primaryColor,
                                      ),
                                      SizedBox(
                                        width: defPadding / 2,
                                      ),
                                      lang == "en"
                                          ? const Text(
                                              "Manzil",
                                            )
                                          : const Text(
                                              "منزل",
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: defPadding,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: defPadding / 2),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(defPadding / 3),
                                    border: Border.all(color: Colors.grey)),
                                child: DropdownButton(
                                    borderRadius:
                                        BorderRadius.circular(defPadding),
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    value: _sabaqType,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: [
                                      DropdownMenuItem(
                                        value: "Sabaq",
                                        child: lang == "en"
                                            ? const Text(
                                                "Sabaq",
                                              )
                                            : const Text(
                                                "سبق",
                                              ),
                                      ),
                                      DropdownMenuItem(
                                        value: "Sabki",
                                        child: lang == "en"
                                            ? const Text(
                                                "Sabqi",
                                              )
                                            : const Text(
                                                "سبکی",
                                              ),
                                      ),
                                      DropdownMenuItem(
                                          value: "Manzil",
                                          child: lang == 'en'
                                              ? const Text('Manzil')
                                              : const Text('منزل'))
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _sabaqType = value;
                                      });
                                    }),
                              ),
                              SizedBox(
                                height: defPadding,
                              ),
                              if (_sabaqType == "Sabaq")
                                ...sabaq
                              else if (_sabaqType == "Manzil")
                                ...manzil
                              else if (_sabaqType == "Sabki")
                                ...sabki,
                              SizedBox(
                                height: defPadding,
                              ),
                              Text(lang == 'en' ? "Namaz" : "نماز",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
                              SizedBox(
                                height: defPadding / 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                      text: lang == 'en'
                                          ? "Marked By Parents"
                                          : "والدین کے ذریعہ نشان زد")
                                ],
                              ),
                              SizedBox(
                                height: defPadding,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (providerClass.namaz[0]) {
                                            providerClass.updateList(
                                                num: 0, val: false);
                                          } else {
                                            providerClass.updateList(
                                                num: 0, val: true);
                                          }
                                        },
                                        child: providerClass.namaz[0]
                                            ? Icon(
                                                Icons.check_box,
                                                color: primaryColor,
                                              )
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                color: primaryColor,
                                              ),
                                      ),
                                      SizedBox(
                                        width: defPadding / 2,
                                      ),
                                      const Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Text("فجر")),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (providerClass.namaz[1]) {
                                            providerClass.updateList(
                                                num: 1, val: false);
                                          } else {
                                            providerClass.updateList(
                                                num: 1, val: true);
                                          }
                                        },
                                        child: providerClass.namaz[1]
                                            ? Icon(
                                                Icons.check_box,
                                                color: primaryColor,
                                              )
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                color: primaryColor,
                                              ),
                                      ),
                                      SizedBox(
                                        width: defPadding / 2,
                                      ),
                                      const Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Text("ظہر"))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (providerClass.namaz[2]) {
                                            providerClass.updateList(
                                                num: 2, val: false);
                                          } else {
                                            providerClass.updateList(
                                                num: 2, val: true);
                                          }
                                        },
                                        child: providerClass.namaz[2]
                                            ? Icon(
                                                Icons.check_box,
                                                color: primaryColor,
                                              )
                                            : Icon(
                                                Icons.check_box_outline_blank,
                                                color: primaryColor,
                                              ),
                                      ),
                                      SizedBox(
                                        width: defPadding / 2,
                                      ),
                                      const Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Text("عصر")),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: defPadding / 2,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const SizedBox(),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (providerClass.namaz[3]) {
                                              providerClass.updateList(
                                                  num: 3, val: false);
                                            } else {
                                              providerClass.updateList(
                                                  num: 3, val: true);
                                            }
                                          },
                                          child: providerClass.namaz[3]
                                              ? Icon(
                                                  Icons.check_box,
                                                  color: primaryColor,
                                                )
                                              : Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: primaryColor,
                                                ),
                                        ),
                                        SizedBox(
                                          width: defPadding / 2,
                                        ),
                                        const Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text("مغرب")),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (providerClass.namaz[4]) {
                                              providerClass.updateList(
                                                  num: 4, val: false);
                                            } else {
                                              providerClass.updateList(
                                                  num: 4, val: true);
                                            }
                                          },
                                          child: providerClass.namaz[4]
                                              ? Icon(
                                                  Icons.check_box,
                                                  color: primaryColor,
                                                )
                                              : Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: primaryColor,
                                                ),
                                        ),
                                        SizedBox(
                                          width: defPadding / 2,
                                        ),
                                        const Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text("عشاء")),
                                      ],
                                    )
                                  ]),
                              SizedBox(
                                height: defPadding,
                              ),
                              CommonButton(
                                text: lang == 'en'
                                    ? "Update Namaz"
                                    : "نماز کو اپ ڈیٹ کریں",
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('attendance')
                                      .doc(DateTime.now()
                                          .toString()
                                          .characters
                                          .take(10)
                                          .toString())
                                      .set({
                                    "Namaz": providerClass.namaz,
                                    'date': DateTime.now()
                                        .toString()
                                        .characters
                                        .take(10)
                                        .toString(),
                                    "timestamp": DateTime.now(),
                                  }, SetOptions(merge: true)).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Namaz Updated')));
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Error!')));
                                  });
                                },
                                color: primaryColor,
                                textColor: Colors.white,
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
          ));
    });
  }

  List<Widget> get sabki {
    return [
      FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('attendance')
            .doc(DateTime.now().toString().substring(0, 10))
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading data'),
            );
          } else if (snapshot.hasData && snapshot.data!.exists) {
            var attendanceData = snapshot.data!.data();
            if (attendanceData!.containsKey('Sabki')) {
              var sabkiData = attendanceData['Sabki'];
              return Column(
                children: [
                  const Text(
                    "Parah Name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    sabkiData['para'] ?? 'Data not available',
                  ),
                  SizedBox(height: defPadding / 2),
                  const Text(
                    "Surah Name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(sabkiData['Surah'] ?? 'Data not available'),
                  SizedBox(height: defPadding / 2),
                  const Text(
                    "From Ayah",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(sabkiData['fromAyah']?.toString() ??
                      'Data not available'),
                  SizedBox(height: defPadding / 2),
                  const Text(
                    "To Ayah",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(sabkiData['toAyah']?.toString() ?? 'Data not available')
                ],
              );
            } else {
              return Center(
                child: Text(lang == "en"
                    ? 'Sabqi Attendance Not Marked Yet!'
                    : "سبکی حاضری ابھی تک نشان زد نہیں ہوئی"),
              );
            }
          } else {
            return Center(
              child: Text(lang == "en"
                  ? 'No Attendance has been marked Yet!'
                  : "ابھی تک کوئی حاضری نہیں لگائی گئی"),
            );
          }
        },
      )
    ];
  }

  List<Widget> get manzil {
    return [
      FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('attendance')
            .doc(DateTime.now().toString().substring(0, 10))
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading data'),
            );
          } else if (snapshot.hasData && snapshot.data!.exists) {
            var attendanceData = snapshot.data!.data();
            if (attendanceData!.containsKey('Manzil')) {
              var manzilData = attendanceData['Manzil'];
              return Column(
                children: [
                  const Text(
                    'Parah Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(manzilData['para']),
                ],
              );
            } else {
              // Handle the case where 'manzil' doesn't exist
              return Center(
                child: Text(lang == "en"
                    ? 'Manzil Attendance Not Marked Yet!'
                    : "منزل کی حاضری ابھی تک نشان زد نہیں ہوئی"),
              );
            }
          } else {
            return Center(
              child: Text(lang == "en"
                  ? 'No Attendance has been marked Yet!'
                  : "ابھی تک کوئی حاضری نہیں لگائی گئی"),
            );
          }
        },
      )
    ];
  }

  List<Widget> get sabaq {
    return [
      FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('attendance')
            .doc(DateTime.now().toString().substring(0, 10))
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading data'),
            );
          } else if (snapshot.hasData && snapshot.data!.exists) {
            var attendanceData = snapshot.data!.data();
            if (attendanceData!.containsKey('Sabaq')) {
              return Column(
                children: [
                  const Text(
                    'Parah Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(snapshot.data!['Sabaq']['para']),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  const Text(
                    'From Surah',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(snapshot.data!['Sabaq']['fromSurah']),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  const Text(
                    'To Surah',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(snapshot.data!['Sabaq']['toSurah']),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  const Text(
                    'From Ayah',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(snapshot.data!['Sabaq']['fromAyah'].toString()),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  const Text(
                    'To Ayah',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(snapshot.data!['Sabaq']['toAyah'].toString()),
                ],
              );
            } else {
              // Handle the case where 'manzil' doesn't exist
              return Center(
                child: Text(lang == "en"
                    ? 'Sabaq Attendance Not Marked Yet!'
                    : "سبق کی حاضری ابھی تک نشان زد نہیں ہوئی"),
              );
            }
          } else {
            return Center(
              child: Text(lang == "en"
                  ? 'No Attendance has been Marked Yet!'
                  : "ابھی تک کوئی حاضری نہیں لگائی گئی"),
            );
          }
        },
      )
    ];
  }
}
