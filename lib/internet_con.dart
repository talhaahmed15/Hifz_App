import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetDialog extends StatelessWidget {
  const InternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('No Internet Connection'),
      content:
          const Text('Please check your internet connection and try again.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class AppState with ChangeNotifier {
  bool _isConnected = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool get isConnected => _isConnected;

  AppState() {
    _initConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _isConnected = (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi);
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription
        .cancel(); // Cancel the subscription when the AppState is disposed
    super.dispose();
  }
}
