import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

import 'MainHome.dart';


class login_laoder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State< login_laoder> {
  var a=8;
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }


  @override
  void initState() {
    super.initState();
    startTimer();

  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration:
          Duration(milliseconds: 400),
          transitionsBuilder: (BuildContext
          context,
              Animation<double> animation,
              Animation<double> secAnimation,
              Widget child) {
            animation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutQuint);
            return ScaleTransition(
              alignment: Alignment.center,
              scale: animation,
              child: child,
            );
          },
          pageBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation) {
            return MainHome();
          },
        ));

  }

  initScreen(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Align(alignment:Alignment.center,child: Column(
                children: [
                  Image.asset('images/Rotate_Logo.gif',height: 200,width: 200,),
                ],
              )))
              ,SizedBox(height: 30,),
              Center(child: Shimmer.fromColors(

                  baseColor: Color(0xff0E6B50),
                  highlightColor: Colors.red,
                  child: Text("Please Wait...",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w900,),)))
            ],
          ),
        ),
      )
    );
  }
}
