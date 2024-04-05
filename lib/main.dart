import 'package:carparking/DriverProfile.dart';
import 'package:carparking/pages/controlCar.dart';
import 'package:carparking/pages/map.dart';
import 'package:carparking/parkingmap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carparking/auth/first.dart';
import 'package:carparking/auth/login.dart';
import 'package:carparking/auth/register.dart';
import 'package:carparking/firebase_options.dart';
import 'package:carparking/homepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'auth/verification.dart';
import 'editProfile/editCarID.dart';
import 'editProfile/editEmail.dart';
import 'editProfile/editName.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "SmartCarParking",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: "Parking Notifications",
          channelName: "Channel Parking",
          channelDescription: "Notification test for parking",
          playSound: true,
          onlyAlertOnce: true,
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
      ),
    ],
    debug: true,

  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}); // Fix the super.key to Key? key
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xffffffff)),
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage()
          : First(),
      routes: {
        "register": (context) => Register(),
        "home": (context) => HomePage(),
        "login": (context) => Login(),
        "ControlCar" : (context) => ControlCar(),
        "ParkingMap" : (context) => ParkingMap(),
        "MapGoogle" : (context) => MapGoogle(),
        "Verification" : (context) => EmailVerification(),
        "DriverProfile" : (context) => DriverProfile(),
        "EditName" : (context) => EditName(),
        "EditEmail" : (context) => EditEmail(),
        "EditCarID" : (context) => EditCarID(),

      },
    );
  }
}
