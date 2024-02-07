import 'package:flutter/material.dart';
import 'package:hafiz_diary/NewScreens/new_sign_up.dart';
import 'package:hafiz_diary/widget/TextFormField.dart';
import '../authentication/forgot_password.dart';
import '../constants.dart';
import '../services/auth_services.dart';
import '../widget/app_text.dart';

class NewLogin extends StatefulWidget {
  const NewLogin({Key? key}) : super(key: key);

  @override
  State<NewLogin> createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.all(defPadding * 2),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: defPadding * 3),
                  lang == 'en'
                      ? Text("Login",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22))
                      : Text("لاگ ان",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22)),
                  const SizedBox(height: 6),
                  lang == 'en'
                      ? const Text("Welcome to Hifz Diary App",
                          style: TextStyle(color: Colors.grey, fontSize: 20))
                      : const Text("حفظ ڈائری ایپ میں خوش آمدید",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          )),
                  SizedBox(height: defPadding * 2),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: true,
                      controller: emailController,
                      lableText: "Email / Phone"),
                  SizedBox(
                    height: defPadding / 2,
                  ),
                  CustomTextField(
                      validation: false,
                      controller: passwordController,
                      lableText: "Password"),
                  SizedBox(
                    height: defPadding * 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const ForgotPassword();
                      }));
                    },
                    child: lang == 'en'
                        ? const Text("Forgot Password?",
                            style: TextStyle(color: Colors.black))
                        : const Text("پاسورڈ بھول گے؟",
                            style: TextStyle(
                              color: Colors.black,
                            )),
                  ),
                  SizedBox(
                    height: defPadding * 2,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      child: lang == "en"
                          ? const Text(
                              "Login",
                              style: TextStyle(fontSize: 15),
                            )
                          : const Text("لاگ ان "),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          authServices.login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              context: context);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: defPadding * 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lang == "en"
                            ? "Dont have an Account?"
                            : "اکاؤنٹ نہیں ہے؟",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: defPadding * 0.2,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const NewSignUp();
                          }));
                        },
                        child: AppText(
                          fontWeight: FontWeight.w600,
                          size: 16,
                          text: lang == "en" ? "Signup" : "سائن اپ",
                          clr: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
