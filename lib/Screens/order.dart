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
class order extends StatefulWidget {

  @override
  _orderState createState() => _orderState();
}

class _orderState extends State<order>with TickerProviderStateMixin {
  TabController _controllertab;
List status=[1,0,1,0,0,1,0,0,1,0];
List status2=[1,1,1,1,1,1,1,1,1,1];
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
    _controllertab = new TabController(length: 2, vsync: this);

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
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                Text("Order",style: GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18
                )),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: AvatarLetter(
                    size: 25,
                    backgroundColor: Color(0xff0E6B50),
                    textColor: Colors.white,
                    fontSize: 20,
                    upperCase: true,
                    numberLetters: 2,
                    letterType: LetterType.Circular,
                    text: name,
                  ),
                ),

              ],
            ),
          ),
              TabBar(
                controller: _controllertab,
                isScrollable: true,
                indicatorColor: Colors.indigoAccent,
                tabs: [
                  // Tab(icon: Icon(Icons.flight,color: Colors.black,)),
                  Tab(child: Text("Recent",style:  GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16
                  ),),),
                  Tab(child: Text('History ',style:  GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16
                  ),),),
                ],

              ),
              Container(
                height: height/1.3,
                child: TabBarView(

                  controller: _controllertab,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,

                        itemBuilder: (_,index){

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                // showModalBottomSheet(
                                //     backgroundColor: Colors.transparent,
                                //     isScrollControlled: true,
                                //     elevation: 10,
                                //     context: context,
                                //     builder: (context) {
                                //       return StatefulBuilder(
                                //           builder: (context, setState) {
                                //             return SingleChildScrollView(
                                //               child:                     Padding(
                                //                 padding: const EdgeInsets.all(8.0),
                                //                 child: Container(
                                //                   decoration: BoxDecoration(
                                //
                                //                     color: Colors.white,
                                //                     borderRadius: BorderRadius.circular(15),
                                //                   ),
                                //                   child: Column(
                                //                     crossAxisAlignment: CrossAxisAlignment.start,
                                //                     children: [
                                //                       Row(
                                //                         mainAxisAlignment: MainAxisAlignment.end,
                                //                         children: [
                                //                           IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close,color: Color(0x9f167940),))
                                //                         ],
                                //                       ),
                                //                       Column(
                                //                         children: [
                                //
                                //                           Padding(
                                //                             padding: const EdgeInsets.all(8.0),
                                //                             child: Row(
                                //                               children: [
                                //                                 CircleAvatar(
                                //
                                //                                   child: Center(child: Text('S',style: TextStyle(color: Colors.white),),),
                                //                                   backgroundColor: Colors.teal,
                                //                                   radius: 25,
                                //                                 ),
                                //                                 Padding(
                                //                                   padding: const EdgeInsets.all(8.0),
                                //                                   child: Column(
                                //                                     crossAxisAlignment: CrossAxisAlignment.start,
                                //                                     children: [
                                //                                       Text('Star Pharmacy',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                //                                       Text('Delpara bazar ,Naraynganj',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                                //                                     ],
                                //                                   ),
                                //                                 )
                                //                               ],
                                //                             ),
                                //                           ),
                                //                           Row(
                                //                             mainAxisAlignment:MainAxisAlignment.end,
                                //                             children: [
                                //                               Padding(
                                //                                 padding: const EdgeInsets.all(8.0),
                                //                                 child: Container(
                                //                                   decoration: BoxDecoration(
                                //                                       borderRadius: BorderRadius.circular(8),
                                //                                       color: Color(0x9f167940)
                                //                                   ),child: Padding(
                                //                                   padding: const EdgeInsets.only(left: 5.0,right: 5,top: 2,bottom: 2),
                                //                                   child: Center(child: Text('UP TO 13 %',style: TextStyle(color: Colors.white),),),
                                //                                 ),
                                //                                 ),
                                //                               )
                                //                             ],),
                                //                         ],
                                //                       ),
                                //                       Container(
                                //                         width: width,
                                //                         color: Colors.white,
                                //                         child: Column(
                                //                           crossAxisAlignment: CrossAxisAlignment.start,
                                //                           children: [
                                //                             Padding(
                                //                               padding: const EdgeInsets.all(8.0),
                                //                               child: Text(
                                //                                 "More Information",
                                //                                 style: TextStyle(
                                //                                     color: Colors.black,
                                //                                     fontWeight: FontWeight.w600,
                                //                                     fontSize: 18),
                                //                               ),
                                //                             ),
                                //
                                //                             Row(
                                //                               mainAxisAlignment:
                                //                               MainAxisAlignment.start,
                                //                               children: [
                                //                                 Expanded(
                                //                                   child: Padding(
                                //                                     padding: const EdgeInsets.only(left: 8.0),
                                //                                     child: Text(
                                //                                       "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ",
                                //                                       style: TextStyle(
                                //                                           color: Colors.grey,
                                //                                           fontWeight: FontWeight.w600,
                                //                                           fontSize: 12),
                                //                                     ),
                                //                                   ),
                                //                                 ),
                                //                               ],
                                //                             ),
                                //                             SizedBox(height: 15,),
                                //                             Padding(
                                //                               padding: const EdgeInsets.all(8.0),
                                //                               child: Row(
                                //                                 mainAxisAlignment: MainAxisAlignment.center,
                                //                                 children: [
                                //                                   InkWell(
                                //                                     onTap:(){
                                //                                       showDialog(
                                //                                           context: context,
                                //                                           builder: (context) {
                                //                                             return LifeStyle_pop();
                                //                                           });
                                //                                     },
                                //                                     child: Container(
                                //                                         width: width / 4,
                                //                                         height: height / 25,
                                //                                         decoration: BoxDecoration(
                                //                                             border: Border.all(
                                //                                                 color: Color(0x9f167940)),
                                //                                             borderRadius:
                                //                                             BorderRadius.circular(8)),
                                //                                         child: Padding(
                                //                                           padding:
                                //                                           const EdgeInsets.all(4.0),
                                //                                           child: Center(
                                //                                               child: Text(
                                //                                                 "Book Now",
                                //                                                 style: TextStyle(
                                //                                                     color: Color(0x9f167940),
                                //                                                     fontWeight: FontWeight.w600,
                                //                                                     fontSize: 14),
                                //                                               )),
                                //                                         )),
                                //                                   ),
                                //                                   // SizedBox(width: 15,),
                                //                                   // Container(
                                //                                   //     width: width / 4,
                                //                                   //     height: height / 25,
                                //                                   //     decoration: BoxDecoration(
                                //                                   //         color: Colors.pinkAccent,
                                //                                   //         borderRadius:
                                //                                   //         BorderRadius.circular(8)),
                                //                                   //     child: Padding(
                                //                                   //       padding:
                                //                                   //       const EdgeInsets.all(4.0),
                                //                                   //       child: Center(
                                //                                   //           child: Text(
                                //                                   //             "Details",
                                //                                   //             style: TextStyle(
                                //                                   //                 color: Colors.white,
                                //                                   //                 fontWeight: FontWeight.w600,
                                //                                   //                 fontSize: 14),
                                //                                   //           )),
                                //                                   //     )),
                                //                                 ],
                                //                               ),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       )
                                //                     ],
                                //                   ),
                                //                 ),
                                //               ),
                                //
                                //             );
                                //           });
                                //     });
                              },
                              child: Container(
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:Colors.grey
                                          .withOpacity(
                                          0.3),

                                      spreadRadius: 5,

                                      blurRadius: 7,

                                      offset: Offset(2,
                                          2), // changes position of shadow
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(

                                            child: Center(child: Text('S',style: TextStyle(color: Colors.white),),),
                                            backgroundColor: Colors.teal,
                                            radius: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Star Pharmacy',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                                Text('Delpara bazar ,Naraynganj',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                                                Text('Transaction ID : dsfsgfsg',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.normal),),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.end,
                                      children: [
                                        status[index]==0? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Colors.red
                                            ),child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0,right: 5,top: 2,bottom: 2),
                                            child: Center(child: Text('Pending'.toString().toUpperCase(),style: TextStyle(color: Colors.white),),),
                                          ),
                                          ),
                                        ):Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Color(0x9f167940)
                                            ),child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0,right: 5,top: 2,bottom: 2),
                                            child: Center(child: Text('Confirmed'.toString().toUpperCase(),style: TextStyle(color: Colors.white),),),
                                          ),
                                          ),
                                        )
                                      ],),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,

                        itemBuilder: (_,index){

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                // showModalBottomSheet(
                                //     backgroundColor: Colors.transparent,
                                //     isScrollControlled: true,
                                //     elevation: 10,
                                //     context: context,
                                //     builder: (context) {
                                //       return StatefulBuilder(
                                //           builder: (context, setState) {
                                //             return SingleChildScrollView(
                                //               child:                     Padding(
                                //                 padding: const EdgeInsets.all(8.0),
                                //                 child: Container(
                                //                   decoration: BoxDecoration(
                                //
                                //                     color: Colors.white,
                                //                     borderRadius: BorderRadius.circular(15),
                                //                   ),
                                //                   child: Column(
                                //                     crossAxisAlignment: CrossAxisAlignment.start,
                                //                     children: [
                                //                       Row(
                                //                         mainAxisAlignment: MainAxisAlignment.end,
                                //                         children: [
                                //                           IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close,color: Color(0x9f167940),))
                                //                         ],
                                //                       ),
                                //                       Column(
                                //                         children: [
                                //
                                //                           Padding(
                                //                             padding: const EdgeInsets.all(8.0),
                                //                             child: Row(
                                //                               children: [
                                //                                 CircleAvatar(
                                //
                                //                                   child: Center(child: Text('S',style: TextStyle(color: Colors.white),),),
                                //                                   backgroundColor: Colors.teal,
                                //                                   radius: 25,
                                //                                 ),
                                //                                 Padding(
                                //                                   padding: const EdgeInsets.all(8.0),
                                //                                   child: Column(
                                //                                     crossAxisAlignment: CrossAxisAlignment.start,
                                //                                     children: [
                                //                                       Text('Star Pharmacy',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                //                                       Text('Delpara bazar ,Naraynganj',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                                //                                     ],
                                //                                   ),
                                //                                 )
                                //                               ],
                                //                             ),
                                //                           ),
                                //                           Row(
                                //                             mainAxisAlignment:MainAxisAlignment.end,
                                //                             children: [
                                //                               Padding(
                                //                                 padding: const EdgeInsets.all(8.0),
                                //                                 child: Container(
                                //                                   decoration: BoxDecoration(
                                //                                       borderRadius: BorderRadius.circular(8),
                                //                                       color: Color(0x9f167940)
                                //                                   ),child: Padding(
                                //                                   padding: const EdgeInsets.only(left: 5.0,right: 5,top: 2,bottom: 2),
                                //                                   child: Center(child: Text('UP TO 13 %',style: TextStyle(color: Colors.white),),),
                                //                                 ),
                                //                                 ),
                                //                               )
                                //                             ],),
                                //                         ],
                                //                       ),
                                //                       Container(
                                //                         width: width,
                                //                         color: Colors.white,
                                //                         child: Column(
                                //                           crossAxisAlignment: CrossAxisAlignment.start,
                                //                           children: [
                                //                             Padding(
                                //                               padding: const EdgeInsets.all(8.0),
                                //                               child: Text(
                                //                                 "More Information",
                                //                                 style: TextStyle(
                                //                                     color: Colors.black,
                                //                                     fontWeight: FontWeight.w600,
                                //                                     fontSize: 18),
                                //                               ),
                                //                             ),
                                //
                                //                             Row(
                                //                               mainAxisAlignment:
                                //                               MainAxisAlignment.start,
                                //                               children: [
                                //                                 Expanded(
                                //                                   child: Padding(
                                //                                     padding: const EdgeInsets.only(left: 8.0),
                                //                                     child: Text(
                                //                                       "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ",
                                //                                       style: TextStyle(
                                //                                           color: Colors.grey,
                                //                                           fontWeight: FontWeight.w600,
                                //                                           fontSize: 12),
                                //                                     ),
                                //                                   ),
                                //                                 ),
                                //                               ],
                                //                             ),
                                //                             SizedBox(height: 15,),
                                //                             Padding(
                                //                               padding: const EdgeInsets.all(8.0),
                                //                               child: Row(
                                //                                 mainAxisAlignment: MainAxisAlignment.center,
                                //                                 children: [
                                //                                   InkWell(
                                //                                     onTap:(){
                                //                                       showDialog(
                                //                                           context: context,
                                //                                           builder: (context) {
                                //                                             return LifeStyle_pop();
                                //                                           });
                                //                                     },
                                //                                     child: Container(
                                //                                         width: width / 4,
                                //                                         height: height / 25,
                                //                                         decoration: BoxDecoration(
                                //                                             border: Border.all(
                                //                                                 color: Color(0x9f167940)),
                                //                                             borderRadius:
                                //                                             BorderRadius.circular(8)),
                                //                                         child: Padding(
                                //                                           padding:
                                //                                           const EdgeInsets.all(4.0),
                                //                                           child: Center(
                                //                                               child: Text(
                                //                                                 "Book Now",
                                //                                                 style: TextStyle(
                                //                                                     color: Color(0x9f167940),
                                //                                                     fontWeight: FontWeight.w600,
                                //                                                     fontSize: 14),
                                //                                               )),
                                //                                         )),
                                //                                   ),
                                //                                   // SizedBox(width: 15,),
                                //                                   // Container(
                                //                                   //     width: width / 4,
                                //                                   //     height: height / 25,
                                //                                   //     decoration: BoxDecoration(
                                //                                   //         color: Colors.pinkAccent,
                                //                                   //         borderRadius:
                                //                                   //         BorderRadius.circular(8)),
                                //                                   //     child: Padding(
                                //                                   //       padding:
                                //                                   //       const EdgeInsets.all(4.0),
                                //                                   //       child: Center(
                                //                                   //           child: Text(
                                //                                   //             "Details",
                                //                                   //             style: TextStyle(
                                //                                   //                 color: Colors.white,
                                //                                   //                 fontWeight: FontWeight.w600,
                                //                                   //                 fontSize: 14),
                                //                                   //           )),
                                //                                   //     )),
                                //                                 ],
                                //                               ),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       )
                                //                     ],
                                //                   ),
                                //                 ),
                                //               ),
                                //
                                //             );
                                //           });
                                //     });
                              },
                              child: Container(
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color:Colors.grey
                                          .withOpacity(
                                          0.3),

                                      spreadRadius: 5,

                                      blurRadius: 7,

                                      offset: Offset(2,
                                          2), // changes position of shadow
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(

                                            child: Center(child: Text('S',style: TextStyle(color: Colors.white),),),
                                            backgroundColor: Colors.teal,
                                            radius: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Star Pharmacy',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                                Text('Delpara bazar ,Naraynganj',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                                                Text('Transaction ID : dsfsgfsg',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.normal),),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.end,
                                      children: [
                                        status2[index]==0? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Colors.red
                                            ),child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0,right: 5,top: 2,bottom: 2),
                                            child: Center(child: Text('Pending'.toString().toUpperCase(),style: TextStyle(color: Colors.white),),),
                                          ),
                                          ),
                                        ):Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: Color(0x9f167940)
                                            ),child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0,right: 5,top: 2,bottom: 2),
                                            child: Center(child: Text('Confirmed'.toString().toUpperCase(),style: TextStyle(color: Colors.white),),),
                                          ),
                                          ),
                                        )
                                      ],),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),



                  ],
                ),
              ),

            ],
          )
      ),
    ));
  }
}
