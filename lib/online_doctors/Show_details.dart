import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avatar_letter/avatar_letter.dart';
import 'package:best_aid_customer/Screens/loaders/emergancy_doctor.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../MainHome.dart';
class show_details extends StatefulWidget {
final String id,type;
 const show_details({Key key,this.id,this.type}) : super(key: key);
  @override
  _show_detailsState createState() => _show_detailsState();
}

class _show_detailsState extends State<show_details> {
  Future myfuture,prescription;
  var doctor_in_call;
  bool get_prescription=false;
  var patient_id;
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
  var id=widget.id;

    String url = "https://bestaid.com.bd/api/customer/show/appointment/$id";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1['patients']['created_at']);
      print(userData1['patients']['doctor_in_call']);
      setState(() {
        doctor_in_call=userData1['patients']['doctor_in_call'];
        patient_id=userData1['patients']['id'];
      });

      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }
  Timer notification_timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture=getpost();
    notification_timer=Timer.periodic(Duration(seconds: 10), (_) => getpost());

  }
  @override
  void dispose() {
    // TODO: implement dispose
    notification_timer.cancel();


    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      floatingActionButton:

      widget.type=='s'?
      Align(

        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(

          backgroundColor: Color(0xff0E6B50),
          onPressed: () {
doctor_in_call=='0'?            Fluttertoast.showToast(

    msg: "Doctor is not online",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 3,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0):Navigator.push(context, MaterialPageRoute(builder: (_)=>emergency_doctor_loader(patient_id: patient_id.toString(),)));
          },
          icon: Icon(Icons.video_call_rounded,color: Colors.white,),
          label: Text("Start a Call",style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18
          )),

        ),
      ):Container(),
      body: SingleChildScrollView(
        child:Column(
          children: [
            Container(
                constraints: BoxConstraints(),
                child: FutureBuilder(
                    future: myfuture,
                    builder: (_, AsyncSnapshot snapshot) {
                     print("tis data");

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
                                ?                                    Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: height/1,
                                child: SingleChildScrollView(
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
                                          Column(
                                            children: [
                                              Text("Consultation History",style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18
                                              )),Text(DateFormat.yMd().add_jm().format(DateTime.parse(snapshot.data['patients']['created_at'].toString())),style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14
                                              )),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right:8.0),
                                            child: AvatarLetter(
                                              size: 25,
                                              backgroundColor: Colors.transparent,
                                              textColor: Colors.white,
                                              fontSize: 20,
                                              upperCase: true,
                                              numberLetters: 2,
                                              letterType: LetterType.Circular,
                                              text: 'Partho',
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height/30,),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child:   Container(

                                          child: Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Text("Patient Information ",style: GoogleFonts.lato(

                                                  color: Colors.black,

                                                  fontWeight: FontWeight.w400,

                                                  fontSize: 18

                                              )),
                                              Divider(color: Colors.black,),Row(

                                                children: [

                                                  Text("Patient Name : ",style: GoogleFonts.lato(

                                                      color: Colors.grey,

                                                      fontWeight: FontWeight.w500,

                                                      fontSize: 14

                                                  )), Text(snapshot.data['patients']['name'],style: GoogleFonts.lato(

                                                      color: Colors.black,

                                                      fontWeight: FontWeight.w700,

                                                      fontSize: 14

                                                  )),

                                                ],

                                              ),
                                              SizedBox(height: MediaQuery.of(context).size.height/50,), Row(

                                                children: [

                                                  Text("Patient ID : ",style: GoogleFonts.lato(

                                                      color: Colors.grey,

                                                      fontWeight: FontWeight.w500,

                                                      fontSize: 14

                                                  )), Text(snapshot.data['patients']['patient_id'],style: GoogleFonts.lato(

                                                      color: Colors.black,

                                                      fontWeight: FontWeight.w700,

                                                      fontSize: 14

                                                  )),

                                                ],

                                              ),
                                              SizedBox(height: MediaQuery.of(context).size.height/50,),
                                              SizedBox(height: MediaQuery.of(context).size.height/50,),
                                              Divider(color: Colors.grey[200],thickness: 10,),
                                              SizedBox(height: MediaQuery.of(context).size.height/20,),

                                              Text("Main Reason ",style: GoogleFonts.lato(

                                                  color:Color(0xff0E6B50),

                                                  fontWeight: FontWeight.w800,

                                                  fontSize: 20

                                              )),         SizedBox(height: MediaQuery.of(context).size.height/50,),
                                              Text(snapshot.data['patients']['reason_for_visit'],style: GoogleFonts.lato(

                                                  color: Colors.black,

                                                  fontWeight: FontWeight.w700,

                                                  fontSize: 14

                                              )),        SizedBox(height: MediaQuery.of(context).size.height/20,),
                                              Text("Problems ",style: GoogleFonts.lato(

                                                  color:Color(0xff0E6B50),

                                                  fontWeight: FontWeight.w800,

                                                  fontSize: 20

                                              )),
                                              SizedBox(height: MediaQuery.of(context).size.height/50,),
                                              Text(snapshot.data['patients']['problem'],style: GoogleFonts.lato(

                                                  color: Colors.black,

                                                  fontWeight: FontWeight.w700,

                                                  fontSize: 14

                                              )),


                                            ],),

                                        ),
                                      ),



                                    ],
                                  ),
                                ),
                              ),
                            )



                                : Text('No data');
                          }
                      }
                      return CircularProgressIndicator();
                    })),

          ],
        )
      ),
    ));
  }
}
