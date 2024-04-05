import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../homepage.dart';
import 'login.dart';
import 'package:fancy_button_flutter/fancy_button_flutter.dart';

class EmailVerification extends StatefulWidget {
  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendEmailVerification();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (timer) => checkEmailVerification(),
      );
    }
  }

  Future sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  Future checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          appBar: AppBar(
            title: Text("Email Verification"),
            centerTitle: true,
            shadowColor: Colors.grey[300],
            //leading: Image.asset("images/icon.png"),
            backgroundColor: Colors.grey,
          ),
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Container(
                width: 80,
                height: 80,
                child: Image.asset("images/email.jpg"),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  "Verify Your Email Address",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Mooli',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "We have just send email verification link on your email.\n "
                "          Please check email and click on that link \n            "
                "       to verify your email address ",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mooli',
                  wordSpacing: 2,
                ),
              )),
              SizedBox(
                height: 80,
              ),
              FancyButton(
                  button_icon: Icons.email_outlined,
                  button_text: "  Resend Email Verification  ",
                  button_height: 40,
                  button_width: 250,
                  button_radius: 50,
                  button_color: Colors.blue,
                  button_outline_color: Colors.white,
                  button_outline_width: 1,
                  button_text_color: Colors.white,
                  button_icon_color: Colors.white,
                  icon_size: 22,
                  button_text_size: 15,
                  onClick: () {
                    sendEmailVerification();
                  }),

            ],
          ),
        );
}
