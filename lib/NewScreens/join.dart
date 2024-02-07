import 'package:flutter/material.dart';
import 'package:hafiz_diary/authentication/role_page.dart';
import '../constants.dart';
import 'new_sign_up.dart';

class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);

  @override
  State<Join> createState() => _Join();
}

class _Join extends State<Join> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 200,
              ),
              Image.asset(
                "assets/images/logo.png",
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 70,
              ),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RolePage(),
                      ),
                    );
                  },
                  child: lang == 'en'
                      ? const Text("Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18))
                      : const Text("لاگ ان",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewSignUp(),
                      ),
                    );
                  },
                  child: lang == 'en'
                      ? const Text("Create a New Account",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18))
                      : const Text("نیا اکاؤنٹ بنائیں",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
