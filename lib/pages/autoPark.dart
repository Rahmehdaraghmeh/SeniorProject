import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AutoPark extends StatefulWidget {
  const AutoPark({super.key});

  @override
  State<AutoPark> createState() => _AutoParkState();
}

class _AutoParkState extends State<AutoPark> {
  TextEditingController _controller = TextEditingController();
  int _remainingTime = 0;
  bool _isRunning = false;
  String _selectedUnit = 'Hour';

  void startTimer() {
    if (_controller.text.isNotEmpty) {
      int inputValue = int.parse(_controller.text);
      switch (_selectedUnit) {
        case 'Hour':
          _remainingTime = inputValue * 3600;
          break;
        case 'Minute':
          _remainingTime = inputValue * 60;
          break;
        case 'Second':
          _remainingTime = inputValue;
          break;
      }
      setState(() {
        _isRunning = true;
      });
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          setState(() {
            _remainingTime--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isRunning = false;
          });
        }
      });
    }
  }
  @override
  void initState() {
    super.initState();
  }
  Future<void> sendCommand(String command) async {
    final response = await http.get(Uri.parse('http://192.168.43.66/$command'));
    print('Response: ${response.body}');
  }
      @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff89b5e1),
      body:Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isRunning ? '${(_remainingTime ~/ 3600).toString().padLeft(2, '0')}:${((_remainingTime % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}'
                  : '00:00:00',
              style: TextStyle(fontSize: 40,color: Colors.white),
            ),

            SizedBox(height: 30,),

                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Container(
                        color: Colors.white,
                        height: 40,
                        child: DropdownButton<String>(
                          elevation: 0,

                          value: _selectedUnit,
                          items: ['Hour', 'Minute', 'Second']
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,style: TextStyle(color: Colors.black),),
                          ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedUnit = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Enter Time',
                          border: OutlineInputBorder(),
                        ),),
                    ),

                  ],
                ),
                SizedBox(
                  height: 19,
                ),
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: MaterialButton(
                    onPressed:(){
                      sendCommand('Autopark');
                      sendNotifications();
                      if(_isRunning) {
                        null;
                      }else startTimer();
                    },
                    child: Text(
                        _isRunning ? 'Running...' : 'Start ',
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                  ),
                )
                ,




          ],
        ),
      )

    );
  }
}
void sendNotifications(){
  AwesomeNotifications().createNotification(content:
  NotificationContent(id: 10,
      channelKey: 'Parking Notifications',
      title: 'Auto Park',
      body: 'Your car will park soon...',

      ));}

