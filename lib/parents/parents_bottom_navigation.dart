import 'package:flutter/material.dart';

import 'package:hafiz_diary/constants.dart';
import 'package:hafiz_diary/parents/parents_notes.dart';
import 'package:hafiz_diary/profile/profile_screen.dart';

import 'parents_home.dart';

class ParentsBottomNavigation extends StatefulWidget {
  const ParentsBottomNavigation({
    Key? key,
  }) : super(key: key);

  @override
  State<ParentsBottomNavigation> createState() =>
      _ParentsBottomNavigationState();
}

class _ParentsBottomNavigationState extends State<ParentsBottomNavigation> {
  TextEditingController controller = TextEditingController();
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ParentsHome(),
    ParentsNotes(),
    ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
        // floatingActionButton: _selectedIndex == 0
        //     ? FloatingActionButton(
        //         backgroundColor: primaryColor,
        //         onPressed: () {
        //           _createClass();
        //         },
        //         child: const Icon(
        //           Icons.add,
        //           color: Colors.white,
        //         ),
        //       )
        //     : SizedBox(),
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
    );
  }

  // Future<void> _createClass() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             AppText(
  //               text: "Join a Class",
  //               clr: primaryColor,
  //             )
  //           ],
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               CustomTextField(
  //                 validation: false,
  //                 controller: controller,
  //                 lableText: "Enter Class Code",
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: CommonButton(
  //               text: "Join Class",
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //               color: primaryColor,
  //               textColor: Colors.white,
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}
