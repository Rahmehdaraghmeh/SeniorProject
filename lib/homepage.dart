import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carparking/pages/autoPark.dart';
import 'package:carparking/pages/controlCar.dart';
import 'package:carparking/pages/home.dart';
import 'package:carparking/pages/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String driverName = '';
  String email = '';

  Future<Map<String, String>> fetchUserInfo() async {
    Map<String, String> userDataMap = {};

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      Map<String, dynamic>? userData = userSnapshot.data();

      if (userData != null && userData.containsKey('driverName') && userData.containsKey('email')) {
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
  CollectionReference parking = FirebaseFirestore.instance.collection('parking');

  //GET DATA FROM FIRESTORE
  List data = [];

  getData () async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("parking").get();
    data.addAll(querySnapshot.docs);
    setState(() {

    });
  }

  Future<void> sendCommand(String command) async {
    final response = await http.get(Uri.parse('http://192.168.43.66/$command'));
    print('Response: ${response.body}');
  }

  int _currentIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Home(),
    AutoPark(),
    MapGoogle(),
    ControlCar(),
  ];

  void _changeItem(int value){
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              padding: const EdgeInsets.only(top: 10, right: 8, left: 8),
              icon: const Icon(
                Icons.sort_outlined,
                size: 35,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text("SMART PARKING",
        style: TextStyle(
          fontFamily: 'Mooli',
          fontWeight: FontWeight.bold,
          fontSize: 17,
            letterSpacing: 1,
        ),),
        backgroundColor: Color(0xff89b5e1),
        elevation: 0,
        toolbarHeight: 70,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: FutureBuilder<Map<String, String>>(
              future: fetchUserInfo(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child:LoadingAnimationWidget.fourRotatingDots(
                      color:  Color(0xff89b5e1),
                      size: 50,
                    ) ,);  // Display a loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else
                  return ListView(
                    children: [
                      Container(
                        height: 170,
                        margin: const EdgeInsets.all(10),
                        child:
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                                width: 100,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: Image.asset(
                                    "images/driverIcon.png",
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Expanded(
                              child: ListTile(
                                title: Text("${snapshot.data!['driverName']}",
                                textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff081236),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                subtitle: Text( "${snapshot.data!['email']}",
                                textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(height: 5,),
                      InkWell( onTap: (){
                        Navigator.of(context).pushNamed('DriverProfile');
                      },
                        child:
                        ListTile(
                          title: Text("Driver Profile",
                              style: TextStyle(
                                  color: Color(0xff2463a4),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          leading: Icon(
                            Icons.account_circle,
                            size: 30,
                          ),
                          subtitle: Text("Edit driver account"),
                        ),),

                      ListTile(
                        title: const Text("LogOut",
                            style: TextStyle(
                                color: Color(0xff2463a4),
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        leading: const Icon(
                          Icons.logout_outlined,
                          size: 30,
                        ),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil("login", (route) => false);
                        },
                      )
                    ],
                  );
              } ),
        ),),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: _changeItem,
        index: _currentIndex,

        backgroundColor: Color(0xff89b5e1),
        items: [
          Icon(Icons.home),
          Icon(Icons.local_parking),
          Icon(Icons.fmd_good_rounded),
          Icon(Icons.car_rental),

        ],
      ),
      body: Container(
        color: Color(0xff89b5e1),
        child:_widgetOptions.elementAt(_currentIndex),

      ),
    );

  }}


