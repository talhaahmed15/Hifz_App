import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/constants.dart';
import 'package:hafiz_diary/notes/notes_screen.dart';
import 'package:hafiz_diary/profile/profile_screen.dart';
import 'package:hafiz_diary/widget/TextFormField.dart';
import 'package:hafiz_diary/widget/app_text.dart';
import 'package:hafiz_diary/widget/common_button.dart';

import 'staff_home.dart';

class StaffBottomNavigation extends StatefulWidget {
  final bool isApproved;
  String? madrisaName;

  StaffBottomNavigation(
      {Key? key, required this.isApproved, required this.madrisaName})
      : super(key: key);

  @override
  State<StaffBottomNavigation> createState() => _StaffBottomNavigationState();
}

class _StaffBottomNavigationState extends State<StaffBottomNavigation> {
  TextEditingController controller = TextEditingController();
  int _selectedIndex = 0;
  String? madrisaName;

  List<Widget> get _widgetOptions {
    return [
      StaffHome(madrisaName: widget.madrisaName),
      const NotesScreen(),
      const ProfileScreen(),
    ];
  }

  var currectUserId;

  Future<void> getCurrentUser() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      currectUserId = FirebaseAuth.instance.currentUser!.uid;
      madrisaName = snapshot['madrasah_name'];
      print("Current User id is**************** $currectUserId");
    });
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isApproved
        ? WillPopScope(
            onWillPop: () async {
              // Handle back button press
              if (_selectedIndex != 0) {
                setState(() {
                  _selectedIndex = 0;
                });
                return false; // Cancel back button press
              }
              return true; // Allow back button press (exit the app)
            },
            child: Scaffold(
              floatingActionButton: _selectedIndex == 0
                  ? FloatingActionButton(
                      backgroundColor: primaryColor,
                      onPressed: () {
                        _createClass();
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(),
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: '',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: primaryColor,
                onTap: _onItemTapped,
              ),
            ),
          )
        : const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child:
                        Text("Wait Until your account is approved by admin")),
              ],
            ),
          );
  }

  Future<void> _createClass() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: "Join a Class",
                clr: primaryColor,
              )
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                CustomTextField(
                  validation: false,
                  controller: controller,
                  lableText: "Enter Class Code",
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonButton(
                text: "Join Class",
                onTap: () {
                  setState(() {
                    // FirebaseFirestore.instance
                    //     .collection("classes")
                    //     .where("class_code", isEqualTo: controller.text)
                    //     .where("madrasah_name", isEqualTo: madrisaName)
                    //     .get()
                    //     .then(
                    //   (value) {
                    //     if (!value.docs.first
                    //         .get("teachers")
                    //         .toString()
                    //         .contains(currectUserId)) {
                    //       FirebaseFirestore.instance
                    //           .collection("classes")
                    //           .doc(value.docs.first.id)
                    //           .set(
                    //         {
                    //           "teachers": FieldValue.arrayUnion(
                    //               [FirebaseAuth.instance.currentUser!.uid])
                    //         },
                    //         SetOptions(merge: true),
                    //       );
                    //     }
                    //   },
                    // ).catchError((e) => print(e.message));

                    print(currectUserId);
                    addTeacherToClass(
                        controller.text, madrisaName, currectUserId);
                  });

                  Navigator.pop(context);
                },
                color: primaryColor,
                textColor: Colors.white,
              ),
            )
          ],
        );
      },
    );
  }
}

Future<void> addTeacherToClass(
    String classCode, String? madrasahName, String teacherUid) async {
  try {
    // Step 1: Find the document
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('classes')
        .where('class_code', isEqualTo: classCode)
        .where('madrasah_name', isEqualTo: madrasahName)
        .get();

    // Step 2: Check and update if the document exists
    if (querySnapshot.docs.isNotEmpty) {
      var document = querySnapshot.docs.first;
      var teachersArray = document['teachers'] ?? <String>[];

      if (teachersArray.contains(teacherUid)) {
        // Teacher UID is already in the 'teachers' array
        print('Teacher already exists in the class.');
      } else {
        // Teacher UID is not in the 'teachers' array, add it
        await FirebaseFirestore.instance
            .collection('classes')
            .doc(document.id)
            .update({
          'teachers': FieldValue.arrayUnion([teacherUid])
        });

        print('Teacher added to the class.');
      }
    } else {
      // Step 3: Document doesn't exist
      print(
          'Document doesn\'t exist for class $classCode and madrasah $madrasahName.');
    }
  } catch (e) {
    // Handle errors
    print('Error: $e');
  }
}
