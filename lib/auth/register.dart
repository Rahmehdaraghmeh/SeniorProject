import 'dart:core';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carparking/auth/verification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carparking/component/textFormField.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

bool isValidCarId(String carId) {
  RegExp regex = RegExp(r'^\d\.\d{4}-[A-Z]$');
  return regex.hasMatch(carId);
}

bool isValidEmail(String email) {
  RegExp regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  return regex.hasMatch(email);
}

Future<void> saveUserInfoToFirestore(String driverName, String email,
    String carNumber, String passwordControl) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'driverName': driverName,
      'email': email,
      'carNumber': carNumber,
      'passwordControl': passwordControl
    });
  }
}

class _RegisterState extends State<Register> {
  TextEditingController carNumber = TextEditingController();

  TextEditingController passwordControl = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController driverName = TextEditingController();
  bool passwordVisible = false;
  bool isEmailVerified = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = false;
    isEmailVerified = false;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formstate = GlobalKey();

    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
      child: ListView(children: [
        Container(
          height: 100,
          margin: EdgeInsets.only(top: 5),
        ),
        Container(
          child: Text(
            "Register Your Car ",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xff060d2c),
                fontFamily: 'Mooli',
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
          child: Text(
            "Create account to control your car, add the registration number of the vehicle ",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Mooli", fontSize: 12, color: Colors.black45),
          ),
        ),
        Container(
          height: 20,
        ),
        Form(
            key: formstate,
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                        filled: true,
                        fillColor: Color.fromARGB(255, 252, 255, 253),
                        labelText: "Car-ID",
                        hintText: "1.3141-H",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color.fromARGB(255, 237, 229, 229),
                        ))),
                    controller: carNumber,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return " carID is Required!";
                      }
                      if (!isValidCarId(val)) {
                        return 'Invalid Car ID format!';
                      }
                      return null;
                    }),
                Container(
                  height: 10,
                ),
                TextFormField(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                        filled: true,
                        fillColor: Color.fromARGB(255, 252, 255, 253),
                        labelText: "Driver name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 237, 229, 229)))),
                    controller: driverName,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Driver name is required!";
                      }
                      return null;
                    }),
                Container(
                  height: 10,
                ),
                TextFormField(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                        filled: true,
                        fillColor: Color.fromARGB(255, 252, 255, 253),
                        labelText: "Email",
                        hintText: "X@gmail.com",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color.fromARGB(255, 237, 229, 229),
                        ))),
                    controller: email,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Email is required!";
                      }
                      if (!isValidEmail(val)) {
                        return "Enter Correct Email Format";
                      }
                    }),
                Container(
                  height: 10,
                ),
                Container(
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
                                    color: Color.fromARGB(255, 237, 229, 229))),
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
                                    color:
                                        Color.fromARGB(255, 125, 124, 124)))))),
              ],
            )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: const Text.rich(
              textAlign: TextAlign.center,
              TextSpan(children: [
                TextSpan(
                  text: "By signing up, you agree to our ",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                TextSpan(
                    text: "Terms",
                    style: TextStyle(
                        color: Color.fromARGB(255, 138, 52, 14), fontSize: 12)),
                TextSpan(
                    text: " Privacy Policy",
                    style: TextStyle(
                        color: Color.fromARGB(255, 138, 52, 14), fontSize: 12)),
                TextSpan(
                  text: " and",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                TextSpan(
                    text: " Cookies Policy",
                    style: TextStyle(
                        color: Color.fromARGB(255, 138, 52, 14), fontSize: 12)),
              ])),
        ),
        MaterialButton(
          minWidth: 300,
          height: 45,
          color: Color(0xff89b5e1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () async {
            if (formstate.currentState!.validate()) {
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email.text.trim(),
                  password: passwordControl.text.trim(),
                );
                await saveUserInfoToFirestore(driverName.text, email.text,
                    carNumber.text, passwordControl.text);
                Navigator.of(context).pushNamed('Verification');
              } on FirebaseAuthException catch (e) {
                print("------------------------");
                print(e.message);
                print("------------------------");
                if (e.code == 'weak-password') {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: 'The password provided is too weak.',
                  ).show();
                } else if (e.code == 'email-already-in-use') {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: 'The account already exists for that email',
                  ).show();
                } else if (e.code == 'invalid-email-verified') {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: 'Enter correct email',
                  ).show();
                }
              } catch (e) {
                print(e);
              }
            } else {
              print("not valid");
            }

            //Navigator.of(context).pushReplacementNamed("login");
          },
          child: Text(
            "Sign UP",
            style: TextStyle(
                fontFamily: "Mooli",
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: 5,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed("login");
          },
          child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(children: [
                TextSpan(
                  text: "have an account ? ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        fontFamily: 'Mooli',
                        color: Color.fromARGB(255, 138, 52, 14),
                        fontWeight: FontWeight.bold))
              ])),
        ),
      ]),
    ));
  }
}
