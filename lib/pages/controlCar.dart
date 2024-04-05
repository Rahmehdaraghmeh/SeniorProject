import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ControlCar extends StatefulWidget {
  @override
  State<ControlCar> createState() => _ControlState();


}

class _ControlState extends State<ControlCar> {

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
        body: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:20 ,),
            Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.white70,

              ),
              child: Center(
                child: const Text("Click to any arrow you need"
                    "\nto control your car movement",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff060d2c),
                    fontSize: 13,

                  ),
                ),
              ),
            ),
            Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: MaterialButton(
                      onPressed: (){
                        sendCommand('forward');
                      },
                      child: Icon(Icons.arrow_upward,size: 90,color: Colors.white70,)//Image.asset("images/front.png",width: 100,height: 100,),
                    ),)]),),

            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: MaterialButton(
                    onPressed: (){
                      sendCommand('left');
                    },
                    child: Icon(Icons.arrow_back,size: 90,color: Colors.white70,)//Image.asset("images/left.png",width: 100,height: 100,),
                  ),),
                Container(
                  child: MaterialButton(
                    onPressed: (){
                      sendCommand('stop');

                    },
                    child: Icon(Icons.stop_circle,size: 60,color: Colors.white70,),
                  ),),
                Container(
                  child: MaterialButton(
                    onPressed: (){
                      sendCommand('right');

                    },
                    child: Icon(Icons.arrow_forward,size: 90,color: Colors.white70,)// Image.asset("images/right.png",width: 100,height: 100,),
                  ),),
              ],
            ),),

            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: MaterialButton(
                    onPressed: (){
                      sendCommand('backward');

                    },
                    child: Icon(Icons.arrow_downward,size: 90,color: Colors.white70,)// Image.asset("images/behind.png",width: 100,height: 100,),
                  ),),
              ],
            )),
          ],

        )


    );
  }
}