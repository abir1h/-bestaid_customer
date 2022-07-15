import 'dart:convert';

import 'package:avatar_letter/avatar_letter.dart';
import 'package:best_aid_customer/Screens/Doctor_list/docotors.dart';
import 'package:best_aid_customer/Screens/url/App_url.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../../MainHome.dart';

class view_all_medical extends StatefulWidget {
  @override
  _view_all_medicalState createState() => _view_all_medicalState();
}

class _view_all_medicalState extends State<view_all_medical> {
  Future myfuture;
  Future<List<dynamic>> getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/api/customer/show/medical";
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

  Future logoutApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    return await http.post(
      Uri.parse(AppUrl.logout),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'authorization': "Bearer $token",
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture = getpost();
    getdata();
  }

  var name, phone, profile_image;
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



  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MainHome()));
        return false;
      },
      child: SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => MainHome()));
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
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text("Hospitals",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
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
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.2,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (_, index) {
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    onTap:(){
                                                      Navigator.push(context, MaterialPageRoute(builder: (_)=>doctors(id: snapshot.data[index]['id'].toString(),)));

                                                    },
                                                    leading: AvatarLetter(
                                                      size: 50,
                                                      backgroundColor:
                                                          Color(0xff0E6B50),
                                                      textColor: Colors.white,
                                                      fontSize: 20,
                                                      upperCase: true,
                                                      numberLetters: 1,
                                                      letterType:
                                                          LetterType.Circular,
                                                      text: snapshot.data[index]
                                                          ['name'],
                                                    ),
                                                    title: Shimmer.fromColors(
                                                      highlightColor: Color(0xffED2D43),
                                                      baseColor: Colors.black,
                                                      child: Text(
                                                          snapshot.data[index]
                                                              ['name'],
                                                          style: GoogleFonts.lato(
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 20)),
                                                    ),
                                                    trailing:  Container(
                                                        width: width/5,
                                                        height:height/23,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Colors.white,

                                                            border: Border.all(color:  Color(0xff0E6B50),width: 1)
                                                        ),

                                                        child: Center(
                                                          child: Text(
                                                            "View",
                                                            style: TextStyle(
                                                              color:  Color(0xff0E6B50),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                  Divider(color: Colors.grey[200],thickness: 10,),

                                                ],
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
        )),
      ),
    );
  }
}
