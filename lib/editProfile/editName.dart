import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditName extends StatefulWidget {
  const EditName({super.key});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  var userID;
  String newdriverName = '';
  String newemail = '';
  String newcarNumber = '';
  GlobalKey<FormState> formstate = GlobalKey();
  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      return userId;
    } else {
      // User is not authenticated
      return '';
    }
  }

  Future<void> updateUserName(String userId, String newName) async {
    try {
      DocumentReference userDocument =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userDocument.update({
        'driverName': newName,
      });
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    userID = getCurrentUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Edit Name",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xff89b5e1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("DriverProfile");
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
            key: formstate,
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(
                      label: Text(
                        "Name",
                        style: TextStyle(
                            color: Colors.black45, fontWeight: FontWeight.bold),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.check,
                            size: 30,
                            color: Colors.black45,
                          ),
                          onPressed: () {
                            if (formstate.currentState!.validate()) {
                              updateUserName(userID, newdriverName);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Your name updated successfully")));
                            }
                          }),
                      hintText: "Enter new name here",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black45),
                      ),
                    ),
                    onChanged: (val) {
                      newdriverName = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "name is required!";
                      }
                      return null;
                    }),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Please help our policy by using your correct name",
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[600], wordSpacing: 2),
                )
              ],
            )),
      ),
    );
  }
}
