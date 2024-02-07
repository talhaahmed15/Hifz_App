import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/parents/attendance_generator.dart';
import 'package:hafiz_diary/parents/parents_application.dart';
import 'package:hafiz_diary/parents/parents_fee.dart';
import 'package:hafiz_diary/widget/common_button.dart';

import '../constants.dart';
import '../widget/app_text.dart';

class ParentsNotes extends StatefulWidget {
  const ParentsNotes({Key? key}) : super(key: key);

  @override
  State<ParentsNotes> createState() => _ParentsNotesState();
}

class _ParentsNotesState extends State<ParentsNotes> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                lang == "en"
                    ? const Text("Notes", style: TextStyle(fontSize: 18))
                    : const Text(
                        "نوٹس",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                lang == "en"
                    ? const Text("Add Notes About Your Madrasah",
                        style: TextStyle(color: Colors.white60, fontSize: 12))
                    : const Text(
                        "اپنے مدرسہ کے بارے میں نوٹس شامل کریں",
                        style: TextStyle(color: Colors.white60, fontSize: 12),
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(defPadding),
                child: Column(
                  children: [
                    // CustomTextField(
                    //     validation: false,
                    //     controller: controller,
                    //     lableText: "Heading"),
                    // SizedBox(
                    //   height: defPadding / 2,
                    // ),
                    // CustomTextField(
                    //     validation: false,
                    //     controller: controller,
                    //     lableText: "Add your notes",
                    //     maxLines: 5),
                    // SizedBox(
                    //   height: defPadding / 2,
                    // ),
                    // CommonButton(
                    //   text: "Add Note",
                    //   onTap: () {},
                    //   color: primaryColor,
                    //   textColor: Colors.white,
                    // ),
                    SizedBox(
                      height: defPadding,
                    ),
                    CommonButton(
                        text: lang == "en"
                            ? "Submit Application"
                            : "درخواست جمع کرائیں",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ParentsApplication(),
                            ),
                          );
                        },
                        color: primaryColor,
                        textColor: Colors.white),
                    SizedBox(
                      height: defPadding / 2,
                    ),

                    CommonButton(
                      text: lang == "en"
                          ? "Download Weekly Report"
                          : "ہفتہ وار رپورٹ ڈاؤن لوڈ کریں",
                      onTap: () async {
                        PdfGenerator().generateAndUploadPdf("weekly");
                      },
                      color: primaryColor,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      height: defPadding / 2,
                    ),
                    CommonButton(
                      text: lang == "en"
                          ? "Download Monthly Report"
                          : "ماہانہ رپورٹ ڈاؤن لوڈ کریں",
                      onTap: () async {
                        PdfGenerator().generateAndUploadPdf("monthly");
                      },
                      color: primaryColor,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      height: defPadding / 2,
                    ),
                    CommonButton(
                      text: lang == "en"
                          ? "Download Yearly Report"
                          : "سالانہ رپورٹ ڈاؤن لوڈ کریں۔",
                      onTap: () async {
                        PdfGenerator().generateAndUploadPdf("yearly");
                      },
                      color: primaryColor,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: defPadding / 2),
                    CommonButton(
                      text: lang == "en" ? "Pay Fees" : "فیس ادا کریں",
                      onTap: () async {
                        DocumentSnapshot doc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();

                        String mname = doc.get('madrasah_name') ?? "";
                        String name = doc.get('name') ?? "";

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParentFee(mname, name)));
                      },
                      color: primaryColor,
                      textColor: Colors.white,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("notes")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(defPadding),
                                margin: EdgeInsets.symmetric(
                                    vertical: defPadding / 2),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(defPadding),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: snapshot.data!.docs[index]
                                          .get("heading"),
                                      fontWeight: FontWeight.bold,
                                      clr: primaryColor,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      height: defPadding / 2,
                                    ),
                                    AppText(
                                      text: snapshot.data!.docs[index]
                                          .get("notes"),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Added By:",
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  fontSize: 12),
                                            ),
                                            FutureBuilder(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection("users")
                                                    .doc(snapshot
                                                        .data!.docs[index]
                                                        .get("added_by"))
                                                    .get(),
                                                builder: (context, snap) {
                                                  if (snap.data != null) {
                                                    return Text(
                                                      snap.data!.get("name"),
                                                      style: TextStyle(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          fontSize: 12),
                                                    );
                                                  } else if (snap.hasData) {
                                                    return const Center(
                                                      child: Text("No Data"),
                                                    );
                                                  } else {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                })
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Date:",
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  .get("date"),
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

/*
  void generatePdf(String studentId, String studentName, DateTime startDate,
      DateTime endDate) async {
    Timestamp startTimestamp = Timestamp.fromDate(startDate);
    Timestamp endTimeStamp = Timestamp.fromDate(endDate);
    final List<Map<String, dynamic>> data =
        await fetchFirestoreData(studentId, startTimestamp, endTimeStamp);

    final List<pw.Widget> pdfContent = await generatePdfContent(
        data, studentName, startTimestamp, endTimeStamp);

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
      bytes: pdfBytes,
      filename: '$studentName Attendance.pdf',
    );
  }

  Future<List<pw.Widget>> generatePdfContent(List<Map<String, dynamic>> data,
      String name, Timestamp startTime, Timestamp endTime) async {
    final List<pw.Widget> content = [];
    content.add(pw.Text(
      "$name Attendance",
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
    ));
    content.add(pw.SizedBox(height: 8));
    content.add(pw.Row(children: [
      pw.Text(
        "From: ${DateFormat('yyyy-MM-dd').format(startTime.toDate())}    To: ${DateFormat('yyyy-MM-dd').format(endTime.toDate())}",
      )
    ]));
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
                DateFormat('yyyy-MM-dd').format(
                    item['date'].toDate()), // Format the date using DateFormat
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                (item['Sabaq']?['para']?.toString().isEmpty ?? true)
                    ? "No"
                    : "Yes",
                style: pw.TextStyle(
                  color: (item['Sabaq']?['para']?.toString().isEmpty ?? true)
                      ? PdfColors.red
                      : PdfColors.green,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                (item['Sabqi'] ?? true) ? "Not Good" : "Good",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                (item['Manzil'] ?? true) ? "Not Good" : "Good",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
      ]));
    }

    return content;
  }

  Future<List<Map<String, dynamic>>> fetchFirestoreData(String studentID,
      Timestamp startTimestamp, Timestamp endTimeStamp) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(studentID)
        .collection("attendance")
        .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
        .where('timestamp', isLessThanOrEqualTo: endTimeStamp)
        .get();

    print(snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }*/
}
