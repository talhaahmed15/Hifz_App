import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafiz_diary/NewScreens/join.dart';
import 'package:hafiz_diary/admin/bottom_navigation.dart';
import 'package:hafiz_diary/constants.dart';
import 'package:hafiz_diary/parents/parents_login.dart';
import 'package:hafiz_diary/staff/staff_bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class AuthServices {
  signup(
      {required String email,
      required String password,
      required Map<String, dynamic> data,
      required BuildContext context}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(value.user!.uid)
          .set(data)
          .whenComplete(() async {
        if (data["type"] == "0") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("currentUserId", value.user!.uid);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminHomeNavigation(
                        madrisaName: data["madrasah_name"],
                      )));
        }
        if (data["type"] == "1") {
          FirebaseFirestore.instance
              .collection("users")
              .doc(value.user!.uid)
              .set({
            "class_name": "",
            "class_code": "",
            "addresss": "",
            "class_strength": " ",
          }, SetOptions(merge: true));

          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              TextEditingController credentialsController =
                  TextEditingController(
                text: "Email: $email and Password: $password",
              );

              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Profile Setup Successfully",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                )),
                content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Account's Approval Pending!",
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: credentialsController,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: credentialsController.text),
                              );
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Credentials copied to clipboard'),
                                ),
                              );
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "Credentials",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                primaryColor), // Set your desired background color here
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StaffBottomNavigation(
                                        madrisaName: data["madrasah_name"],
                                        isApproved: data["status"])));
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ]),
              );
            },
          );
        } else if (data["type"] == "2") {
          //no need else if or else
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              TextEditingController credentialsController0 =
                  TextEditingController(
                text: "Email: $email and Password: $password",
              );

              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Profile Setup Successfully",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                )),
                content: Container(
                  width: 350,
                  height: 150,
                  margin: const EdgeInsets.only(top: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Account's Approval Pending!",
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: credentialsController0,
                          readOnly: true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                      text: credentialsController0.text),
                                );
                                ScaffoldMessenger.of(dialogContext)
                                    .showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Credentials copied to clipboard'),
                                  ),
                                );
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: "Credentials",
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor), // Set your desired background color here
                            ),
                            onPressed: () {
                              Navigator.pop(dialogContext);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ParentsLogin(
                                            isApproved: data["status"],
                                          )));
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                ),
              );
            },
          );
        }
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    });
  }

  login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .get()
          .then((documentSnapshot) async {
        if (documentSnapshot.exists) {
          // Access the data from the documentSnapshot
          var userData = documentSnapshot.data();

          // Assuming 'type' is a field in your Firestore document
          if (userData!["type"] == "0") {
            // Accessing SharedPreferences

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AdminHomeNavigation(madrisaName: userData["madrasah_name"]),
              ),
            );
          } else if (userData["type"] == "1") {
            // Accessing SharedPreferences

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StaffBottomNavigation(
                  madrisaName: userData["madrasah_name"],
                  isApproved: userData["status"],
                ),
              ),
            );
          } else if (userData["type"] == "2") {
            // Accessing SharedPreferences

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ParentsLogin(
                  isApproved: userData["status"],
                ),
              ),
            );
          }
        } else {
          print("Document does not exist");
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}

Future<String> translator({required String text, required String lang}) async {
  final translator = GoogleTranslator();

  var translation = await translator.translate(text, to: lang);
  String translated = translation as String;
  print(translation);
  // prints Dart jest bardzo fajny!

  return translated;
  // prints exemplo
}
