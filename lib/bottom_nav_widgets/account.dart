import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:avatar_letter/avatar_letter.dart';
import 'package:best_aid_customer/Screens/hospital_dhr.dart';
import 'package:best_aid_customer/Screens/upload_pop.dart';
import 'package:best_aid_customer/Screens/url/App_url.dart';
import 'package:best_aid_customer/Screens/view_report.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainHome.dart';
import '../all_hospitals.dart';
class account extends StatefulWidget {

  @override
  _accountState createState() => _accountState();
}

class _accountState extends State<account> {
  Future myfuture;
  Future<List<dynamic>> getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/api/customer/dhr/image/title/show";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  var data_T,hospital_connected;
  Future<List<dynamic>> data_count() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/api/customer/dhr/show/limited/hospital";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      var userData2= jsonDecode(response.body)['dataCount'];

      print("try");
      print(userData1);
      print(userData2);
      setState(() {
        data_T=userData2;
      });
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
Future medicals;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture=getpost();
    data_count();
    medicals=    data_count();

    getdata();
  } var name,phone,profile_image;
  getdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var picture_= prefs.getString('profile_image');
    var name_= prefs.getString('first_name');
    var phone_= prefs.getString('phone');

    setState(() {
      name=name_;
      phone=phone_;
      profile_image=picture_;

    });



  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child:
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/20,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Align(
            //       alignment: Alignment.topLeft,
            //       child:  InkWell(
            //         onTap: (){
            //           Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));
            //
            //         },
            //         child: Container(
            //           height: 50,
            //           width: 50,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.only(
            //               topRight: Radius.circular(40.0),
            //               bottomRight: Radius.circular(40.0),
            //             ),
            //             color: Color(0xff0E6B50),
            //
            //           ),
            //           child: IconButton(
            //             icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Text("Digital Health Record",style: GoogleFonts.lato(
            //         color: Colors.black,
            //         fontWeight: FontWeight.w700,
            //         fontSize: 18
            //     )),
            //     Padding(
            //       padding: const EdgeInsets.only(right:8.0),
            //       child: AvatarLetter(
            //         size: 25,
            //         backgroundColor: Color(0xff0E6B50),
            //         textColor: Colors.white,
            //         fontSize: 20,
            //         upperCase: true,
            //         numberLetters: 2,
            //         letterType: LetterType.Circular,
            //         text: name,
            //       ),
            //     ),
            //
            //   ],
            // ),
            Align(
              alignment:Alignment.topLeft,

              child: Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hello ',style: GoogleFonts.lato(
                            color:  Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                        ),
                        // Align(
                        //
                        //   child: Container(
                        //     width: width/3,
                        //     height: height/25,
                        //     decoration: BoxDecoration(
                        //         color: Colors.blue,
                        //         borderRadius: BorderRadius.circular(20)
                        //     ),
                        //     child: Center(child: Row(
                        //       children: [
                        //         Icon(Icons.upload_file,color: Colors.white,),
                        //         Text(
                        //           'Upload',style: GoogleFonts.lato(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.w700,
                        //             fontSize: 18),
                        //         ),
                        //       ],
                        //     ),),
                        //   ),
                        // )
                      ],
                    ),Text(
                      name!=null?name:" ",style: GoogleFonts.lato(
                        color:  Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,),


            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/40,),

                  Expanded(
                    child: Container(
                      height: height/8,
                      width: width/1.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:  Colors.black
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(data_T!=null?data_T.toString()+ ' +':'..',style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22
                                  ),), Text( "  Hospital Connected",style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16
                                  ),),
                                ],
                              ),
                            ),
                            // Column(
                            //   children: [
                            //     Text("Left",style: GoogleFonts.lato(
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.w800,
                            //         fontSize: 20
                            //     ),), Text('2.56 GB',style: GoogleFonts.lato(
                            //         color: Colors.white,
                            //         fontWeight: FontWeight.w600,
                            //         fontSize: 18
                            //     ),),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width/15,),
                  Expanded(
                    child: InkWell(
                      onTap:(){
                        showDialog(
                            context: context,
                            builder: (context){
                              return upload_pop();

                            });
                      },
                      child: Container(
                        height: height/8,
                        width: width/1.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:  Colors.lightBlue[100]
                        ),
                        child: Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(

                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 5,),

                                Icon(Icons.file_upload,color: Colors.white,size: 40,),
                                SizedBox(height: 5,),
                                Text(
                                  'Upload',style: GoogleFonts.lato(
                                    color:  Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/40,),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Hospital's",style:GoogleFonts.lato(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                      ),),InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>all_hospitals()));

                        },
                        child: Text("View All",style: GoogleFonts.lato(
                            color: Color(0xff0E6B50),
                            fontWeight: FontWeight.w900,
                            fontSize: 14
                        )),
                      )
                    ],
                  ),
                )),
            SizedBox(height: 5,),
            Container(
                constraints: BoxConstraints(),
                child: FutureBuilder<List<dynamic>>(
                    future: medicals,
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
                                ?                                                  Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Container(
                                height:height/9,
                                width:width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context,index){
                                      return InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (_)=>hospital_dhr(id: int.parse(snapshot.data[index]['medical_id']),)));
                                        },
                                        child: Container(
                                          width: width/3.5,
                                          child: Column(
                                            children: [
                                              Image.asset('images/w.png',height: 50,width: 50,),
                                              SizedBox(height: 10,),
                                              Text(
                                                snapshot.data[index]['medical']['name'] ,style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                              ),                          ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )




                          : Text('No data');
                          }
                      }
                      return CircularProgressIndicator();
                    })),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(thickness: 10,color: Colors.grey[300],),
            ),

            Container(
                constraints: BoxConstraints(),
                child: FutureBuilder<List<dynamic>>(
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
                                ?                                    Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:             Container(
                                height: height/1.5,
                                child: ListView.builder(

                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_,index){
                                      var dateTime = DateTime.parse(snapshot.data[index]['created_at']);

                                      return  snapshot.data[index]['title_count']==0?Container():Container(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap:(){
                                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>view_report(id_: snapshot.data[index]['id'].toString(),)));
                                                },
                                                child: Container(
                                                  height: height/5,
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                      color: Color(Random().nextInt(0x3fffffff)).withOpacity(0.3),
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  child: Column(

                                                    children: [
                                                      Align(
                                                        alignment:Alignment.topLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                DateFormat.yMMMMd('en_US') .format(dateTime)    ,style: GoogleFonts.lato(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 24),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ), Column(
                                                        children: [
                                                          Align(
                                                            alignment:Alignment.topLeft,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 8.0),
                                                              child: Row(
                                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,

                                                                children: [
                                                                  Container(
                                                                    width:width/3,
                                                                    child: Row(
                                                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Flexible(
                                                                          child: Text(
                                                                            snapshot.data[index]['title'],style: GoogleFonts.lato(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 18),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          snapshot.data[index]['title_count'].toString(),style: GoogleFonts.lato(
                                                                            color:  Color(Random().nextInt(0x3fffffff)).withOpacity(0.9),
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 50),
                                                                        ),
                                                                        Text(
                                                                          '  Files ',style: GoogleFonts.lato(
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 18),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:Alignment.topLeft,

                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left:8.0,top: 0),
                                                              child: Container(
                                                                width: width/4,
                                                                height: height/25,
                                                                decoration: BoxDecoration(
                                                                    color:  Color(Random().nextInt(0x3fffffff)).withOpacity(0.7),
                                                                    borderRadius: BorderRadius.circular(20)
                                                                ),
                                                                child: Center(child: Text(
                                                                  'View',style: GoogleFonts.lato(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 18),
                                                                ),),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
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
