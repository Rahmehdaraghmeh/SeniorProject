import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  String driverName = '';
  String email = '';
  String carNumber = '';

  var userID;
  Future<void> fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Retrieve additional user information from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      // Get the data as a Map
      Map<String, dynamic>? userData = userSnapshot.data();

      // Check if the user data is not null and contains the necessary fields
      if (userData != null &&
          userData.containsKey('driverName') &&
          userData.containsKey('email')) {
        setState(() {
          driverName = userData['driverName'];
          email = userData['email'];
          carNumber = userData['carNumber'];
        });
      } else {
        // Handle the case where the fields are not present in the document

      }
    }
  }
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Edit Your Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff89b5e1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('home');
          },
        ),
      ),



      body:  Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage("images/driverIcon.png")),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black12,
                  width: 2,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black45)),
              ),
              child: Container(
                child: ListTile(
                  leading: Text("Name"),
                  title: Text("$driverName",style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 30,
                    onPressed: () {
                      Navigator.of(context).pushNamed('EditName');
                    },
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black45)),
              ),
              child: ListTile(
                leading: Text("Email"),
                title: Text("$email",style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.of(context).pushNamed('EditEmail');
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black45)),
              ),
              child: ListTile(
                leading: Text("Car Number"),
                title: Text("$carNumber",style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.of(context).pushNamed('EditCarID');
                  },
                ),
              ),
            ),


          ],
        ),

    );
  }
}
