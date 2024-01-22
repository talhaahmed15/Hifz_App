import 'dart:io';
import 'package:hafiz_diary/constants.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CheckFeesPage extends StatefulWidget {
  final String madrasahName;

  const CheckFeesPage({Key? key, required this.madrasahName}) : super(key: key);

  @override
  _CheckFeesPageState createState() => _CheckFeesPageState();
}

class _CheckFeesPageState extends State<CheckFeesPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<String>? _imageNames;

  @override
  void initState() {
    super.initState();
    _loadImageNames();
  }

  Future<void> _loadImageNames() async {
    try {
      ListResult result = await _storage
          .ref('payment_screenshots/${widget.madrasahName}')
          .listAll();

      setState(() {
        _imageNames = result.items.map((item) => item.name).toList();
      });
    } catch (e) {
      print('Error loading image names: $e');
    }
  }

  Future<void> _downloadImage(String imageName) async {
    try {
      Reference reference =
          _storage.ref('payment_screenshots/${widget.madrasahName}/$imageName');
      File downloadToFile =
          File('${(await getTemporaryDirectory()).path}/$imageName');

      await reference.writeToFile(downloadToFile);

      _openImage(downloadToFile);
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  void _openImage(File imageFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text('Downloaded Image'),
          ),
          body: Center(
            child: Image.file(imageFile),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Fees'),
        backgroundColor: primaryColor,
      ),
      body: _imageNames != null
          ? ListView.builder(
              itemCount: _imageNames!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      _imageNames![index],
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    tileColor: Colors.grey[200], // Background color
                    contentPadding: const EdgeInsets.all(
                        10.0), // Padding around the content
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Border radius
                      side: BorderSide(
                          color: primaryColor,
                          width: 2.0), // Border color and width
                    ),
                    onTap: () => _downloadImage(_imageNames![index]),
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
