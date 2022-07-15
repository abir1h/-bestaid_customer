import 'dart:async';


import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainHome.dart';




class apponitmetn_confirm extends StatefulWidget {
  const apponitmetn_confirm({Key key}) : super(key: key);

  @override
  _apponitmetn_confirmState createState() => _apponitmetn_confirmState();
}

class _apponitmetn_confirmState extends State<apponitmetn_confirm>
    with SingleTickerProviderStateMixin {
  var token;
  void isLoogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print(token);
  }

  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    isLoogedIn();

    _controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    );
    // Timer(Duration(milliseconds: 200),()=> );
    _controller.forward();
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  startTimer() async {
    var duration = Duration(milliseconds:5000);
    return new Timer(duration, route);
  }
  Naviagate(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainHome()));
  }
  route() {
  Naviagate();
  }


  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(

        backgroundColor:Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: MediaQuery.of(context).size.height/3.5,),
              Center(child: Align(alignment:Alignment.center,child: Column(
                children: [
                  Text("Congratulations",style: GoogleFonts.lato(
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.w600
                  )),
                  Image.asset('images/splas.gif',height: 300,width: 300,),
                  Center(
                    child: Text("You Have SuccessFully Requested an Appointment",style: GoogleFonts.lato(
                        color:  Color(0xff0E6B50),
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    )),
                  ),Center(
                    child: Text("We Will contact You soon for the confirmation !!!",style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    )),
                  )
                ],
              ))),

            ],
          ),
        )
    );
  }
}

