import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  Future<void> generateAndUploadPdf(String type) async {
    try {
      // Replace 'uid' with your actual user ID
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

      if (userSnapshot.exists) {
        String studentName = userSnapshot.data()?['name'] ?? 'Unknown';
        String studentFolder = studentName.replaceAll(" ", "_");
        QuerySnapshot<Map<String, dynamic>> querySnapshot;

        if (type == "weekly") {
          querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('attendance')
              .where('timestamp',
                  isGreaterThan:
                      DateTime.now().subtract(const Duration(days: 7)))
              .orderBy('timestamp', descending: true)
              .get();
        } else if (type == "monthly") {
          DateTime now = DateTime.now();
          DateTime lastMonthStart = DateTime(now.year, now.month - 1, now.day);
          DateTime lastMonthEnd = DateTime(now.year, now.month, now.day)
              .subtract(const Duration(days: 1));

          querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('attendance')
              .where('timestamp', isGreaterThanOrEqualTo: lastMonthStart)
              .where('timestamp', isLessThanOrEqualTo: lastMonthEnd)
              .orderBy('timestamp', descending: true)
              .get();
        } else if (type == "yearly") {
          DateTime now = DateTime.now();
          DateTime lastYearStart = DateTime(now.year - 1, now.month, now.day);
          DateTime lastYearEnd = DateTime(now.year, now.month, now.day)
              .subtract(const Duration(days: 1));

          querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('attendance')
              .where('timestamp', isGreaterThanOrEqualTo: lastYearStart)
              .where('timestamp', isLessThanOrEqualTo: lastYearEnd)
              .orderBy('timestamp', descending: true)
              .get();
        } else {
          querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('attendance')
              .where('timestamp',
                  isGreaterThan:
                      DateTime.now().subtract(const Duration(days: 7)))
              .orderBy('timestamp', descending: true)
              .get();
        }

        // Replace 'attendance' with your actual collection

        List<Map<String, dynamic>> documents =
            querySnapshot.docs.map((doc) => doc.data()).toList();

        // Create PDF document
        final pdf = pw.Document();

        // Use a font that supports Arabic characters

        final fallbackFont = pw.Font.ttf(await rootBundle
            .load('assets/fonts/static/NotoNaskhArabic-Medium.ttf'));

        final theme = pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle
              .load('assets/fonts/static/NotoNaskhArabic-Medium.ttf')),
          bold: pw.Font.ttf(await rootBundle
              .load('assets/fonts/static/NotoNaskhArabic-Medium.ttf')),
        );

        pdf.addPage(
          pw.MultiPage(
              pageTheme: pw.PageTheme(
                theme: theme,
                pageFormat: PdfPageFormat.a4,
              ),
              build: (pw.Context context) {
                return [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: documents.map(
                      (document) {
                        return pw.Column(children: [
                          pw.Text(
                            'Name: $studentName', // Replace 'date' with the actual field containing the date

                            style: pw.TextStyle(
                              font: fallbackFont,
                              fontFallback: [fallbackFont],
                              fontSize: 12,
                            ),
                          ),
                          pw.Text(
                            'Date: ${document['date'] ?? ''}', // Replace 'date' with the actual field containing the date

                            style: pw.TextStyle(
                              font: fallbackFont,
                              fontFallback: [fallbackFont],
                              fontSize: 12,
                            ),
                          ),
                          pw.Container(
                            margin: const pw.EdgeInsets.only(bottom: 8),
                            child: pw.Text(
                              "Attendance: ${document['Attendance'] ?? ''}\n",
                              style: pw.TextStyle(
                                  font: fallbackFont,
                                  fontFallback: [fallbackFont],
                                  fontSize: 12),
                            ),
                          ),
                          pw.Container(
                            margin: const pw.EdgeInsets.only(bottom: 8),
                            child: pw.Row(children: [
                              pw.Text(
                                "Manzil Para: ",
                                style: pw.TextStyle(
                                    font: fallbackFont,
                                    fontFallback: [fallbackFont],
                                    fontSize: 12),
                              ),
                              pw.Text(
                                "${document['Manzil']?['para'] ?? ''}\n",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    font: fallbackFont,
                                    fontFallback: [fallbackFont],
                                    fontSize: 12),
                              ),
                            ]),
                          ),
                          pw.Divider(),
                          // Sabaq
                          pw.Container(
                            margin: const pw.EdgeInsets.only(bottom: 8),
                            child: pw.Column(children: [
                              pw.Row(children: [
                                pw.Text(
                                  "Sabaq Para: ",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                                pw.Text(
                                  "${document['Sabaq']?['para'] ?? ''}\n",
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                              ]),
                              pw.Row(children: [
                                pw.Text(
                                  "Sabaq from Surah: ",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                                pw.Text(
                                  "${document['Sabaq']?['fromSurah'] ?? ''}\n",
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                              ]),
                              pw.Row(children: [
                                pw.Text(
                                  "Sabaq to Surah: ",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                                pw.Text(
                                  "${document['Sabaq']?['toSurah'] ?? ''}\n",
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                              ]),
                              pw.Row(children: [
                                pw.Text(
                                  "Sabaq from Ayah: ",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                                pw.Text(
                                  "${document['Sabaq']?['fromAyah'] ?? ''}\n",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                              ]),
                              pw.Row(children: [
                                pw.Text(
                                  "Sabaq to Ayah: ",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                                pw.Text(
                                  "${document['Sabaq']?['toAyah'] ?? ''}\n",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                              ])
                            ]),
                          ),
                          pw.Divider(),
                          // Sabki
                          pw.Container(
                            margin: const pw.EdgeInsets.only(bottom: 8),
                            child: pw.Column(children: [
                              pw.Row(children: [
                                pw.Text(
                                  "Sabki Para: ",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                                pw.Text(
                                  "${document['Sabki']?['para'] ?? ''}\n",
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                              ]),
                              pw.Row(children: [
                                pw.Text(
                                  "Sabki Surah: ",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                                pw.Text(
                                  "${document['Sabki']?['Surah'] ?? ''}\n",
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                              ]),
                              pw.Row(children: [
                                pw.Text(
                                  "Sabki from Ayah: ",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                                pw.Text(
                                  "${document['Sabki']?['fromAyah'] ?? ''}\n",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                              ]),
                              pw.Row(children: [
                                pw.Text(
                                  "Sabki to Ayah: ",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                                pw.Text(
                                  "${document['Sabki']?['toAyah'] ?? ''}\n",
                                  style: pw.TextStyle(
                                      font: fallbackFont,
                                      fontFallback: [fallbackFont],
                                      fontSize: 12),
                                ),
                              ])
                            ]),
                          ),
                        ]);
                      },
                    ).toList(),
                  ),
                ];
              }),
        );

        // Get the application documents directory
        final appDocDir = await getApplicationDocumentsDirectory();
        final studentDir = Directory('${appDocDir.path}/pdf/$studentFolder');
        studentDir.createSync(recursive: true);

        // Save PDF to file
        final file = File("${studentDir.path}/attendance_report.pdf");
        await file.writeAsBytes(await pdf.save());

        // Upload PDF to Firebase Storage
        final storage = FirebaseStorage.instance;
        final storageRef =
            storage.ref().child('pdfs/$studentFolder/attendance_report.pdf');
        await storageRef.putFile(file);

// Get download URL after successful upload
        String downloadURL = await storageRef.getDownloadURL();

// Print success message
        print('PDF successfully generated and uploaded to Firebase Storage');

// Download PDF from Firebase Storage
        final Directory? downloadDir =
            await getExternalStorageDirectory(); // or getApplicationDocumentsDirectory()
        final File downloadedFile =
            File("${downloadDir!.path}/attendance_report.pdf");

        await storage.refFromURL(downloadURL).writeToFile(downloadedFile);

        OpenFile.open(downloadedFile.path);

        print('PDF downloaded to: ${downloadedFile.path}');
      } else {
        print('User not found');
      }
    } catch (error) {
      // Print error message
      print('Error generating, saving, or uploading PDF: $error');
    }
  }
}
