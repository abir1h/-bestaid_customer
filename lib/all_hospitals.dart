import 'dart:async';
import 'dart:convert';

import 'package:best_aid_customer/Screens/hospital_dhr.dart';
import 'package:best_aid_customer/Screens/url/App_url.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
class all_hospitals extends StatefulWidget {
  @override
  _all_hospitalsState createState() => _all_hospitalsState();
}

class _all_hospitalsState extends State<all_hospitals> {
  TextEditingController _controller=TextEditingController();
  StreamController _streamController;
  Stream _stream;

  Timer _debounce;
  List images=[
    'Images/i3.jpg'
        'Images/i3.jpg'
        'Images/i3.jpg'
        'Images/i3.jpg'
  ];
  Future<List<dynamic>> emergency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/api/customer/show/gp/doctor";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse('https://bestaid.codebuzzbd.com/api/customer/dhr/show/all/hospital'), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Map<String, String> requestHeaders = {'authorization': "Bearer $token"};

    String controller = _controller.text.trim();
    _streamController.add("waiting");
    Response response =
    await get(Uri.parse("https://bestaid.com.bd/api/customer/search/result/gp/0/" + controller), headers: requestHeaders);
    _streamController.add(json.decode(response.body)['data']);
  }
  Future myfuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture=emergency();
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xff0E6B50),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
           Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("Hospital",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:20.0,right: 20,top: 10),
              child: Container(
                height: height/15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  controller: _controller,
                  onChanged: (String text) {
                    if (_debounce?.isActive ?? false) _debounce.cancel();
                    _debounce = Timer(const Duration(milliseconds: 1000), () {
                      // _search();
                    });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,color: Colors.grey,),
                      border:InputBorder.none,
                      hintText: "Search by doctor's name,code/speciality",
                      hintStyle: GoogleFonts.lato(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 14
                      )

                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height/5.5,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  scrollPhysics: AlwaysScrollableScrollPhysics(),
                  height: 200,
                  autoPlay: true,
                  reverse: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                ),
                itemCount: 10,
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Container(
                        height: height/5,
                        width: width/1,
                        child: InkWell(

                            onTap: ()async{
                              // var url=snapshot.data[itemIndex]['links'];
                              // if (await canLaunch(url))
                              //   await launch(url);
                              // else
                              //   // can't launch url, there is some error
                              //   throw "Could not launch $url";
                            },
                            child: Image.network('https://static.vecteezy.com/system/resources/thumbnails/003/422/690/small/hospital-medicine-horizontal-banner-vector.jpg',fit: BoxFit.cover,))
                    ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20,top: 10),
            //   child:   Container(
            //
            //     height: height/7,
            //
            //     child:   ListView.builder(
            //
            //         shrinkWrap: true,
            //
            //         itemCount: 5,
            //
            //         scrollDirection: Axis.horizontal,
            //
            //         itemBuilder: (_,index){
            //           // var imagelink=snapshot.data[index]['profile_image']!=null?snapshot.data[index]['profile_image']:'link';
            //
            //           return
            //             // snapshot.data[index]['type']=='specialist'?
            //           Row(
            //             children: [
            //               InkWell(
            //                 onTap:(){
            //                   // Navigator.push(context, MaterialPageRoute(builder: (_)=>doctor_profile(id: snapshot.data[index]['id'].toString(),)));
            //
            //                 },
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Container(
            //
            //                     alignment: Alignment.center,
            //
            //                     height: MediaQuery.of(context).size.height/5,
            //
            //                     width: MediaQuery.of(context).size.width/1.1,
            //
            //                     decoration: BoxDecoration(
            //
            //
            //                       borderRadius: BorderRadius.circular(20), color:Colors.white
            //                       ,
            //
            //                       boxShadow: [
            //                         BoxShadow(
            //                           color: Colors.grey
            //                               .withOpacity(
            //                               0.2),
            //
            //                           spreadRadius: 2,
            //
            //                           blurRadius: 4,
            //
            //                           offset: Offset(2,
            //                               1), // changes position of shadow
            //                         )
            //                       ],
            //                       image:DecorationImage(
            //                         image: NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/003/422/690/small/hospital-medicine-horizontal-banner-vector.jpg'),
            //                         fit: BoxFit.cover
            //
            //                       )
            //                     ),
            //
            //                     // child:  Padding(
            //                     //
            //                     //     padding: const EdgeInsets.only(left:8.0),
            //                     //
            //                     //     child:Row(
            //                     //
            //                     //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     //
            //                     //       children: [
            //                     //         Padding(
            //                     //           padding: const EdgeInsets.all(8.0),
            //                     //           child: Container(
            //                     //             height: MediaQuery.of(context).size.height/12,
            //                     //             width: MediaQuery.of(context).size.width/8,
            //                     //             decoration: BoxDecoration(
            //                     //                 borderRadius: BorderRadius.circular(5),
            //                     //                 image: DecorationImage(
            //                     //                     image:  NetworkImage(AppUrl.pic_url1+imagelink),
            //                     //                     fit: BoxFit.cover
            //                     //
            //                     //                 )
            //                     //             ),
            //                     //           ),
            //                     //         ),
            //                     //         Flexible(
            //                     //           child: Column(
            //                     //             crossAxisAlignment: CrossAxisAlignment.start,
            //                     //             mainAxisAlignment: MainAxisAlignment.center,
            //                     //             children: [
            //                     //
            //                     //               Text(snapshot.data[index]['name'],style:GoogleFonts.lato(
            //                     //
            //                     //                   color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18
            //                     //               )),
            //                     //
            //                     //               Text(snapshot.data[index]['degree_obtained'],style:GoogleFonts.lato(
            //                     //
            //                     //                   color:Colors.grey,fontWeight: FontWeight.w600,fontSize: 12
            //                     //               )),
            //                     //
            //                     //
            //                     //
            //                     //             ],
            //                     //
            //                     //           ),
            //                     //         ),
            //                     //         Container(
            //                     //           margin: EdgeInsets.only(right: 15),
            //                     //           height: 30,
            //                     //           width: 30,
            //                     //           decoration: BoxDecoration(
            //                     //               color: Color(0xff0E6B50),
            //                     //
            //                     //               borderRadius: BorderRadius.circular(5)
            //                     //           ),
            //                     //           child: Icon(Icons.arrow_forward,color: Colors.white,),
            //                     //         ),
            //                     //
            //                     //
            //                     //
            //                     //
            //                     //       ],
            //                     //
            //                     //     )
            //                     //
            //                     // ),
            //
            //
            //
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(width: 10,)
            //             ],
            //           );
            //           // :Container();
            //
            //         }),
            //
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: height/1,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left:15.0,right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("All Hospital's",style:GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700
                                ),),
                              ),
                              // InkWell(
                              //   onTap: (){
                              //     Navigator.push(context, MaterialPageRoute(builder: (_)=>all_hospitals()));
                              //
                              //   },
                              //   child: Text("View All",style: GoogleFonts.lato(
                              //       color: Color(0xff0E6B50),
                              //       fontWeight: FontWeight.w900,
                              //       fontSize: 14
                              //   )),
                              // )
                            ],
                          ),
                        )),

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

                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      child: ListView.builder(
                                        itemBuilder: (_, __) => Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: 48.0,
                                                height: 48.0,
                                                color: Colors.white,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      width: double.infinity,
                                                      height: 8.0,
                                                      color: Colors.white,
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: 8.0,
                                                      color: Colors.white,
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 2.0),
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
                                        ?              Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height/1.4,
                                        child: GridView.builder(
                                            physics: AlwaysScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 200,
                                                childAspectRatio: 4/4,
                                                crossAxisSpacing: 5,
                                                mainAxisSpacing: 5),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (BuildContext ctx, index) {
                                              return InkWell(

                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>hospital_dhr(id: snapshot.data[index]['id'],)));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(

                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.1),
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset: Offset(0, 3), // changes position of shadow
                                                          ),
                                                        ],
                                                        color: Colors.white

                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(height:                                       height/15,
                                                        ),
                                                        CachedNetworkImage(
                                                          // imageUrl:AppUrl.pic_url1+snapshot.data[index]['image'],fit: BoxFit.cover ,
                                                            imageUrl:'https://seeklogo.com/images/M/medical-hospital-logo-463FA27180-seeklogo.com.png',fit: BoxFit.cover ,
                                                            height: 60,width: 60,
                                                            placeholder: (context, url) => CircularProgressIndicator(),
                                                            errorWidget: (context, url, error) => Icon(Icons.source,color: Color(0xff00D2CD),)
                                                        ),
                                                        // SizedBox(height:                                       height/40,
                                                        // ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Flexible(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Text(
                                                                  // snapshot.data[index]['name'],style: GoogleFonts.lato(
                                                                    snapshot.data[index]['medical']['name'],style: GoogleFonts.lato(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 14
                                                                )
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
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

                  ],
                ),
              ),
            )
          ],
        ),
      ),

    )

    );

  }
}
