import 'dart:convert';

import 'package:best_aid_customer/Screens/Doctor_list/department_doctors.dart';
import 'package:best_aid_customer/Screens/Doctor_list/docotors.dart';
import 'package:best_aid_customer/Screens/View_all/view_all.dart';
import 'package:best_aid_customer/Screens/View_all/view_medical.dart';
import 'package:best_aid_customer/Screens/doctor_profile/dotor_profile.dart';
import 'package:best_aid_customer/Screens/psyco_bookig.dart';
import 'package:best_aid_customer/Screens/url/App_url.dart';
import 'package:best_aid_customer/online_doctors/gp_doctor.dart';
import 'package:best_aid_customer/online_doctors/sp_doctors.dart';
import 'package:best_aid_customer/utils/data.dart';
import 'package:best_aid_customer/widgets/build_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'account.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  var name, phone, profile_image;

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name_ = prefs.getString('first_name');
    var phone_ = prefs.getString('phone');

    setState(() {
      name = name_;
      phone = phone_;
    });
  }

  Future myfuture;
  Future online_doctors;
  Future department;
  Future balance;
  var life_income, served;
  bool isloaded_ = false;

  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/api/customer/show/gp/doctor";
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

  Future<List<dynamic>> balance_() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/api/customer/show/dashboard";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      setState(() {
        isloaded_ = true;
        life_income = userData1['earn'];
        served = userData1['serveCount'];
      });
    } else {
      setState(() {
        isloaded_ = false;
      });
      print("post have no Data${response.body}");
    }
  }

  Future<List<dynamic>> departments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/api/customer/show/department/home";
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

  Future<List<dynamic>> hospitals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/api/customer/show/medical/home";
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

  Future medical_home;

  Future<List<dynamic>> specialist_docotr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(
        Uri.parse('https://bestaid.com.bd/api/customer/show/all/doctor'),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    myfuture = specialist_docotr();
    online_doctors = emergency();
    department = departments();
    medical_home = hospitals();
    balance = balance_();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRouteageRoute(builder: (_)=>rough()));
                      },
                      child: Shimmer.fromColors(
                        highlightColor: Color(0xffED2D43),
                        baseColor: Color(0xff0E6B50),
                        child: Text(
                          "Best",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w800,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Shimmer.fromColors(
                      highlightColor: Color(0xff0E6B50),
                      baseColor: Color(0xffED2D43),
                      child: Text(
                        "Aid",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),

              Divider(
                color: Colors.grey[200],
                thickness: 10,
              ),

              //Shunbo book now
              // Container(
              //   margin: EdgeInsets.only(left: 5.0),
              //   width: width,
              //   decoration: BoxDecoration(color: Colors.white),
              //   child: InkWell(
              //     onTap: () {},
              //     child: Container(
              //       margin: EdgeInsets.only(left: 35.0),
              //       decoration: BoxDecoration(),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               SizedBox(
              //                 height: height / 30,
              //               ),
              //               Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Row(
              //                         children: [
              //                           Icon(
              //                             Icons.call,
              //                             color: Color(0xff0E6B50),
              //                             size: 50,
              //                           ),
              //                           Padding(
              //                             padding: const EdgeInsets.only(
              //                                 left: 5, bottom: 2),
              //                             child: Text("Shunbo!",
              //                                 style: GoogleFonts.roboto(
              //                                     color: Colors.black,
              //                                     fontWeight: FontWeight.w800,
              //                                     fontSize: 24)),
              //                           ),
              //                         ],
              //                       ),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                       Text(
              //                           "Our expert doctors\n can answer all your questions\n over  call",
              //                           style: GoogleFonts.lato(
              //                               color: Colors.grey,
              //                               fontWeight: FontWeight.w700,
              //                               fontSize: 14)),
              //                     ],
              //                   ),
              //                   SizedBox(
              //                     height: height / 50,
              //                   ),
              //                 ],
              //               ),
              //               // Column(
              //               //   crossAxisAlignment: CrossAxisAlignment.start,
              //               //   children: [
              //               //     Column(
              //               //       crossAxisAlignment: CrossAxisAlignment.start,
              //               //
              //               //       children: [
              //               //         Text("Emergency ?",style: GoogleFonts.roboto(
              //               //             color: Colors.black,
              //               //             fontWeight: FontWeight.w800,
              //               //             fontSize: 20
              //               //         )),
              //               //         SizedBox(height: 10,),
              //               //         Text("Our expert doctors\n can answer all your questions\n over video call",style: GoogleFonts.lato(
              //               //             color: Colors.grey,
              //               //             fontWeight: FontWeight.w700,
              //               //             fontSize: 14
              //               //         )),
              //               //       ],
              //               //     ),
              //               //     SizedBox(height: height/50,),
              //               //   ],
              //               // ) ,
              //
              //               InkWell(
              //                 onTap: () {
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (_) => psyco_booking(),
              //                     ),
              //                   );
              //                 },
              //                 child: Container(
              //                   width: width / 4,
              //                   height: height / 20,
              //                   margin: EdgeInsets.only(left: width / 4),
              //                   decoration: BoxDecoration(
              //                       color: Colors.white,
              //                       borderRadius: BorderRadius.circular(10),
              //                       border:
              //                           Border.all(color: Color(0xff0E6B50))),
              //                   child: Row(
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Shimmer.fromColors(
              //                         highlightColor: Color(0xffED2D43),
              //                         baseColor: Color(0xff0E6B50),
              //                         child: Text(
              //                           "Book Now",
              //                           style: TextStyle(
              //                               color: Colors.black,
              //                               fontWeight: FontWeight.w600,
              //                               fontSize: 14),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               )
              //             ],
              //           ),
              //           Container(
              //             margin: EdgeInsets.only(bottom: 30),
              //             child: Image.asset(
              //               'images/vec.jpg',
              //               height: height / 6,
              //               width: width / 2.8,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              //image slider
              CarouselSlider.builder(
                itemCount: sliderImages.length,
                options: CarouselOptions(
                  height: height * 0.2,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 2),
                  enlargeCenterPage: true,
                  onPageChanged: (index, whatever){
                    print(index.toString());
                  }
                ),
                itemBuilder: (context, index, realIndex) {
                  final imageIndex = sliderImages[index];
                  return buildImage(imageIndex, index);
                },
              ),

              Divider(
                color: Colors.grey[200],
                thickness: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: InkWell(
              //     onTap: (){
              //       Navigator.push(context, MaterialPageRoute(builder: (_)=>card_tap()));
              //     },
              //     child: Container(
              //      width: width,
              //       decoration:BoxDecoration(
              //         borderRadius: BorderRadius.circular(15),
              //           gradient: LinearGradient(
              //             begin: Alignment.centerLeft,
              //             end: Alignment.centerRight,
              //             colors: [
              //               Color(0xff0E6B50),
              //               Color(0x9f167940),
              //                                   ],
              //           ),
              //         boxShadow: [
              //           BoxShadow(
              //             color:Color(0xff0E6B50)
              //                 .withOpacity(
              //                 0.5),
              //
              //             spreadRadius: 7,
              //
              //             blurRadius: 7,
              //
              //             offset: Offset(2,
              //                 9), // changes position of shadow
              //           )
              //         ],
              //       ),child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Icon(Icons.nightlife,color:Colors.white,size: 40,),
              //           SizedBox(height: height/28,),
              //
              //           Text('LifeStyle Card'.toUpperCase(),style: TextStyle(color: Color(0xffBBA14F),fontWeight: FontWeight.w900,fontSize: 20,letterSpacing: 5),),
              //           SizedBox(height: height/28,),
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Column(crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text('Price',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
              //                   Row(
              //                     children: [
              //                       Text('100 TAKA',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18,
              //                           // decoration: TextDecoration.lineThrough
              //                       )),
              //
              //                     ],
              //                   ),
              //                   // Text('  0 TAKA',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18,)),
              //                 ],
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Column(
              //                   children: [
              //                     Image.asset('images/floatButton.png',height: 40,width: 40,),
              //                     Row(
              //                       children: [
              //                         Text('Best ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              //                         Text('Aid',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
              //                       ],
              //                     )
              //
              //                   ],
              //                 ),
              //               ),
              //
              //             ],
              //           )
              //         ],
              //     ),
              //       ),
              //     ),
              //   ),
              // ),           SizedBox(height: 20,),

              Container(
                // Here the height of the container is 45% of our total height

                width: width,

                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => account(),
                                ),
                              );
                              // Fluttertoast.showToast(
                              //
                              //     msg: "Service will available very soon!!!",
                              //     toastLength: Toast.LENGTH_LONG,
                              //     gravity: ToastGravity.BOTTOM,
                              //     timeInSecForIosWeb: 1,
                              //     backgroundColor: Colors.black54,
                              //     textColor: Colors.white,
                              //     fontSize: 16.0);
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                      height: height / 8,
                                      width: width / 3,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              topLeft: Radius.circular(20)),
                                          color: Color(0xff0E6B50)),
                                      child: Icon(Icons.add_to_home_screen,
                                          color: Colors.white, size: 60)),
                                  Expanded(
                                    child: Container(
                                      height: height / 8,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                      ),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("  Digital Health Records",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 18)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                " Keep your records on cloud and maintain a sound  health ",
                                                style: GoogleFonts.lato(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 40,
                        ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 10,
                        ),
                        SizedBox(
                          height: height / 40,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Department's",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => view_all()));
                                      // Fluttertoast.showToast(
                                      //
                                      //     msg: "Service will available very soon!!!",
                                      //     toastLength: Toast.LENGTH_LONG,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIosWeb: 1,
                                      //     backgroundColor: Colors.black54,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0);
                                    },
                                    child: Text("View All",
                                        style: GoogleFonts.lato(
                                            color: Color(0xff0E6B50),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14)),
                                  )
                                ],
                              ),
                            )),
                        Container(
                          constraints: BoxConstraints(),
                          child: FutureBuilder(
                            future: department,
                            builder: (_, AsyncSnapshot snapshot) {
                              print(snapshot.data);
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: ListView.builder(
                                        itemBuilder: (_, __) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: 48.0,
                                                height: 48.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      width: double.infinity,
                                                      height: 8.0,
                                                      color: Colors.white,
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 8.0,
                                                      color: Colors.white,
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0),
                                                    ),
                                                    Container(
                                                      width: 40.0,
                                                      height: 8.0,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        itemCount: 6,
                                      ),
                                    ),
                                  );
                                default:
                                  if (snapshot.hasError) {
                                    Text('Error: ${snapshot.error}');
                                  } else {
                                    return snapshot.hasData
                                        ? Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5.2,
                                              child: GridView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              90,
                                                          childAspectRatio:
                                                              4 / 4,
                                                          crossAxisSpacing: 10,
                                                          mainAxisSpacing: 10),
                                                  itemCount:
                                                      snapshot.data.length,
                                                  itemBuilder:
                                                      (BuildContext ctx,
                                                          index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        // Fluttertoast.showToast(
                                                        //
                                                        //     msg: "Service will available very soon!!!",
                                                        //     toastLength: Toast.LENGTH_LONG,
                                                        //     gravity: ToastGravity.BOTTOM,
                                                        //     timeInSecForIosWeb: 1,
                                                        //     backgroundColor: Colors.black54,
                                                        //     textColor: Colors.white,
                                                        //     fontSize: 16.0);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    department_doctors(
                                                                      id: snapshot
                                                                          .data[
                                                                              index]
                                                                              [
                                                                              'id']
                                                                          .toString(),
                                                                    )));
                                                      },
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CachedNetworkImage(
                                                                imageUrl: AppUrl
                                                                        .pic_url1 +
                                                                    snapshot.data[
                                                                            index]
                                                                        [
                                                                        'image'],
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 40,
                                                                width: 40,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    CircularProgressIndicator(),
                                                                errorWidget:
                                                                    (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(
                                                                          Icons
                                                                              .source,
                                                                          color:
                                                                              Color(0xff00D2CD),
                                                                        )),
                                                            Text(
                                                                snapshot.data[
                                                                        index]
                                                                    ['name'],
                                                                style: GoogleFonts.lato(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        10))
                                                          ],
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
                            },
                          ),
                        ),
                        SizedBox(
                          height: height / 40,
                        ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 10,
                        ),
                        SizedBox(
                          height: height / 40,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Emergency Doctors",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => gp_doctor()));
                                      // Fluttertoast.showToast(
                                      //
                                      //     msg: "Service will available very soon!!!",
                                      //     toastLength: Toast.LENGTH_LONG,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIosWeb: 1,
                                      //     backgroundColor: Colors.black54,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0);
                                    },
                                    child: Text("View All",
                                        style: GoogleFonts.lato(
                                            color: Color(0xff0E6B50),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14)),
                                  )
                                ],
                              ),
                            )),
                        Container(
                            child: FutureBuilder<List<dynamic>>(
                                future: online_doctors,
                                builder: (_, AsyncSnapshot snapshot) {
                                  print(snapshot.data);
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: height / 2,
                                          ),
                                          Center(
                                              child: SpinKitRotatingCircle(
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
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  height: height / 1.6,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          snapshot.data.length,
                                                      itemBuilder: (_, index) {
                                                        // var imagelink=snapshot.data[index]['profile_image']!=null?snapshot.data[index]['profile_image']:'link';

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          doctor_profile(
                                                                            id: snapshot.data[index]['id'].toString(),
                                                                          )));
                                                              // Fluttertoast.showToast(
                                                              //
                                                              //     msg: "Service will available very soon!!!",
                                                              //     toastLength: Toast.LENGTH_LONG,
                                                              //     gravity: ToastGravity.BOTTOM,
                                                              //     timeInSecForIosWeb: 1,
                                                              //     backgroundColor: Colors.black54,
                                                              //     textColor: Colors.white,
                                                              //     fontSize: 16.0);
                                                            },
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height:
                                                                        height /
                                                                            1.8,
                                                                    width:
                                                                        width /
                                                                            1.5,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.2),

                                                                          spreadRadius:
                                                                              2,

                                                                          blurRadius:
                                                                              7,

                                                                          offset: Offset(
                                                                              2,
                                                                              1), // changes position of shadow
                                                                        )
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              height / 2.12,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Container(
                                                                                height: height / 4,
                                                                                width: width / 1.6,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.fitHeight, image: NetworkImage(AppUrl.pic_url1 + snapshot.data[index]['profile_image']))),
                                                                              ),
                                                                              Align(
                                                                                  alignment: Alignment.topLeft,
                                                                                  child: Text(
                                                                                    snapshot.data[0]['type'] == 'gp' ? "General Physician" : "Specialist",
                                                                                    style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12),
                                                                                  )),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Align(
                                                                                      alignment: Alignment.topLeft,
                                                                                      child: Text(snapshot.data[index]['name'], style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
                                                                                    ),
                                                                                    Align(
                                                                                      alignment: Alignment.topLeft,
                                                                                      child: Text(
                                                                                        snapshot.data[index]['degree_obtained'],
                                                                                        style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14),
                                                                                      ),
                                                                                    ),
                                                                                    Align(
                                                                                      alignment: Alignment.topLeft,
                                                                                      child: Text(snapshot.data[index]['experience'] + " years", style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
                                                                                    ),
                                                                                    Align(
                                                                                        alignment: Alignment.topLeft,
                                                                                        child: Text(
                                                                                          "Total Experience",
                                                                                          style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12),
                                                                                        )),
                                                                                    Align(
                                                                                      alignment: Alignment.topLeft,
                                                                                      child: Text(snapshot.data[index]['medical']['name'] + "(" + snapshot.data[index]['department']['name'] + ')', style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),
                                                                                    ),
                                                                                    Align(
                                                                                      alignment: Alignment.topLeft,
                                                                                      child: Text(
                                                                                        "Working on",
                                                                                        style: GoogleFonts.lato(
                                                                                          color: Colors.grey,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: 12,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Divider(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(bottom: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text("৳" + snapshot.data[index]['pay_amount'], style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18)),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Text("per consultation", style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 14)),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Align(
                                                                                alignment: Alignment.topRight,
                                                                                child: InkWell(
                                                                                  onTap: () {},
                                                                                  child: Container(
                                                                                    height: 35,
                                                                                    width: 40,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.only(
                                                                                        topLeft: Radius.circular(40.0),
                                                                                        bottomLeft: Radius.circular(40.0),
                                                                                      ),
                                                                                      color: Color(0xff0E6B50),
                                                                                    ),
                                                                                    child: IconButton(
                                                                                      onPressed: () {},
                                                                                      icon: Icon(
                                                                                        Icons.arrow_forward,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                ],
                                                              ),
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
                        Divider(
                          color: Colors.grey[200],
                          thickness: 10,
                        ),
                        SizedBox(
                          height: height / 60,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Specialist Doctors",
                                  style: GoogleFonts.lato(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => sp_doctor()));
                                    // Fluttertoast.showToast(
                                    //
                                    //     msg: "Service will available very soon!!!",
                                    //     toastLength: Toast.LENGTH_LONG,
                                    //     gravity: ToastGravity.BOTTOM,
                                    //     timeInSecForIosWeb: 1,
                                    //     backgroundColor: Colors.black54,
                                    //     textColor: Colors.white,
                                    //     fontSize: 16.0);
                                  },
                                  child: Text(
                                    "View All",
                                    style: GoogleFonts.lato(
                                      color: Color(0xff0E6B50),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(),
                          child: FutureBuilder<List<dynamic>>(
                            future: myfuture,
                            builder: (_, AsyncSnapshot snapshot) {
                              print(snapshot.data);
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: height / 2,
                                      ),
                                      Center(
                                          child: SpinKitThreeInOut(
                                        color: Color(0xff0E6B50),
                                        size: 20,
                                      )),
                                    ],
                                  );
                                default:
                                  if (snapshot.hasError) {
                                    Text('Error: ${snapshot.error}');
                                  } else {
                                    return snapshot.hasData
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                            ),
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 40),
                                              height: height / 7,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      snapshot.data.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (_, index) {
                                                    var imagelink = snapshot
                                                                    .data[index]
                                                                [
                                                                'profile_image'] !=
                                                            null
                                                        ? snapshot.data[index]
                                                            ['profile_image']
                                                        : 'link';

                                                    return snapshot.data[index]
                                                                ['type'] ==
                                                            'specialist'
                                                        ? Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (_) =>
                                                                              doctor_profile(
                                                                        id: snapshot
                                                                            .data[index]['id']
                                                                            .toString(),
                                                                      ),
                                                                    ),
                                                                  );
                                                                  // Fluttertoast.showToast(
                                                                  //
                                                                  //     msg: "Service will available very soon!!!",
                                                                  //     toastLength: Toast.LENGTH_LONG,
                                                                  //     gravity: ToastGravity.BOTTOM,
                                                                  //     timeInSecForIosWeb: 1,
                                                                  //     backgroundColor: Colors.black54,
                                                                  //     textColor: Colors.white,
                                                                  //     fontSize: 16.0);
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      5,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      1.1,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.2),

                                                                        spreadRadius:
                                                                            2,

                                                                        blurRadius:
                                                                            4,

                                                                        offset: Offset(
                                                                            2,
                                                                            1), // changes position of shadow
                                                                      )
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                MediaQuery.of(context).size.height / 12,
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 8,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(5), image: DecorationImage(image: NetworkImage(AppUrl.pic_url1 + imagelink), fit: BoxFit.cover)),
                                                                          ),
                                                                        ),
                                                                        Flexible(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(snapshot.data[index]['name'], maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18)),
                                                                              Text(snapshot.data[index]['degree_obtained'], overflow: TextOverflow.ellipsis, style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(right: 15),
                                                                          height:
                                                                              30,
                                                                          width:
                                                                              30,
                                                                          decoration: BoxDecoration(
                                                                              color: Color(0xff0E6B50),
                                                                              borderRadius: BorderRadius.circular(5)),
                                                                          child:
                                                                              Icon(
                                                                            Icons.arrow_forward,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              )
                                                            ],
                                                          )
                                                        : Container();
                                                  }),
                                            ),
                                          )
                                        : Text('No data');
                                  }
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 10,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Hospitals",
                                  style: GoogleFonts.lato(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => view_all_medical(),
                                      ),
                                    );
                                    // Fluttertoast.showToast(
                                    //
                                    //     msg: "Service will available very soon!!!",
                                    //     toastLength: Toast.LENGTH_LONG,
                                    //     gravity: ToastGravity.BOTTOM,
                                    //     timeInSecForIosWeb: 1,
                                    //     backgroundColor: Colors.black54,
                                    //     textColor: Colors.white,
                                    //     fontSize: 16.0);
                                  },
                                  child: Text(
                                    "View All",
                                    style: GoogleFonts.lato(
                                      color: Color(0xff0E6B50),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(),
                          child: FutureBuilder(
                            future: medical_home,
                            builder: (_, AsyncSnapshot snapshot) {
                              print(snapshot.data);
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: ListView.builder(
                                        itemBuilder: (_, __) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: 48.0,
                                                height: 48.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      width: double.infinity,
                                                      height: 8.0,
                                                      color: Colors.white,
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 8.0,
                                                      color: Colors.white,
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 2.0),
                                                    ),
                                                    Container(
                                                      width: 40.0,
                                                      height: 8.0,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        itemCount: 6,
                                      ),
                                    ),
                                  );
                                default:
                                  if (snapshot.hasError) {
                                    Text('Error: ${snapshot.error}');
                                  } else {
                                    return snapshot.hasData
                                        ? Container(
                                            child: GridView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                                        maxCrossAxisExtent: 200,
                                                        childAspectRatio: 4 / 3,
                                                        crossAxisSpacing: 7,
                                                        mainAxisSpacing: 10),
                                                itemCount: snapshot.data.length,
                                                itemBuilder:
                                                    (BuildContext ctx, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                doctors(
                                                              id: snapshot
                                                                  .data[index]
                                                                      ['id']
                                                                  .toString(),
                                                            ),
                                                          ),
                                                        );
                                                        // Fluttertoast.showToast(
                                                        //
                                                        //     msg: "Service will available very soon!!!",
                                                        //     toastLength: Toast.LENGTH_LONG,
                                                        //     gravity: ToastGravity.BOTTOM,
                                                        //     timeInSecForIosWeb: 1,
                                                        //     backgroundColor: Colors.black54,
                                                        //     textColor: Colors.white,
                                                        //     fontSize: 16.0);
                                                      },
                                                      child: Container(
                                                        width: width / 2,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              Color(0xffD8F2D8),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Icon(
                                                                Icons.class_,
                                                                color: Color(
                                                                    0xff0E6B50),
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  snapshot.data[
                                                                          index]
                                                                      ['name'],
                                                                  style:
                                                                      GoogleFonts
                                                                          .lato(
                                                                    color: Color(
                                                                        0xff0E6B50),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          )
                                        : Text('No data');
                                  }
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
