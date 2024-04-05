import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditEmail extends StatefulWidget {
  const EditEmail({super.key});

  @override
  State<EditEmail> createState() => _EditEmailState();
}

bool isValidEmail(String email) {
  RegExp regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  return regex.hasMatch(email);
}
class _EditEmailState extends State<EditEmail> {
  var userID;
  String newemail = '';
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


  Future<void> updateUserEmail(String userId, String newEmail) async {
    try {
      DocumentReference userDocument =
      FirebaseFirestore.instance.collection('users').doc(userId);
      await userDocument.update({
        'email': newEmail,
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
        title: Text(
          "Edit Email",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                        "Email",
                        style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.check,
                            size: 30,
                            color: Colors.black45,
                          ),
                          onPressed: () {
                            if (formstate.currentState!.validate()) {
                              updateUserEmail(userID, newemail);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your email updated successfully")
                              ));
                            }
                          }),
                      hintText: "enter new email here",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black45),
                      ),
                    ),
                    onChanged: (val) {
                      newemail = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Email is required!";
                      }if(! isValidEmail(val)){
                        return "please enter correct email format";
                      }
                      return null;
                    }),
                SizedBox(height: 20,),
                Text("Please help our policy by using your correct email",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      wordSpacing: 2
                  ),
                )
              ],
            )),
      ),
    );
  }
}
