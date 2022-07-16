import 'dart:convert';
import 'dart:io';

import 'package:best_aid_customer/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/url/App_url.dart';
import 'login_laoder.dart';

class login_screen extends StatefulWidget {
  @override
  _login_screenState createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  final _formKey = GlobalKey<FormState>();
  bool issave = false;
  bool _showPassword = false;
  var player_id;

  func() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;
    print(playerId);
    setState(() {
      player_id = playerId;
    });
  }

  bool islogin = false;

  TextEditingController email_ = TextEditingController();
  TextEditingController password_ = TextEditingController();

  Future login(String email, String password) async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.login),
    );
    request.fields.addAll({
      'phone_number': email_.text,
      'password': password_.text,
      'player_id': player_id
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data['status_code']);
          print('response.body ' + data.toString());
          if (data['status_code'] == 200) {
            setState(() {
              islogin = false;
            });
            print(data['token']['plainTextToken']);
            print(data['data']['first_name']);
            saveprefs(
              data['token']['plainTextToken'],
              data['data']['first_name'],
              data['data']['last_name'],
              data['data']['phone_number'],
            );
            print("Success! ");
            Fluttertoast.showToast(
                msg: "Login Successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.push(
                context, MaterialPageRoute(builder: (_) => login_laoder()));
          } else {
            setState(() {
              islogin = false;
            });
            print(response.statusCode);
            Fluttertoast.showToast(
                msg: "Unauthorized",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          setState(() {
            islogin = false;
          });

          print(response.statusCode);

          return response.body;
        }
      });
    });
  }

  saveprefs(
      String token, String first_name, String last_name, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

    prefs.setString('first_name', first_name);
    prefs.setString('last_name', last_name);

    prefs.setString('phone', phone);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    func();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  TextButton(
                    child: Text("YES"),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                  TextButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 25, top: 40),
                          child: IconButton(
                            onPressed: () {},
                            iconSize: 30,
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 30),
                                    child: InkWell(
                                      onTap: () {
                                        print(player_id);
                                      },
                                      child: Text(
                                        "Welcome to,",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                    )),
                                Container(
                                    padding: EdgeInsets.only(left: 40),
                                    child: Text(
                                      "Best Aid",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, top: 40),
                              child: Image(
                                image: AssetImage("images/ilustration2.png"),
                                height: height / 4,
                                width: width / 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height / 10,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          "Phone",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xff01B090)),
                                        ),
                                      ),
                                      TextFormField(
                                        validator: (val) => val.isEmpty
                                            ? "Please Enter Email"
                                            : null,
                                        controller: email_,
                                        keyboardType: TextInputType.phone,
                                        style: TextStyle(fontSize: 20),
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff01B090))),
                                            prefixIcon: Icon(
                                              Icons.phone,
                                              color: Color(0xff01B090),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          "Password",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xff01B090)),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: password_,
                                        validator: (val) => val.isEmpty
                                            ? "Please Enter your password"
                                            : null,
                                        obscureText: !_showPassword,
                                        style: TextStyle(fontSize: 20),
                                        decoration: InputDecoration(
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _showPassword =
                                                      !_showPassword;
                                                });
                                              },
                                              child: Icon(_showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xff01B090)),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.vpn_key,
                                              color: Color(0xff01B090),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        islogin == false
                            ? Container(
                                height: 60,
                                child: RaisedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      print("tapped");
                                      setState(() {
                                        islogin = true;
                                      });
                                      login(email_.text, password_.text);
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  padding: EdgeInsets.all(0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff01B090),
                                            Color(0x01B090)
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 260.0, minHeight: 60.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Sign In",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SpinKitThreeInOut(
                                color: Colors.teal,
                                size: 20,
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account ?",
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => register_screen()));
                              },
                              child: Text(
                                "SignUp Now",
                                style: GoogleFonts.lato(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
