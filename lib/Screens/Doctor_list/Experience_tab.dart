import 'dart:convert';

import'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:http/http.dart'as http;
class experience_tab extends StatefulWidget {
  final String id;
  experience_tab({this.id});
  @override
  _experience_tabState createState() => _experience_tabState();
}

class _experience_tabState extends State<experience_tab>with TickerProviderStateMixin {
  Future myfuture;
  var type,doctor;
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var id=widget.id;

    String url = "https://bestaid.com.bd/api/store/show/doctor/$id";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data']['data'];
      print(userData1['type']);
      setState(() {
        type=userData1['type'];
        doctor=userData1['id'];
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  TabController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    myfuture=getpost();

  }
  var id;
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Container(
                constraints: BoxConstraints(),
                child: FutureBuilder(
                    future: myfuture,
                    builder: (_, AsyncSnapshot snapshot) {
                      print(snapshot.data);
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return  Column(
                            children: [
                              SizedBox(height: height/2,),
                              Center(child:SpinKitRotatingCircle(
                                color: Color(0xff0E6B50),
                                size: 30,
                              )),
                            ],
                          );
                        default:
                          if (snapshot.hasError) {
                            Text('Error: ${snapshot.error}');
                          } else {
                            return snapshot.hasData
                                ?                  Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(

                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey, //                   <--- border color
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 30),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text("Practice Area - ",style: GoogleFonts.lato(
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 12
                                                          ),), Text(snapshot.data['type']=='gp'?"General Physician":"Specialist",style: GoogleFonts.lato(
                                                              color: Color(0xff0E6B50),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16
                                                          )),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        children: [
                                                          Text("Department - ",style: GoogleFonts.lato(
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 12
                                                          ),),Text(snapshot.data['department']['name'],style: GoogleFonts.lato(
                                                              color: Color(0xff0E6B50),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16
                                                          )
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10,),

                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text("Degree Obtained - ",style: GoogleFonts.lato(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 12
                                                                ),),   Flexible(
                                                                  child: Text(snapshot.data['degree_obtained'],style: GoogleFonts.lato(
                                                          color: Color(0xff0E6B50),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16
                                                      )),
                                                                ),
                                                                
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(snapshot.data['description']!=null?"More Information - ":" ",style: GoogleFonts.lato(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 12
                                                                ),),   Flexible(
                                                                  child: Text(snapshot.data['description']!=null?snapshot.data['description']:" ",style: GoogleFonts.lato(
                                                          color: Color(0xff0E6B50),
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16
                                                      )),
                                                                ),

                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                      ),

                                                    ],
                                                  ),

                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )




                                : Text('No data');
                          }
                      }
                      return CircularProgressIndicator();
                    }))

          ],
        ),
      ),
    ));
  }
}
