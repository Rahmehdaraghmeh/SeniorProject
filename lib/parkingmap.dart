import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

import 'package:loading_animation_widget/loading_animation_widget.dart';

class ParkingMap extends StatefulWidget {

  const ParkingMap({Key? key}) : super(key: key);

  @override
  _ParkingState createState() => _ParkingState();
}


class _ParkingState extends State<ParkingMap> {
  final DatabaseReference _spotsRef =
      FirebaseDatabase.instance.reference().child('parking_status');

  @override
  void initState() {
    super.initState();
  }

  final ref = FirebaseDatabase.instance.ref('parking_status');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          elevation: 0,
          title: Text(" Parking Map "),
          backgroundColor: Color(0xff89b5e1)),
      body: StreamBuilder(
        stream: ref.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (!snapshot.hasData) {
            return  Center(
              child:LoadingAnimationWidget.fourRotatingDots(
                color:  Color(0xff89b5e1),
                size: 50,
              ) ,);
          } else {
            Map<dynamic, dynamic> map =
                snapshot.data!.snapshot.value as dynamic;
            List<dynamic> listSpot = [];
            listSpot.clear();
            listSpot = map.values.toList();
            int count = 0;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: .5,
                mainAxisSpacing: 10,
                mainAxisExtent: 200,
                crossAxisSpacing: 10,
              ),
              itemCount: 3,
              padding: const EdgeInsets.all(25),
              itemBuilder: (BuildContext context, int index) {
                int leftSpot = map['spot${index + 1}'];
                int rightSpot = map['spot${index + 4}'];
                count++;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (leftSpot == 1)
                        ? Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Text(
                                  "Slot  ${count}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                ),
                                Image.asset("images/redcar.png")
                              ],
                            ),
                            width: 90,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: BorderDirectional(
                                start: BorderSide(width: 2.5),
                                top: BorderSide(width: 2.5),
                                bottom: BorderSide(width: 2.5),
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Text(
                                  "Slot  ${count}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                ),
                              ],
                            ),
                            width: 90,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: BorderDirectional(
                                start: BorderSide(width: 2.5),
                                top: BorderSide(width: 2.5),
                                bottom: BorderSide(width: 2.5),
                              ),
                            ),
                          ),
                    Container(
                      width: 120,
                      height: 50,
                      child: Image.asset("images/greyline.png"),
                    ),
                    (rightSpot == 1)
                        ? Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Text(
                                  "Slot  ${count + 3}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                ),
                                Image.asset("images/redcar.png")
                              ],
                            ),
                            width: 90,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: BorderDirectional(
                                end: BorderSide(width: 2.5),
                                top: BorderSide(width: 2.5),
                                bottom: BorderSide(width: 2.5),
                              ),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Text(
                                  "Slot  ${count + 3}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  height: 35,
                                ),
                              ],
                            ),
                            width: 90,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: BorderDirectional(
                                end: BorderSide(width: 2.5),
                                top: BorderSide(width: 2.5),
                                bottom: BorderSide(width: 2.5),
                              ),
                            ),
                          ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

String selectRandomCar(List<String> carList) {
  Random random = Random();
  int randomIndex = random.nextInt(carList.length);
  String randomPicture = carList[randomIndex];
  return randomPicture;
}
