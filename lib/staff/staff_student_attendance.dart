import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart' as intl;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../constants.dart';
import '../provider/provider_class.dart';
import '../widget/app_text.dart';
import 'package:quran/quran.dart' as quran;

class StaffStudentAttendance extends StatefulWidget {
  final String studentID;
  final String studentName;
  final String imgURL;
  final bool? isAdmin;

  const StaffStudentAttendance(
      {Key? key,
      required this.studentID,
      required this.studentName,
      required this.imgURL,
      required this.isAdmin})
      : super(key: key);

  @override
  State<StaffStudentAttendance> createState() => _StaffStudentAttendanceState();
}

class _StaffStudentAttendanceState extends State<StaffStudentAttendance> {
  TextEditingController fromAyahController = TextEditingController();
  TextEditingController toAyahController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedPara;
  String? selectedStartSurah;
  String? selectedEndSurah;
  String? fromSurah;
  String? toSurah;

  String? _sabaqType = 'Sabaq';
  List<String>? surahNames = [];

  List? verseStart = [];
  List? verseEnd = [];
  List? versePrintStart = [];
  List? versePrintEnd = [];
  int? selectedStartVerse;
  int? selectedLastVerse;

  List? manzilParaList;
  String? selectedManzilPara;
  String? selectedSabkiPara;
  String? selectedSabkiSurah;
  int? selectedSabkiAyah;

  Map? data;

  bool? sabkiattendance = false;
  bool? sabaqattendance = false;
  bool? manzilattendance = false;

  late User? currentUser;

  @override
  void initState() {
    initialize();
    //_fetchFeeStatus();
    super.initState();
  }

  initialize() async {
    checkAttendance();
    checkManzil();
    await checkSabaqPara();

    //selectedPara = paraNames.first;
  }

  void defaultValues() {
    selectedPara ??= paraNames.first;

    data = quran.getSurahAndVersesFromJuz(paraNames.indexOf(selectedPara!) + 1);
    List keys = data!.keys.toList();

    surahNames = data!.keys.map((key) {
      return quran.getSurahNameArabic(key);
    }).toList();

    selectedStartSurah = surahNames!.first;
    selectedEndSurah = surahNames!.last;

    int indexStart = surahNames!.indexOf(selectedStartSurah!);
    int indexEnd = surahNames!.indexOf(selectedEndSurah!);

    verseStart = data![keys[indexStart]];
    verseEnd = data![keys[indexEnd]];

    if (selectedStartVerse == null && selectedLastVerse == null) {
      selectedStartVerse = verseStart![0];
      selectedLastVerse = verseEnd![0];
    }

    versePrintStart = List.generate(verseStart![1] - verseStart![0] + 1,
        (index) => verseStart![0]! + index);

    versePrintEnd = List.generate(
        verseEnd![1] - verseEnd![0] + 1, (index) => verseEnd![0]! + index);
  }

  Future<void> checkSabaqPara() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.studentID)
        .get();

    if (doc.data() != null) {
      var sabaqData = doc.data() as Map<String, dynamic>;

      if (sabaqData.containsKey('selectedSabaq')) {
        selectedPara = sabaqData['selectedSabaq']['para'];
        selectedStartSurah = sabaqData['selectedSabaq']['fromSurah'];
        selectedEndSurah = sabaqData['selectedSabaq']['toSurah'];
        selectedStartVerse = sabaqData['selectedSabaq']['fromAyah'];
        selectedLastVerse = sabaqData['selectedSabaq']['toAyah'];


        defaultValues();
        setState(() {});
      } else {
        defaultValues();
        setState(() {});
      }
    }
  }

  Future<void> checkManzil() async {
    CollectionReference attendanceCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.studentID)
        .collection('attendance');

    QuerySnapshot querySnapshot = await attendanceCollection
        .orderBy('date', descending: true)
        .limit(2)
        .get();

    DocumentSnapshot lastDocument;
    String lastDocumentID;

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.first;
      lastDocumentID = lastDocument.id;

      // Check if the ID is the current date
      if (lastDocumentID == DateTime.now().toString().substring(0, 10)) {
        if (querySnapshot.docs.length > 1) {
          lastDocument = querySnapshot.docs[1];
        }
      }

      Map<String, dynamic> data = lastDocument.data() as Map<String, dynamic>;

      if (data.containsKey('Manzil')) {
        int index = paraNames.indexOf(lastDocument['Manzil']['para']);
        selectedManzilPara = paraNames[index + 1];
      } else {
        lastDocument = querySnapshot.docs[0];
        data = lastDocument.data() as Map<String, dynamic>;

        if (data.containsKey('Manzil')) {
          int index = paraNames.indexOf(lastDocument['Manzil']['para']);
          selectedManzilPara = paraNames[index + 1];
        } else {
          selectedManzilPara = paraNames[0];
        }
      }
    } else {
      // No Documents
      // First Time Attendance - done
      selectedManzilPara = paraNames[0];
    }
  }

  Future<void> checkAttendance() async {
    // Check if a user is currently signed in

    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.studentID)
        .collection('attendance')
        .doc(DateTime.now().toString().substring(0, 10))
        .get();

    DocumentSnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.studentID)
        .collection('attendance')
        .doc(DateTime.now().toString().substring(0, 10))
        .get();

    if (snapshot.data() != null) {
      if (snapshot.data()!.containsKey("Sabaq") &&
          snapshot2['Sabaq']['fromAyah'] != null) {
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

  bool _feeSubmitted = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void _fetchFeeStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(widget.studentID).get();
      setState(() {
        _feeSubmitted = snapshot['feeSubmitted'] ?? false;
      });
    }
  }

  void deleteUser() async {
    try {
      _firestore.collection('users').doc(widget.studentID).delete();
      final classesCollection =
          FirebaseFirestore.instance.collection('classes');

      final querySnapshot = await classesCollection.get();

      for (final doc in querySnapshot.docs) {
        final classReference = classesCollection.doc(doc.id);

        await classReference.update({
          'students': FieldValue.arrayRemove([widget.studentID]),
        });
      }

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => const AdminHome()));
    } catch (e) {}
  }

  void _updateFeeStatus(bool status) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(widget.studentID).update({
        'feeSubmitted': status,
      });
    }
    _fetchFeeStatus();
  }

  @override
  void dispose() {
    fromAyahController.clear();
    toAyahController.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderClass>(builder: (context, providerClass, child) {
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: primaryColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.studentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
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
                              .collection("attendance")
                              .where("studentId", isEqualTo: widget.studentID)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // providerClass.isUpdated
                              //     ? null
                              //     : {
                              //         // providerClass.updateCompleteList(
                              //         //     list: snapshot.data!.docs.first
                              //         //         .get("Namaz")),
                              //         // providerClass.updateSabaqList(list: []),
                              //       };

                              return Form(
                                  key: _formKey,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                widget.imgURL.isEmpty
                                                    ? Image.asset(
                                                        "assets/images/profile.png",
                                                        height: 50,
                                                        width: 70,
                                                      )
                                                    : Image.network(
                                                        widget.imgURL,
                                                        height: 50,
                                                        width: 70),
                                                Text(widget.studentName)
                                              ],
                                            ),
                                            SizedBox(
                                              width: defPadding,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Builder(builder: (context) {
                                                  final formatter =
                                                      intl.DateFormat(
                                                          'MMMM d, y');

                                                  return AppText(
                                                    text: formatter
                                                        .format(DateTime.now()),
                                                    clr: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    size: 22,
                                                  );
                                                }),
                                                Builder(builder: (context) {
                                                  final formatter =
                                                      intl.DateFormat('EEEE');

                                                  return AppText(
                                                    text: formatter
                                                        .format(DateTime.now()),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  sabaqattendance!
                                                      ? Icons.check_box
                                                      : Icons
                                                          .check_box_outline_blank,
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
                                                      : Icons
                                                          .check_box_outline_blank,
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
                                                      : Icons
                                                          .check_box_outline_blank,
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
                                        SizedBox(
                                          width: 350,
                                          height: 50,
                                          child: ElevatedButton(
                                            child: lang == "en"
                                                ? const Text('Mark Attendance')
                                                : const Text("حاضری لگائیں"),
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(widget.studentID)
                                                  .collection('attendance')
                                                  .doc(DateTime.now()
                                                      .toString()
                                                      .characters
                                                      .take(10)
                                                      .toString())
                                                  .set({
                                                "attendance": true
                                              }, SetOptions(merge: true)).then(
                                                      (value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            'Attendance added/updated Successfully!')));
                                              }).catchError((error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Error!')));
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: defPadding,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: defPadding / 2),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      defPadding / 3),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: DropdownButton(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      defPadding),
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              value: _sabaqType,
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
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
                                        if (_sabaqType == 'Sabki')
                                          ..._sabki
                                        else if (_sabaqType == 'Sabaq')
                                          ..._sabaq
                                        else if (_sabaqType == 'Manzil')
                                          ..._manzil,
                                        SizedBox(
                                          height: defPadding / 2,
                                        ),
                                        Container(
                                          color: Colors.green,
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              lang == "en"
                                                  ? const Text(
                                                      'Student Fee Is Submitted?',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : const Text(
                                                      'کیا طالب علم کی فیس جمع کرائی گئی ہے؟',
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                              const SizedBox(height: 16.0),
                                              lang == "en"
                                                  ? Text(
                                                      'Status: ${_feeSubmitted ? 'Paid' : 'Not Paid'}',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      'حالت: ${_feeSubmitted ? 'ادا کیا' : 'ادا نہیں کیا'}',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                              const SizedBox(height: 32.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _updateFeeStatus(
                                                          true); // Set fee status to true
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.green[600],
                                                    ),
                                                    child: lang == "en"
                                                        ? const Text('Yes')
                                                        : const Text('جی ہاں'),
                                                  ),
                                                  const SizedBox(width: 16.0),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _updateFeeStatus(
                                                          false); // Set fee status to false
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.green[600],
                                                    ),
                                                    child: lang == "en"
                                                        ? const Text('NO')
                                                        : const Text('نہیں'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: defPadding,
                                        ),
                                        lang == 'en'
                                            ? Text("Namaz",
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ))
                                            : Text("نماز",
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                )),
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
                                                    if (providerClass
                                                        .namaz[0]) {
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
                                                          Icons
                                                              .check_box_outline_blank,
                                                          color: primaryColor,
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: defPadding / 2,
                                                ),
                                                const Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: Text("فجر")),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (providerClass
                                                        .namaz[1]) {
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
                                                          Icons
                                                              .check_box_outline_blank,
                                                          color: primaryColor,
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: defPadding / 2,
                                                ),
                                                const Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: Text("ظہر")),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (providerClass
                                                        .namaz[2]) {
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
                                                          Icons
                                                              .check_box_outline_blank,
                                                          color: primaryColor,
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: defPadding / 2,
                                                ),
                                                const Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
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
                                                    if (providerClass
                                                        .namaz[3]) {
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
                                                          Icons
                                                              .check_box_outline_blank,
                                                          color: primaryColor,
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: defPadding / 2,
                                                ),
                                                const Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: Text("مغرب")),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (providerClass
                                                        .namaz[4]) {
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
                                                          Icons
                                                              .check_box_outline_blank,
                                                          color: primaryColor,
                                                        ),
                                                ),
                                                SizedBox(
                                                  width: defPadding / 2,
                                                ),
                                                const Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: Text("عشاء")),
                                              ],
                                            ),
                                            const SizedBox(),
                                          ],
                                        ),
                                        SizedBox(
                                          height: defPadding,
                                        ),
                                        widget.isAdmin!
                                            ? SizedBox(
                                                width: 350,
                                                height: 50,
                                                child: ElevatedButton(
                                                  child: lang == "en"
                                                      ? const Text(
                                                          'Download Report')
                                                      : const Text(
                                                          "رپورٹ ڈاؤن لوڈ کریں۔"),
                                                  onPressed: () async {
                                                    String studentName = '';
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("users"
                                                            "")
                                                        .doc(snapshot
                                                            .data!.docs.first
                                                            .get("studentId"))
                                                        .get()
                                                        .then((value) {
                                                      setState(() {
                                                        studentName =
                                                            value.get("name");
                                                      });
                                                    });
                                                    generatePdf(
                                                        snapshot
                                                            .data!.docs.first
                                                            .get("studentId"),
                                                        studentName);
                                                  },
                                                ),
                                              )
                                            : const SizedBox()
                                      ]));
                            } else if (snapshot.hasError) {
                              return const Center(child: Text("Error"));
                            } else {
                              return const Text('Loading');
                            }
                          })))));
    });
  }

  List<Widget> get _sabki {
    return [
      Column(
        children: [
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.studentID)
                  .get(),
              builder: ((context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done &&
                    snapshot.data!.exists) {
                  Map<String, dynamic> sabqiData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  if (sabqiData.containsKey('selectedSabqi')) {
                    selectedSabkiPara = snapshot.data!['selectedSabqi']['para'];
                    selectedSabkiAyah =
                        snapshot.data!['selectedSabqi']['toAyah'];
                    selectedSabkiSurah =
                        snapshot.data!['selectedSabqi']['toSurah'];

                    return Column(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: defPadding / 2),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(defPadding / 3),
                                border: Border.all(color: Colors.grey)),
                            child: DropdownButton(
                              hint:
                                  Text(snapshot.data!['selectedSabqi']['para']),
                              borderRadius: BorderRadius.circular(defPadding),
                              isExpanded: true,
                              underline: const SizedBox(),
                              value: selectedSabkiPara,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: const [],
                              onChanged: (value) {},
                            )),
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
                              hint: Text(
                                  snapshot.data!['selectedSabqi']['toSurah']),
                              borderRadius: BorderRadius.circular(defPadding),
                              isExpanded: true,
                              underline: const SizedBox(),
                              value: selectedSabkiPara,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: const [],
                              onChanged: (value) {},
                            )),
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
                              hint: lang == "en"
                                  ? const Text(
                                      "From Ayah: Start of Parah",
                                    )
                                  : const Text(
                                      "آیت: پارہ کا آغاز",
                                    ),
                              borderRadius: BorderRadius.circular(defPadding),
                              isExpanded: true,
                              underline: const SizedBox(),
                              value: selectedSabkiPara,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: const [],
                              onChanged: (value) {},
                            )),
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
                              hint: lang == "en"
                                  ? Text(
                                      "To Ayah: ${snapshot.data!['selectedSabqi']['toAyah']}")
                                  : Text(
                                      "آیت تک: ${snapshot.data!['selectedSabqi']['toAyah']}"),
                              borderRadius: BorderRadius.circular(defPadding),
                              isExpanded: true,
                              underline: const SizedBox(),
                              value: selectedSabkiPara,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: const [],
                              onChanged: (value) {},
                            )),
                        SizedBox(
                          height: defPadding,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  disabledBackgroundColor: Colors.grey,
                                  disabledForegroundColor: Colors.white
                                  // Set text color to white
                                  ),
                              onPressed: (selectedSabkiPara == null ||
                                      selectedSabkiAyah == null ||
                                      selectedSabkiSurah == null)
                                  ? null
                                  : () {
                                      markSabkiAttendance();
                                    },
                              child: lang == 'en'
                                  ? const Text(
                                      'Save Sabki Attendance',
                                    )
                                  : const Text(
                                      'سبکی حاضری لگائیں',
                                    )),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                        child: Text('Please Update Sabaq First'));
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return const Text('Please Update Sabaq First');
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
        ],
      )
    ];
  }

  List<Widget> get _manzil {
    return [
      Column(
        children: [
          SizedBox(
            height: defPadding / 2,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defPadding / 3),
                  border: Border.all(color: Colors.grey)),
              child: DropdownButton(
                hint: lang == "en"
                    ? const Text(
                        "Manzil",
                      )
                    : const Text(
                        "منزل",
                      ),
                borderRadius: BorderRadius.circular(defPadding),
                isExpanded: true,
                underline: const SizedBox(),
                value: selectedManzilPara,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: paraNames.map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedManzilPara = newValue as String;
                  });
                },
              )),
        ],
      ),
      SizedBox(
        height: defPadding / 2,
      ),
      SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              // Set text color to white
            ),
            onPressed: () {
              markManzilAttendance();
            },
            child: lang == 'en'
                ? const Text('Save Manzil')
                : const Text('منزل حاضری لگائیں')),
      )
    ];
  }

  List<Widget> get _sabaq {
    return [
      selectedPara == null
          ? const CircularProgressIndicator()
          : Column(
              children: [
                if (lang == 'en') ...[
                  const Text(
                    'Parah',
                  ),
                ] else ...[
                  const Text("پارہ")
                ],
                IgnorePointer(
                  ignoring: !widget.isAdmin!,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defPadding / 3),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButton(
                      hint: AppText(text: "Parah"),
                      borderRadius: BorderRadius.circular(defPadding / 3),
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: selectedPara,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: paraNames.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          // Assign a unique value for each item
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedPara =
                              newValue as String; // Cast newValue to String

                          data = quran.getSurahAndVersesFromJuz(
                              paraNames.indexOf(selectedPara!) + 1);
                          List keys = data!.keys.toList();

                          surahNames = data!.keys.map((key) {
                            return quran.getSurahNameArabic(key);
                          }).toList();

                          selectedStartSurah = surahNames!.first;
                          selectedEndSurah = surahNames!.last;

                          int indexStart =
                              surahNames!.indexOf(selectedStartSurah!);
                          int indexEnd = surahNames!.indexOf(selectedEndSurah!);

                          verseStart = data![keys[indexStart]];
                          verseEnd = data![keys[indexEnd]];

                          selectedStartVerse = verseStart![0];
                          selectedLastVerse = verseEnd![0];

                          versePrintStart = List.generate(
                              verseStart![1] - verseStart![0] + 1,
                              (index) => verseStart![0]! + index);

                          versePrintEnd = List.generate(
                              verseEnd![1] - verseEnd![0] + 1,
                              (index) => verseEnd![0]! + index);

                          // verseNumbers = data![keys[index]];

                          // versePrint = List.generate(
                          //     verseNumbers![1] - verseNumbers![0] + 1,
                          //     (index) => verseNumbers![0]! + index);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: defPadding,
                ),
                lang == "en"
                    ? const Text(
                        "From Surat",
                      )
                    : const Text(
                        "سورت سے",
                      ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defPadding / 3),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButton(
                      hint: AppText(text: "From Surah"),
                      borderRadius: BorderRadius.circular(defPadding),
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: selectedStartSurah,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: surahNames!.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedStartSurah = newValue as String;

                          List keys = data!.keys.toList();
                          if (surahNames!.indexOf(selectedStartSurah!) >
                              surahNames!.indexOf(selectedEndSurah!)) {
                            selectedEndSurah = selectedStartSurah;
                          }

                          int indexStart =
                              surahNames!.indexOf(selectedStartSurah!);
                          int indexEnd = surahNames!.indexOf(selectedEndSurah!);

                          verseStart = data![keys[indexStart]];
                          verseEnd = data![keys[indexEnd]];

                          selectedStartVerse = verseStart![0];
                          selectedLastVerse = verseEnd![0];

                          versePrintStart = List.generate(
                              verseStart![1] - verseStart![0] + 1,
                              (index) => verseStart![0]! + index);

                          versePrintEnd = List.generate(
                              verseEnd![1] - verseEnd![0] + 1,
                              (index) => verseEnd![0]! + index);
                        });
                      },
                    )),
                SizedBox(
                  height: defPadding,
                ),
                if (lang == 'en') ...[
                  const Text(
                    'To Surat',
                  ),
                ] else ...[
                  const Text("سورت تک")
                ],
                Container(
                    padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defPadding / 3),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButton(
                      hint: AppText(text: "To Surah"),
                      borderRadius: BorderRadius.circular(defPadding),
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: selectedEndSurah,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: surahNames!.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedEndSurah = newValue as String;

                          List keys = data!.keys.toList();
                          if (surahNames!.indexOf(selectedEndSurah!) <
                              surahNames!.indexOf(selectedStartSurah!)) {
                            selectedStartSurah = selectedEndSurah;
                          }

                          int indexStart =
                              surahNames!.indexOf(selectedStartSurah!);
                          int indexEnd = surahNames!.indexOf(selectedEndSurah!);

                          verseStart = data![keys[indexStart]];
                          verseEnd = data![keys[indexEnd]];

                          selectedStartVerse = verseStart![0];
                          selectedLastVerse = verseEnd![0];

                          versePrintStart = List.generate(
                              verseStart![1] - verseStart![0] + 1,
                              (index) => verseStart![0]! + index);

                          versePrintEnd = List.generate(
                              verseEnd![1] - verseEnd![0] + 1,
                              (index) => verseEnd![0]! + index);
                        });
                      },
                    )),
                SizedBox(
                  height: defPadding,
                ),
                if (lang == 'en') ...[
                  const Text(
                    'From Ayat',
                  ),
                ] else ...[
                  const Text("آیت سے")
                ],
                Container(
                    padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defPadding / 3),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButton(
                      hint: AppText(text: "From Ayah"),
                      borderRadius: BorderRadius.circular(defPadding),
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: selectedStartVerse,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: versePrintStart!
                          .map((x) => DropdownMenuItem(
                              value: x,
                              child: Text(
                                '$x',
                              )))
                          .toList(),
                      onChanged: (x) {
                        setState(() {
                          selectedStartVerse = x as int;
                        });
                      },
                    )),
                SizedBox(
                  height: defPadding,
                ),
                if (lang == 'en') ...[
                  const Text(
                    'To Ayat',
                  ),
                ] else ...[
                  const Text("آیت تک")
                ],
                Container(
                    padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defPadding / 3),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButton(
                      hint: const Text('To Ayah'),
                      borderRadius: BorderRadius.circular(defPadding),
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: selectedLastVerse,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: versePrintEnd!
                          .map((x) => DropdownMenuItem(
                              value: x,
                              child: Text(
                                '$x',
                              )))
                          .toList(),
                      onChanged: (x) {
                        setState(() {
                          selectedLastVerse = x as int;
                        });
                      },
                    )),
                SizedBox(
                  height: defPadding,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        // Set text color to white
                      ),
                      onPressed: () {
                        markSabaqAttendance();
                      },
                      child: lang == 'en'
                          ? const Text('Mark Sabaq Attendance')
                          : const Text('سبق حاضری لگائیں')),
                ),
                SizedBox(
                  height: defPadding / 2,
                ),
                if (widget.isAdmin!) ...[
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          // Set text color to white
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.studentID)
                              .set({
                            "selectedSabaq": {
                              "para": selectedPara,
                              "fromSurah": selectedStartSurah,
                              "toSurah": selectedEndSurah,
                              "fromAyah": selectedStartVerse,
                              "toAyah": selectedLastVerse
                            },
                          }, SetOptions(merge: true)).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Parah Saved Successfully!')));
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error!')));
                          });
                        },
                        child: lang == 'en'
                            ? const Text('Save Sabaq Parah')
                            : const Text('سبق پارہ لگائیں')),
                  )
                ]
              ],
            )
    ];
  }

  void markManzilAttendance() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.studentID)
        .collection('attendance')
        .doc(DateTime.now().toString().characters.take(10).toString())
        .set({
      'studentId': widget.studentID,
      'date': DateTime.now().toString().characters.take(10).toString(),
      "timestamp": DateTime.now(),
      'teacherID': FirebaseAuth.instance.currentUser!.uid,
      "attendance": true,
      "Manzil": {
        "para": selectedManzilPara,
      },
    }, SetOptions(merge: true)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Attendance added/updated Successfully!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error!')));
    });

    if (manzilattendance == false) {
      setState(() {
        manzilattendance = true;
      });
    }
  }

  void markSabkiAttendance() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.studentID)
        .collection('attendance')
        .doc(DateTime.now().toString().characters.take(10).toString())
        .set({
      'studentId': widget.studentID,
      'date': DateTime.now().toString().characters.take(10).toString(),
      "timestamp": DateTime.now(),
      'teacherID': FirebaseAuth.instance.currentUser!.uid,
      'attendance': true,
      "Sabki": {
        "para": selectedPara,
        "Surah": selectedSabkiSurah,
        "fromAyah": "Start of Parah",
        "toAyah": selectedSabkiAyah
      },
    }, SetOptions(merge: true)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Attendance added/updated Successfully!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error!')));
    });

    if (sabkiattendance == false) {
      setState(() {
        sabkiattendance = true;
      });
    }
  }

  void markSabaqAttendance() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.studentID)
        .collection('attendance')
        .doc(DateTime.now().toString().characters.take(10).toString())
        .set({
      'studentId': widget.studentID,
      'date': DateTime.now().toString().characters.take(10).toString(),
      "timestamp": DateTime.now(),
      'teacherID': FirebaseAuth.instance.currentUser!.uid,
      'attendance': true,
      "Sabaq": {
        "para": selectedPara,
        "fromSurah": selectedStartSurah,
        "toSurah": selectedEndSurah,
        "fromAyah": selectedStartVerse,
        "toAyah": selectedLastVerse
      },
    }, SetOptions(merge: true)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Attendance added/updated Successfully!')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error!')));
    });

    FirebaseFirestore.instance.collection('users').doc(widget.studentID).set({
      "selectedSabqi": {
        'para': selectedPara,
        "fromSurah": selectedStartSurah,
        "toSurah": selectedEndSurah,
        "fromAyah": selectedStartVerse,
        "toAyah": selectedLastVerse
      },
      "selectedSabaq": {
        'para': selectedPara,
        "fromSurah": selectedStartSurah,
        "toSurah": selectedEndSurah,
        "fromAyah": selectedStartVerse,
        "toAyah": selectedLastVerse
      },
    }, SetOptions(merge: true));

    if (sabaqattendance == false) {
      setState(() {
        sabaqattendance = true;
      });
    }
  }

  Future<void> showNotification(Uint8List pdfBytes) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Hifz Diary',
      'Pdf Downloaded',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'PDF Saved',
      'Tap to open the PDF file',
      platformChannelSpecifics,
      // payload: pdfBytes.toString(),
    );
  }

  void generatePdf(String studentId, String studentName) async {
    final List<Map<String, dynamic>> data = await fetchFirestoreData(studentId);
    final List<pw.Widget> pdfContent =
        await generatePdfContent(data, studentName);

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: pdfContent,
          );
        },
      ),
    );

    final Uint8List pdfBytes = await pdf.save();

    // Save the PDF file or use any desired method (e.g., share, print, etc.)
    await Printing.sharePdf(
        bytes: pdfBytes, filename: '$studentName Attendance.pdf');
    await showNotification(pdfBytes);
  }

  Future<List<pw.Widget>> generatePdfContent(
    List<Map<String, dynamic>> data,
    String name,
  ) async {
    final urduFont =
        pw.Font.ttf(await rootBundle.load('assets/json/urdu_font.ttf'));

    // List<Map<String, dynamic>> finalData = jsonDecode(data);
    final List<pw.Widget> content = [];
    content.add(pw.Text("$name Attendance",
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)));
    content.add(pw.Divider());
    content.add(pw.SizedBox(height: defPadding));
    content.add(pw.Row(children: [
      pw.Expanded(
          child: pw.Text("Date",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      pw.Expanded(
          child: pw.Text("Sabaq",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      pw.Expanded(
          child: pw.Text("Sabqi",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      pw.Expanded(
          child: pw.Text("Manzal",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
    ]));

    // Add data to the PDF content
    for (final item in data) {
      content.add(pw.Column(children: [
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text(
                item['date'],
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Expanded(
              child: (item['Sabaq']["para"]!.toString().isEmpty)
                  ? pw.Text(
                      "No",
                      style: pw.TextStyle(
                          color: PdfColors.red, fontWeight: pw.FontWeight.bold),
                    )
                  : pw.Text(
                      "Yes",
                      style: pw.TextStyle(
                          color: PdfColors.green,
                          fontWeight: pw.FontWeight.bold),
                    ),
            ),
            pw.Expanded(
              child: pw.Text(
                (item['Sabqi'] ?? true) ? "Not Good" : "Good",

                // item['Sabqi'].toString(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                (item['Manzil'] ?? true) ? "Not Good" : "Good",
                // item['Manzil'].toString(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
      ]));
      // content.add(pw.Text(item['date'].toString()));
    }

    return content;
  }

  Future<List<Map<String, dynamic>>> fetchFirestoreData(
      String studentID) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .orderBy("timestamp", descending: true)
        .where('studentId', isEqualTo: studentID)
        .get();

    final List<Map<String, dynamic>> data =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    return data;
  }
/*
  Future<void> checkAndCreateDocument(
      {required String studentId, required String date}) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('attendance');

      // Query the Firestore collection to check if the document exists
      final querySnapshot = await collectionRef
          .where('studentId', isEqualTo: studentId)
          .where('date', isEqualTo: date)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Document does not exist, create a new document
        await collectionRef.add({
          'studentId': studentId,
          'date': DateTime.now().toString().characters.take(10).toString(),
          "timestamp": DateTime.now(),
          'teacherID': FirebaseAuth.instance.currentUser!.uid,
          'Attendance': "",
          "Sabaq": {
            "para": "",
            "fromSurah": "",
            "toSurah": "",
            "fromAyah": "",
            "toAyah": ""
          },
          "Sabqi": false,
          "Manzil": false,
          "Namaz": [false, false, false, false, false],
          "notify": false,
        });

        print('Document created successfully.');
      } else {
        print('Document already exists.');
      }
    } catch (e) {
      print('Error: $e');
      // Handle any errors that occur during the process
    }
  }*/
}
