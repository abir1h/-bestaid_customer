import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainHome.dart';
import '../login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
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
      duration: Duration(milliseconds: 500),
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
    var duration = Duration(milliseconds: 5500);
    return new Timer(duration, route);
  }

  Naviagate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MainHome()));
  }

  Naviagatelogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => login_screen()));
  }

  route() {
    token == null ? Naviagatelogin() : Naviagate();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3.5,
            ),
            Center(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Image.asset(
                      'images/Rotate_Text.gif',
                      height: 300,
                      width: 300,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
