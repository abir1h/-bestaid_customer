import 'dart:convert';

import 'package:avatar_letter/avatar_letter.dart';
import 'package:best_aid_customer/Screens/Doctor_list/Experience_tab.dart';
import 'package:best_aid_customer/Screens/Doctor_list/info_tab.dart';
import 'package:best_aid_customer/Screens/url/App_url.dart';
import 'package:best_aid_customer/Screens/visits/reason_dor_visit.dart';
import 'package:best_aid_customer/online_doctors/Book_appointment.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:http/http.dart'as http;

import '../../MainHome.dart';
class doctor_profile extends StatefulWidget {
  final String id;
  doctor_profile({this.id});
  @override
  _doctor_profileState createState() => _doctor_profileState();
}

class _doctor_profileState extends State<doctor_profile>with TickerProviderStateMixin {
  Future myfuture;
  var type,doctor;
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var id=widget.id;

    String url = "https://bestaid.com.bd/api/customer/show/doctor/$id";
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
  var name,phone,profile_image;
  getdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var picture_= prefs.getString('profile_image');
    var name_= prefs.getString('first_name');
    var phone_= prefs.getString('phone');

    setState(() {
      name=name_;
      phone=phone_;
      // profile_image=picture_;

    });



  }@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    myfuture=getpost();
    getdata();
}
var id;
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      floatingActionButton:Align(

        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(

          backgroundColor: Color(0xff0E6B50),
          onPressed: () {
           type=='gp'? Navigator.push(context, MaterialPageRoute(builder: (_)=>resaon_for_visit(id: widget.id,))):Navigator.push(context, MaterialPageRoute(builder: (_)=>book_appointment(patient_id: doctor.toString(),)));
          },
          icon: Icon(Icons.touch_app,color: Colors.white,),
          label: Text("Book Appointment",style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18
          )),

        ),
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child:  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));

                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0),
                        ),
                        color: Color(0xff0E6B50),

                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                      ),
                    ),
                  ),
                ),
                InkWell(
                 onTap: (){
                   print(type);
                 },
                  child: Text("Doctor Profile",style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: AvatarLetter(
                    size: 25,
                    backgroundColor: Color(0xff0E6B50),
                    textColor: Colors.white,
                    fontSize: 20,
                    upperCase: true,
                    numberLetters: 1,
                    letterType: LetterType.Circular,
                    text: name,
                  ),
                ),

              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,),
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
                              Center(child:SpinKitThreeInOut(
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
                                ?                  Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10),

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(bottom: 10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        CircularProfileAvatar(
                                                          null,
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                           AppUrl.pic_url1+snapshot.data['profile_image'],
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) => CircularProgressIndicator(),
                                                            errorWidget: (context, url, error) => Icon(Icons.person),
                                                          ),
                                                          elevation: 5,
                                                          radius: 45,
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Text(snapshot.data['name'],style: GoogleFonts.lato(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 16
                                                        )),
                                                        SizedBox(height: 10,),
                                                        Align(
                                                          alignment: Alignment.center,
                                                          child:  InkWell(
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (_)=>doctor_profile()));

                                                            },
                                                            child: Container(
                                                              height: height/10,
                                                              width: width/2.2,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(30),
                                                                color:  Color(0xffF5F5F5),

                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                        "Consultation Fee",style: GoogleFonts.lato(
                                                                        color: Colors.blue,
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: 18
                                                                    )
                                                                    ),Row(                              mainAxisAlignment: MainAxisAlignment.center,

                                                                      children: [
                                                                        Text(
                                                                            "৳ "+snapshot.data['pay_amount'],style: GoogleFonts.lato(
                                                                            color: Colors.blue,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 14
                                                                        )
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),


                                                      ],
                                                    ),
                                                  ),
                                                  Divider(color: Colors.grey[200],thickness: 10,),

                                                  Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Container(
                                                      width: width,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: width,
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.school,color: Color(0xff0E6B50),),SizedBox(width:15),
                                                                Flexible(
                                                                  child: Text(snapshot.data['degree_obtained'],style: GoogleFonts.lato(
                                                                      color: Colors.grey,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 12
                                                                  )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: width,
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.store,color: Color(0xff0E6B50),),SizedBox(width:15),
                                                                Flexible(
                                                                  child: Text("Department  "+ snapshot.data['department']['name'],style: GoogleFonts.lato(
                                                                      color: Colors.grey,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 12
                                                                  )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: width,
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.work,color: Color(0xff0E6B50),),SizedBox(width:15),
                                                                Flexible(
                                                                  child: Text("Working on  "+ snapshot.data['medical']['name'],style: GoogleFonts.lato(
                                                                      color: Colors.grey,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 12
                                                                  )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // Padding(
                                                          //   padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                                                          //   child: Text(snapshot.data['department']['name'],style: GoogleFonts.lato(
                                                          //       color: Color(0xff0E6B50),
                                                          //       fontWeight: FontWeight.w600,
                                                          //       fontSize: 16
                                                          //   )
                                                          //   ),
                                                          // ),
                                                          // Text(snapshot.data['type']=='gp'?"General Physician":"Specialist",style: GoogleFonts.lato(
                                                          //     color: Color(0xff0E6B50),
                                                          //     fontWeight: FontWeight.w600,
                                                          //     fontSize: 16
                                                          // )),
                                                        ],
                                                      ),
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

                                  Divider(color: Colors.grey[200],thickness: 10,),


                                  Container(
                                    margin: EdgeInsets.only(left: 60.0,right:60),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Text("Total Experience",style: GoogleFonts.lato(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12
                                              ),),
                                              Text(snapshot.data['experience'],style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                              )
                                              ),
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(color: Colors.black,),

                                        Container(
                                          child: Column(
                                            children: [
                                              Text("BMDC Number",style: GoogleFonts.lato(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12
                                              ),),
                                              Text(snapshot.data['bmdc_number']!=null?snapshot.data['bmdc_number']:'',style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                              )
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Divider(color: Colors.grey[200],thickness: 10,),

                                  TabBar(
                                    controller: _controller,
                                    isScrollable: true,
                                    indicatorColor: Colors.indigoAccent,
                                    tabs: [
                                      // Tab(icon: Icon(Icons.flight,color: Colors.black,)),
                                      Tab(child: Text("Info",style:  GoogleFonts.lato(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                      ),),),
                                      Tab(child: Text('Experience',style:  GoogleFonts.lato(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                      ),),),

                                    ],

                                  ),
                                  Container(
                                    height: 500,
                                    child: TabBarView(

                                      controller: _controller,
                                      children: [

                                        info_tab(id: widget.id,),
experience_tab(id: widget.id,)
                                      ],
                                    ),
                                  ),
                                ],
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
