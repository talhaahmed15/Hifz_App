import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_diary/constants.dart';
import 'package:hafiz_diary/widget/app_text.dart';
import 'package:hafiz_diary/widget/common_button.dart';
import 'package:image_picker/image_picker.dart';

class ParentFee extends StatefulWidget {
  ParentFee(this.name, this.studentname, {super.key});
  String name;
  String studentname;

  @override
  State<ParentFee> createState() => _ParentFeeState();
}

class _ParentFeeState extends State<ParentFee> {
  File? _image;

  Future<void> _pickAndUploadImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        // Accessing Firebase Storage reference
        Reference storageReference = FirebaseStorage.instance.ref().child(
            "payment_screenshots/${widget.name}/${DateTime.now().toString().substring(0, 10)} - ${widget.studentname}.png");

        // Uploading the selected image to Firebase Storage
        await storageReference.putFile(_image!);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image Uploaded Successfully!')));
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Submit Fee",
              clr: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            AppText(
              text: "Submit Your Fee Online Through Easypaisa",
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/easypaisa.png"),
            SizedBox(height: defPadding * 4),
            const Text(
              '0312-8444704',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: defPadding * 4),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CommonButton(
                text: "Upload ScreenShot",
                onTap: _pickAndUploadImage,
                color: primaryColor,
                textColor: Colors.white,
              ),
            )
          ],
        )),
      ),
    );
  }
}
