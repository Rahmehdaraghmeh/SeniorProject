import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:carparking/component/textFormField.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailCont = TextEditingController();

  TextEditingController passwordControl = TextEditingController();

  String? textval;

  String? username;

  String? password;

  GlobalKey<FormState> formState = GlobalKey();
  bool passwordVisible = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      margin: const EdgeInsets.all(5),
      child: ListView(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 20, bottom: 0),
              height: 250,
              width: 350,
              child: Image.asset(
                "images/444.png",
                fit: BoxFit.fill,
              )),
          Container(
            margin: const EdgeInsets.all(5),
            child: const Text(
              "Login",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "Mooli",
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            child: const Text(
              "Login to continue using the app",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: "Mooli",
                color: Colors.black45,
                fontSize: 13,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 19),
            child: Form(
              key: formState,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 8),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailCont,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 237, 229, 229))),
                              labelText: "Email"),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "email is required";
                            }
                          },
                        )),
                    Container(
                        height: 50,
                        margin: const EdgeInsets.only(
                            left: 10, bottom: 5, right: 10),
                        child: TextFormField(
                            controller: passwordControl,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "password is required!";
                              }
                            },
                            obscureText: !passwordVisible,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 20),
                                filled: true,
                                fillColor: Color.fromARGB(255, 252, 255, 253),
                                labelText: "Password",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 237, 229, 229))),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: passwordVisible
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(
                                            255, 125, 124, 124)))))),
                    Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 10),
                        child: InkWell(
                          onTap: () async {
                            if (emailCont.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Warning',
                                desc: 'Please tap the email.',
                              ).show();
                            }
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: emailCont.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Warning',
                                desc:
                                    'Please check the email to reset the password',
                              ).show();
                            } catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Warning',
                                desc: 'Invalid Email',
                              ).show();
                            }
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                                fontFamily: 'Mooli',
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    MaterialButton(
                      minWidth: 300,
                      height: 45,
                      color: Color(0xff89b5e1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailCont.text.trim(),
                                    password: passwordControl.text.trim());
                            Navigator.of(context).pushReplacementNamed('home');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'No user found for that email',
                              ).show();
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Wrong password provided for that user',
                              ).show();
                            }
                          }
                        } else {
                          print("Not valid");
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Mooli',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 7,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("register");
                      },
                      child: const Text.rich(TextSpan(children: [
                        TextSpan(
                          text: "Dont have an account ? ",
                          style: TextStyle(
                              fontFamily: 'Mooli',
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: "Register",
                            style: TextStyle(
                                fontFamily: 'Mooli',
                                color: Color.fromARGB(255, 138, 52, 14),
                                fontWeight: FontWeight.bold))
                      ])),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    ));
  }
}
