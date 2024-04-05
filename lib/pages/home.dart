import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../parkingmap.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String driverName = '';
  String email = '';

  Future<Map<String, String>> fetchUserInfo() async {
    Map<String, String> userDataMap = {};
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      Map<String, dynamic>? userData = userSnapshot.data();

      if (userData != null &&
          userData.containsKey('driverName') &&
          userData.containsKey('email')) {
        userDataMap['driverName'] = userData['driverName'];
        userDataMap['email'] = userData['email'];
      } else {
        userDataMap['driverName'] = 'N/A';
        userDataMap['email'] = 'N/A';
      }
    }
    return userDataMap;
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    getData();
  }

  //ADD PARKING FUNCTION
  CollectionReference parking =
      FirebaseFirestore.instance.collection('parking');

  //GET DATA FROM FIRESTORE
  List data = [];

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("parking").get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<DocumentSnapshot>> parkingStream = FirebaseFirestore.instance
        .collection("parking")
        .snapshots()
        .map((snapshot) => snapshot.docs);
    return Scaffold(
        body: Container(
            color: Color(0xff89b5e1),
            child: FutureBuilder<Map<String, String>>(
                future: fetchUserInfo(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: 50,
                      ),
                    ); // Display a loading indicator
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView(
                      children: [
                        Container(
                          height: 220,
                          color: Colors.white,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Image.asset(
                                "images/444.png",
                                fit: BoxFit.cover,
                                height: 150,
                                width: 300,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Welcome driver ${snapshot.data!['driverName']}",
                                style: TextStyle(
                                  color: Color(0xff060d2c),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 13),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Popular Parking",
                            style: TextStyle(
                                color: Color(0xff060d2c),
                                fontSize: 16,
                                // fontFamily: "Mooli",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        StreamBuilder<List<DocumentSnapshot>>(
                          stream: parkingStream,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('No parking spots available' , style: TextStyle(color: Colors.white),);
                            }
                            return Container(
                                height: 340,
                                margin:
                                    const EdgeInsets.only(left: 20, right: 10),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, i) {
                                      final data = snapshot.data![i].data()
                                          as Map<String, dynamic>;
                                      return Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(45)),
                                            width: 320,
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Parking ${i + 1}",
                                                  style: TextStyle(
                                                      color: Color(0xff060d2c),
                                                      fontFamily: 'Mooli',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  width: 180,
                                                  height: 110,
                                                  child: Image.asset(
                                                    "${data['Image']}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Parking name : ${data['Name']} ",
                                                    style: TextStyle(
                                                      color: Color(0xff060d2c),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 5,
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Address : ${data['Address']} ",
                                                    style: TextStyle(
                                                      color: Color(0xff060d2c),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 5,
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Total parking slots: ${data['SlotsNumber']} ",
                                                    style: TextStyle(
                                                      color: Color(0xff060d2c),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 10,
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff89b5e1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: MaterialButton(
                                                    child: const Text(
                                                      "Click To open parking Map",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParkingMap(),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          //  SizedBox(width: 4,)
                                        ],
                                      );
                                    },
                                  ),
                                ));
                          },
                        ),
                      ],
                    );
                  }
                })));
  }
}
