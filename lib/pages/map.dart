import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({Key? key});

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  GoogleMapController? gmc;
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(32.468750, 35.298328),
    zoom: 12,
  );
  List<Marker> markers = [];
  StreamSubscription<dynamic>? databaseSubscription;
  Future<int>? spotsFuture;

  @override
  void initState() {
    super.initState();
    spotsFuture = NumberOfSpots();
    initializeMarkers();
    initializeStream();
  }

  void initializeMarkers() async {
    int spotCount = await spotsFuture!;
    markers = [
      Marker(
        infoWindow: InfoWindow(title: "MER", snippet: 'Number  of spots: $spotCount'),
        markerId: MarkerId("1"),
        position: LatLng(32.421371, 35.323601),
      ),
      Marker(
        infoWindow: InfoWindow(title: "City Center"),
        markerId: MarkerId("2"),
        position: LatLng(32.468750, 35.298328),
      ),
      Marker(
        infoWindow: InfoWindow(title: "City Mall"),
        markerId: MarkerId("3"),
        position: LatLng(32.221830, 35.258810),
      ),
    ];
  }

  void initializeStream() {
    final ref = FirebaseDatabase.instance.ref().child('parking_status');
    databaseSubscription = ref.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists) {
        Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
        List<dynamic> listSpot = map.values.toList();
        int count = 0;
        for (int i = 0; i < listSpot.length; i++) {
          if (listSpot[i] == 0) {
            count++;
          }
        }
        updateMarkers(count);
      } else {
        print('No data available.');
      }
    });
  }

  void updateMarkers(int spotCount) {
    setState(() {
      markers[0] = Marker(
        infoWindow: InfoWindow(title: "MER", snippet: 'Number of spots: $spotCount'),
        markerId: MarkerId("1"),
        position: LatLng(32.421371, 35.323601),
      );
    });
  }

  @override
  void dispose() {
    databaseSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff89b5e1),
        body: Container(

          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<int>(
                  future: spotsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.white,
                          size: 50,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return GoogleMap(
                        onTap: (LatLng latLng) async {},
                        markers: markers.toSet(),
                        initialCameraPosition: cameraPosition,
                        mapType: MapType.normal,
                        onMapCreated: (mapcontroller) {
                          gmc = mapcontroller;
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<int> NumberOfSpots() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('parking_status').get();
  if (snapshot.exists) {
    print("------------------------------");
    print(snapshot.value);
  } else {
    print('No data available.');
  }
  Map<dynamic, dynamic> map = snapshot.value as dynamic;
  List<dynamic> listSpot = [];
  listSpot = map.values.toList();
  print("------------------------------");
  print(listSpot);
  int count = 0;
  for (int i = 0; i < listSpot.length; i++) {
    if (listSpot[i] == 0) {
      count++;
    }
  }
  return count;
}
