import 'dart:async';
import 'dart:convert';

import 'package:best_aid_customer/online_doctors/specialist_doctor_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class book_appointment extends StatefulWidget {
  final String patient_id;
  const book_appointment({Key key, this.patient_id}) : super(key: key);
  @override
  _book_appointmentState createState() => _book_appointmentState();
}

class _book_appointmentState extends State<book_appointment> {
  Future myfuture, sessionf;
  var link;  int selectedCard = -1;

  Timer notification_timer;
  var sesion_id, day_id, day_name;
  Future get_clss() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var id = widget.patient_id;
    String url = "https://bestaid.com.bd/api/customer/show/session/0/$id";

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData = jsonDecode(response.body)['data'];
      print("Get Profile has Data");

      print(userData);

      return userData;
    } else {
      print("Get Profile No Data${response.body}");
    }
  }

  Future get_sesion(String dayid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var id = widget.patient_id;
    var day_id=dayid;
    String url = "https://bestaid.com.bd/api/customer/show/session/$day_id/$id";

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData = jsonDecode(response.body)['data'];
      print("Get Profile has Data");

      print(userData);

      return userData;
    } else {
      print("Get Profile No Data${response.body}");
    }
  }

  bool isloaded = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture = get_clss();
    print(widget.patient_id);
  }

  String sesion, day;
  var days,time;
  var sesion_naem, val;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff0E6B50),
        body: isloaded == false
            ? Column(
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
                        SpinKitWave(
                          color: Colors.green,
                          size: 30,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                        ),
                        Text("Please wait for doctor response",
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16))
                      ],
                    ))),
          ],
        )
            : Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: InkWell(
                            onTap: () {
                              print(day_id);
                              print(day_name);
                            },
                            child: Text(
                                "Select available day to make an Appointment!",
                                style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            constraints: BoxConstraints(),
                            child: FutureBuilder(
                                future: myfuture,
                                builder: (_, AsyncSnapshot snapshot) {
                                  print(snapshot.data);
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return  SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height/5,

                                        child: SpinKitThreeInOut(color: Colors.white,size: 20,),
                                      );
                                    default:
                                      if (snapshot.hasError) {
                                        Text('Error: ${snapshot.error}');
                                      } else {
                                        return snapshot.hasData
                                            ?                                              Container(


                                          child: GridView.builder(
                                            padding: EdgeInsets.all(16),
                                            itemCount: snapshot.data.length,

                                            shrinkWrap: true,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              crossAxisSpacing: 16,

                                              mainAxisSpacing: 8,
                                              childAspectRatio: 4 / 4,
                                            ),
                                            itemBuilder: (BuildContext context, int index) {
                                              print('this');
                                              print(snapshot.data[index]['sessions']);

                                              return InkWell(
                                                onTap:  () {
                                                  setState(() {

                                                    days=snapshot.data[index]['visiting_day_id'];
                                                    time=snapshot.data[index]['id'].toString();
                                                    selectedCard = index;

                                                  });
                                                  print('this'+days);
                                                  print('this'+time);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:  selectedCard == index ? Colors.blue
                                                        :  Color(0xff0E6B50).withOpacity(.3),
                                                    borderRadius: BorderRadius.circular(8),

                                                  ),
                                                  child: Center(child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [

                                                      Text(snapshot.data[index]['sessions']),
                                                      Text(snapshot.data[index]['visiting_day_id']),
                                                    ],
                                                  )),
                                                ),
                                              );
                                            },
                                          ),
                                        )




                                            : Text('No data');
                                      }
                                  }
                                  return CircularProgressIndicator();
                                })),
//                               StreamBuilder(
//                                   stream: myfuture.asStream(),
//                                   builder: (context, snapshot) {
//                                     String chose = 'Class';
//
//                                     return snapshot.hasData
//                                         ? new Container(
//
//
//                                       child: GridView.builder(
//                                         padding: EdgeInsets.all(16),
//                                         itemCount: snapshot.data.length,
//
//                                         shrinkWrap: true,
//                                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 4,
//                                           crossAxisSpacing: 16,
//
//                                           mainAxisSpacing: 8,
//                                           childAspectRatio: 4 / 4,
//                                         ),
//                                         itemBuilder: (BuildContext context, int index) {
//                                           print('this');
// print(snapshot.data[0]['sessions']);
//
//                                           return InkWell(
//                                             onTap:  () {
//                                               setState(() {
//
//
//                                                 selectedCard = index;
//
//                                               });
//                                             },
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   color:  selectedCard == index ? Color(0xff0E6B50).withOpacity(.3)
//                                                       : null,
//                                                   borderRadius: BorderRadius.circular(8)),
//                                               child: Center(child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                 children: [
//                                                   Text('df'),
//                                                   // Text(snapshot.data[index]['visiting_day_id']),
//                                                 ],
//                                               )),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     )
//                                         : Container();
//                                   }),
                        SizedBox(
                          height: 30,
                        ),
                        days!=null && time!=null?InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_)=>specialist_doctor_form(
                              id: widget.patient_id,dayid: days,sesionid: time,
                            )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height/15,
                              width: MediaQuery.of(context).size.width/3,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child:  Center(
                                child: Text("Submit",
                                    style: GoogleFonts.lato(
                                        color:   Colors.white,

                                        fontWeight: FontWeight.w600,
                                        fontSize: 20)),
                              ),
                            ),
                          ),
                        ):Container()

                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: InkWell(
                        //     onTap: () {
                        //       print(sesion_naem);
                        //       print(sesion_id);
                        //     },
                        //     child: Text("Select available time slot !",
                        //         style: GoogleFonts.lato(
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.w600,
                        //             fontSize: 16)),
                        //   ),
                        // ),
                        // day_id!=null?    Container(
                        //   width: MediaQuery.of(context).size.width / 2,
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       color: Colors.black,
                        //       border: Border.all()),
                        //   child: Center(
                        //     child: StreamBuilder(
                        //         stream: sessionf.asStream(),
                        //         builder: (context, snapshot) {
                        //           String chose = 'Class';
                        //
                        //           return snapshot.hasData
                        //               ? new Container(
                        //                   child:
                        //                       new DropdownButton<String>(
                        //                     hint: sesion == null
                        //                         ? Padding(
                        //                             padding:
                        //                                 const EdgeInsets
                        //                                     .all(8.0),
                        //                             child: Text(
                        //                                 "Select Time slot",
                        //                                 style: TextStyle(
                        //                                     fontWeight:
                        //                                         FontWeight
                        //                                             .bold,
                        //                                     fontSize: 14,
                        //                                     color: Colors
                        //                                         .white)),
                        //                           )
                        //                         : Padding(
                        //                             padding:
                        //                                 const EdgeInsets
                        //                                     .all(8.0),
                        //                             child: Text(
                        //                                 sesion_naem,
                        //                                 style: TextStyle(
                        //                                     fontWeight:
                        //                                         FontWeight
                        //                                             .bold,
                        //                                     fontSize: 14,
                        //                                     color: Colors
                        //                                         .white)),
                        //                           ),
                        //                     items: snapshot
                        //                         .data
                        //                         .map<
                        //                             DropdownMenuItem<
                        //                                 String>>((value) =>
                        //                             new DropdownMenuItem<
                        //                                 String>(
                        //                               value: value["id"]
                        //                                       .toString() +
                        //                                   "_" +
                        //                                   value[
                        //                                       "sessions"],
                        //                               child: new Text(
                        //                                 value["sessions"],
                        //                               ),
                        //                             ))
                        //                         .toList(),
                        //                     onChanged: (value) {
                        //                       setState(() {
                        //                         sesion = value;
                        //                         print(sesion +
                        //                             " NEw value");
                        //                         val = sesion.split('_');
                        //                         print(val[0] +
                        //                             " NEw value");
                        //                         print(val[1] +
                        //                             " class value");
                        //                         sesion_naem = val[1];
                        //                         sesion_id = val[0];
                        //                       });
                        //                     },
                        //                     underline:
                        //                         DropdownButtonHideUnderline(
                        //                             child: Container()),
                        //                   ),
                        //                 )
                        //               : Container();
                        //         }),
                        //   ),
                        // ):Container(),
                      ],
                    ),
                  ),
                ),
                sesion!=null && day!=null?Positioned(
                    top:  MediaQuery.of(context).size.height/2.2,
                    left:  MediaQuery.of(context).size.width/4,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>specialist_doctor_form(
                          id: widget.patient_id,dayid: day_id,sesionid: sesion_id,
                        )));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height/10,
                        width: MediaQuery.of(context).size.width/2,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child:  Center(
                          child: Text("Submit",
                              style: GoogleFonts.lato(
                                  color:   Colors.white,

                                  fontWeight: FontWeight.w600,
                                  fontSize: 20)),
                        ),
                      ),
                    )):Positioned(
                    top:  MediaQuery.of(context).size.height/2.2,
                    left:  MediaQuery.of(context).size.width/4,
                    child: Container(

                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
