import 'dart:convert';
import 'dart:math';

import 'package:best_aid_customer/Screens/open_image.dart';
import 'package:best_aid_customer/Screens/url/App_url.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class view_report extends StatefulWidget {
  final String id_;
  view_report({this.id_});

  @override
  _view_reportState createState() => _view_reportState();
}

class _view_reportState extends State<view_report> {
  Future myfuture;
  Future<List<dynamic>> getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var id = widget.id_;
    String url =
        "https://bestaid.codebuzzbd.com/api/customer/dhr/image/show/$id";
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture = getpost();
  }

  TextEditingController tr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0E6B50),
        elevation: 0,
      ),
      backgroundColor: Color(0xff0E6B50),
      body: ShowUpAnimation(
        delayStart: Duration(milliseconds: 50),
        animationDuration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
        direction: Direction.vertical,
        offset: .5,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [

                  Text(
                    'My Reports',
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 28),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  Container(
                    // Here the height of the container is 45% of our total height
                    height: MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
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
                                          Center(
                                              child: SpinKitThreeInOut(
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
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        snapshot.data.length,
                                                    itemBuilder: (c, i) {
                                                      return InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      open_image(
                                                                        info: 'https://bestaidtest1.s3.ap-southeast-1.amazonaws.com/' +
                                                                            snapshot.data[i]['dhr_image'],
                                                                      )));
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              5,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: NetworkImage(
                                                                      'https://bestaidtest1.s3.ap-southeast-1.amazonaws.com/' +
                                                                          snapshot.data[i]
                                                                              [
                                                                              'dhr_image']))),
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : Text('No data');
                                      }
                                  }
                                  return CircularProgressIndicator();
                                })),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Reports',
                              style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20),
                            ),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Divider(
                            color: Colors.grey[200],
                            thickness: 10,
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
                                          Center(
                                              child: SpinKitThreeInOut(
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
                                            ? Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.6,
                                                child: ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        snapshot.data.length,
                                                    itemBuilder: (c, i) {
                                                      var dateTime = DateTime
                                                          .parse(snapshot
                                                                  .data[i]
                                                              ['created_at']);

                                                      return Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  10,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              decoration: BoxDecoration(
                                                                  color: Color(Random()
                                                                          .nextInt(
                                                                              0x3fffffff))
                                                                      .withOpacity(
                                                                          0.9),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child: ListTile(
                                                                isThreeLine:
                                                                    true,
                                                                leading:
                                                                    CachedNetworkImage(
                                                                        imageUrl: AppUrl.pic_url2 +
                                                                            snapshot.data[i][
                                                                                'dhr_image'],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                CircularProgressIndicator(),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Icon(
                                                                              Icons.source,
                                                                              color: Color(0xff00D2CD),
                                                                            )),
                                                                title: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        snapshot.data[i]['dhr_image_title'] !=
                                                                                null
                                                                            ? snapshot.data[i]['dhr_image_title']
                                                                            : "No Title",
                                                                        style: GoogleFonts.lato(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 18),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                subtitle:
                                                                    Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Uploaded on ' +
                                                                          DateFormat.yMMMMd('en_US')
                                                                              .format(dateTime),
                                                                      style: GoogleFonts.lato(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ],
                                                                ),
                                                                trailing:
                                                                    PopupMenuButton(
                                                                        onSelected:
                                                                            (value) async {
                                                                          print(
                                                                              value);
                                                                          if (value ==
                                                                              1) {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: Text(
                                                                                    'Rename Report',
                                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  content: TextField(
                                                                                    controller: tr,
                                                                                    decoration: InputDecoration(
                                                                                        hintText: "Rename Report",
                                                                                        border: OutlineInputBorder(),
                                                                                        prefixIcon: Icon(
                                                                                          Icons.edit,
                                                                                          color: Colors.blue,
                                                                                        )),
                                                                                  ),
                                                                                  actions: [
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                        String token = prefs.getString('token');
                                                                                        Map<String, String> requestHeaders = {
                                                                                          'Accept': 'application/json',
                                                                                          'authorization': "Bearer $token"
                                                                                        };
                                                                                        var request = await http.MultipartRequest(
                                                                                          'POST',
                                                                                          Uri.parse(AppUrl.rename+snapshot.data[i]['id'].toString()),
                                                                                        );
                                                                                        request.fields.addAll({
                                                                                          'dhr_image_title': tr.text
                                                                                        });

                                                                                        request.headers.addAll(requestHeaders);

                                                                                        request.send().then((result) async {
                                                                                          http.Response.fromStream(result).then((response) {
                                                                                            if (response.statusCode == 200) {
                                                                                              var data = jsonDecode(response.body);

                                                                                              Fluttertoast.showToast(msg: "Updated Successfully", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
                                                                                              setState(() {
                                                                                                myfuture = getpost();
                                                                                              });
                                                                                              Navigator.pop(context);
                                                                                            } else {
                                                                                              print(response.body);
                                                                                              Navigator.pop(context);


                                                                                              print("Fail! ");
                                                                                              Fluttertoast.showToast(msg: "Error Occurred", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                                                                              return response.body;
                                                                                            }
                                                                                          });
                                                                                        });
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(
                                                                                            'Submit',
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(
                                                                                            'Close',
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );
                                                                          } else if (value ==
                                                                              2) {
                                                                            // showDialog(
                                                                            //     context: context,
                                                                            //     builder: (context) {
                                                                            //       return password_popup();
                                                                            //     });
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: Text(
                                                                                    'Delete Report',
                                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  content: Text(
                                                                                    'Are you Sure You want to Delete this report!',
                                                                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                                                                                  ),
                                                                                  actions: [
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                        String token = prefs.getString('token');
                                                                                        Map<String, String> requestHeaders = {
                                                                                          'Accept': 'application/json',
                                                                                          'authorization': "Bearer $token"
                                                                                        };
                                                                                        var request = await http.MultipartRequest(
                                                                                          'POST',
                                                                                          Uri.parse(AppUrl.delete+snapshot.data[i]['id'].toString()),
                                                                                        );


                                                                                        request.headers.addAll(requestHeaders);

                                                                                        request.send().then((result) async {
                                                                                          http.Response.fromStream(result).then((response) {
                                                                                            if (response.statusCode == 200) {
                                                                                              var data = jsonDecode(response.body);

                                                                                              Fluttertoast.showToast(msg: "Deleted Successfully", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
                                                                                              setState(() {
                                                                                                myfuture = getpost();
                                                                                              });
                                                                                              Navigator.pop(context);
                                                                                            } else {
                                                                                              print(response.body);
                                                                                              Navigator.pop(context);


                                                                                              print("Fail! ");
                                                                                              Fluttertoast.showToast(msg: "Error Occurred", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                                                                              return response.body;
                                                                                            }
                                                                                          });
                                                                                        });
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(
                                                                                            'Delete',
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(
                                                                                            'Close',
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );

                                                                          } else if (value ==
                                                                              3) {
                                                                            var url=AppUrl.pic_url2 +
                                                                                snapshot.data[i][
                                                                                'dhr_image'];
                                                                            Share.share('check out my website $url',
                                                                                subject: 'Look what I made!');
                                                                          }
                                                                        },
                                                                        itemBuilder:
                                                                            (context) =>
                                                                                [
                                                                                  PopupMenuItem(
                                                                                    child: Text("Edit", style: GoogleFonts.lato(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal)),
                                                                                    value: 1,
                                                                                  ),
                                                                                  PopupMenuItem(
                                                                                    child: Text("Delete", style: GoogleFonts.lato(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal)),
                                                                                    value: 2,
                                                                                  ),
                                                                                  PopupMenuItem(
                                                                                    child: Text("Share", style: GoogleFonts.lato(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal)),
                                                                                    value: 3,
                                                                                  ),
                                                                                ]),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          )
                                                        ],
                                                      );
                                                    }),
                                              )
                                            : Text('No data');
                                      }
                                  }
                                  return CircularProgressIndicator();
                                })),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
