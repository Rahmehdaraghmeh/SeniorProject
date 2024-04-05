import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditCarID extends StatefulWidget {
  const EditCarID({super.key});

  @override
  State<EditCarID> createState() => _EditCarIDState();
}

bool isValidCarId(String carId) {
  RegExp regex = RegExp(r'^\d\.\d{4}-[A-Z]$');
  return regex.hasMatch(carId);
}
class _EditCarIDState extends State<EditCarID> {
  var userID;
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

  Future<void> updateUserCarID(String userId, String newCarID) async {
    try {
      DocumentReference userDocument =
      FirebaseFirestore.instance.collection('users').doc(userId);
      await userDocument.update({
        'carNumber': newCarID,
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
        elevation: 0,
        title: Text(
          "Edit Car Number",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
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
                        "CarID",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,color: Colors.black45),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.check,
                            size: 30,
                            color: Colors.black45,
                          ),
                          onPressed: () {
                            if (formstate.currentState!.validate()) {
                              updateUserCarID(userID, newcarNumber);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your CarID updated successfully")
                              ));
                            }
                          }),
                      hintText: "enter new car number here",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black45),
                      ),
                    ),
                    onChanged: (val) {
                      newcarNumber = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "CarID is required!";
                      }if(! isValidCarId(val)){
                        return "please enter correct CarNumber format";
                      }
                      return null;
                    }),
                SizedBox(height: 20,),
                Text("Please help our policy by using your correct car number",
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
