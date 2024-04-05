import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class First extends StatefulWidget {
  First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(

        globalBackgroundColor: Colors.white,
        scrollPhysics: BouncingScrollPhysics(),
        pages: [
          PageViewModel(
            decoration: PageDecoration(
              pageMargin: EdgeInsets.only(top: 100)
            ),
            titleWidget: Text("Welcome To Smart Car"
                "\n Parking",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Mooli",
                fontSize: 21,
                fontWeight: FontWeight.bold
            ),),

            bodyWidget: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: const Text(
                "Find the suitable parking slots in negligible time with no hassle",
                style: TextStyle(
                    color: Colors.black, fontSize: 14, fontFamily: "Mooli"),
                textAlign: TextAlign.center,
              ),
            ),
            image: Image.asset("images/33.png",height: 400, width: 350,),

          ),
          PageViewModel(
            decoration: PageDecoration(
              //imagePadding: EdgeInsets.only(top: 50),
                pageMargin: EdgeInsets.only(top: 100)

            ),
            titleWidget: Text("Add Your Car Details",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Mooli",
                  fontSize: 21,
                  fontWeight: FontWeight.bold
              ),),

            bodyWidget: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: const Text(
                "Automatically search for parking spaces to fit the size of your car",
                style: TextStyle(
                    color: Colors.black, fontSize: 14, fontFamily: "Mooli"),
                textAlign: TextAlign.center,
              ),
            ),
            image: Image.asset("images/second.png",height: 400, width: 350,),

          ),
          PageViewModel(
            decoration: PageDecoration(
              //imagePadding: EdgeInsets.only(top: 50),
                pageMargin: EdgeInsets.only(top: 100)

            ),
            titleWidget: Text("Search, Discover"
                "\n & Park",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Mooli",
                  fontSize: 21,
                  fontWeight: FontWeight.bold
              ),),

            bodyWidget: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: const Text(
                "Easily to find the nearby parking spot or the location you are going to",
                style: TextStyle(
                    color: Colors.black, fontSize: 14, fontFamily: "Mooli"),
                textAlign: TextAlign.center,
              ),
            ),
            image: Image.asset("images/third.png",height: 400, width: 350,),

          ),
        ],
        onDone: (){
          Navigator.of(context).pushReplacementNamed("login");
        },
        onSkip: (){
          Navigator.of(context).pushReplacementNamed("login");
        },
        showSkipButton: true,
        skip: Text("Skip",style: TextStyle(
          fontFamily: 'Mooli',
          color: Color(0xff1544de),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
        done: Text(
          "Done" ,
          style: TextStyle(
            fontFamily: 'Mooli',
            color: Color(0xff1544de),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        next: Icon(Icons.arrow_forward, color: Color(0xff1544de),),
        dotsDecorator: DotsDecorator(
          size: Size.square(10.0),
          activeSize: Size(20.0,10.0),
          color: Colors.black26,
          activeColor: Color(0xff1544de),
          spacing: EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0)
          )
            
        ),
      ),

    );

  }
}
