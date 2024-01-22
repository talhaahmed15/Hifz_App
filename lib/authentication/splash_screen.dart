import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/NewScreens/join.dart';
import 'package:hafiz_diary/admin/bottom_navigation.dart';
import 'package:hafiz_diary/parents/parents_bottom_navigation.dart';
import 'package:hafiz_diary/parents/parents_login.dart';
import 'package:hafiz_diary/staff/staff_bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> initializeApp() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Join(),
          ),
        ),
      );
    } else {
      Timer(Duration(seconds: 5), () async {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .get();

        if (doc.data() != null) {
          String madrisaName = doc.get("madrasah_name");
          String type = doc.get("type");

          if (type == "0") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AdminHomeNavigation(madrisaName: madrisaName)));
          } else if (type == "1") {
            String approved = doc.get("remarks");
            bool isApproved;
            if (approved == "approved") {
              isApproved = true;
            } else {
              isApproved = false;
            }
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => StaffBottomNavigation(
                        isApproved: isApproved, madrisaName: madrisaName)));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ParentsBottomNavigation()));
          }
        }
      });
    }
  }

  @override
  void initState() {
    initializeApp();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 200,
                height: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
