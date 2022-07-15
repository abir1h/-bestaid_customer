import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:best_aid_customer/bottom_nav_widgets/offers.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';



import 'package:avatar_letter/avatar_letter.dart';
import'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../MainHome.dart';
class medicine {
  final String days;
  final String medicine_name;
  final String eats_time;
  final String days_units;


  medicine({
    this.days,
    this.medicine_name,
    this.eats_time,
    this.days_units,
 
  });

  factory medicine.fromJson(Map<String, dynamic> json) {
    return medicine(
      days: json['days'],
      medicine_name: json['medicine_name'],
      eats_time: json['eats_time'],
      days_units: json['days_units'],


    );
  }
}

class pres extends StatefulWidget {
  final String id;
  const pres({Key key,this.id}) : super(key: key);
  @override
  _presState createState() => _presState();
}

class _presState extends State<pres> {
  bool has_medicine=false;

  Future myfuture,prescriptionf;

  bool get_prescription=false;
  var pres_id;
  Future getprescription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var id=widget.id;

    String url = "https://bestaid.com.bd/api/store/show/prescription/$id";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {

      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body)['data'];
      var userData2 = jsonDecode(response.body)['message'];
      print(userData2);

      if( userData2!='Prescription Uploaded Soon ... Please Wait!'){
        setState(() {
          get_prescription=true;
          pres_id=userData1['id'];
        });
      }else{
        setState(() {
          get_prescription=false;
        });
      }
      return userData1;
    } else {
      setState(() {
        get_prescription=false;
      });
      print("post have no Data${response.body}");
    }
  }
  List jsonResponse;
  Future<List<medicine>> fetchMEdicine() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');


    var id=widget.id;

    String url = "https://bestaid.com.bd/api/store/show/prescription/$id";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {
      setState(() {
        has_medicine=true;
      });
      var parsed = json.decode(response.body)['data'];
      var message = json.decode(response.body)['message'];
      // print(parsed.length);
print(message);
      if( message!='Prescription Uploaded Soon ... Please Wait!'){
        setState(() {
          has_medicine=true;
        });
        jsonResponse = parsed['medicine']as List;
        print("This is reponse "+jsonResponse.toString());

        print(jsonResponse);
        return jsonResponse.map((job) => new medicine.fromJson(job)).toList();

      }else{
        setState(() {
          has_medicine=false;
        });
      }



    } else {
      setState(() {
        has_medicine=false;
      });
      print("Get Profile No Data${response.body}");
    }
  }
  Future downloadpdf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/prescription/2";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {

      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body);
      print(userData1);
      return userData1;
    } else {

      print("post have no Data${response.body}");
    }

  }
  Future<List<medicine>> _func;

  Uint8List _imageFile;

  //Create an instance of ScreenshotController


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture=getprescription();
    prescriptionf=fetchMEdicine();
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: get_prescription==true?Align(

        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(

          backgroundColor: Color(0xff0E6B50),
          onPressed: () async{
            var id=widget.id;
            var url='https://bestaid.com.bd/prescription/$pres_id';
            print(pres_id);
            if(await canLaunch(url)){
            await launch(url);
            Fluttertoast.showToast(

            msg: "Please check in your Browser Download section in Chrome browser",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 4,
            backgroundColor: Color(0xff0E6B50),
            textColor: Colors.white,
            fontSize: 16.0,


            );
            }throw 'Could not launch $url';
          },
          icon: Icon(Icons.download_rounded,color: Colors.white,),
          label: Text("Download ",style: GoogleFonts.lato(
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
                                  ?      get_prescription==true?                         Padding(
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
                                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Appointments()));

                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
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
                                                Text("Digital Prescription",style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18
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
                                        ),                                        Padding(
                                          padding: const EdgeInsets.only(left:18.0),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(snapshot.data['doctor']['name'],style: GoogleFonts.lato(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 18
                                                        )), Text(snapshot.data['doctor']['degree_obtained'],style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),  Text("Cardiology",style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),                                                  ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text("Best",style: GoogleFonts.lato(
                                                                color: Color(0xff0E6B50),
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 18
                                                            )),Text("Aid",style: GoogleFonts.lato(
                                                                color: Colors.redAccent,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 18
                                                            )),
                                                          ],
                                                        ), Text("Khulna,mohsin road",style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),  Text("Emergency Number : +01234513",style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),                                                  ],
                                                    ),
                                                  ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height/45,),
                                        Padding(
                                          padding: const EdgeInsets.only(left:18.0,right: 25),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text("Patient Name",style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),
                                                        SizedBox(width: 10,),
                                                        Text(snapshot.data['patient']['name'],style: GoogleFonts.lato(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),
                                                      ],
                                                    ),
                                                  ),

                                                  ],
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text("Age",style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),
                                                        SizedBox(width: 10,),
                                                        Text(snapshot.data['patient']['age']!=null?snapshot.data['patient']['age']:' ',style: GoogleFonts.lato(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Text("Gender",style: GoogleFonts.lato(
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 14
                                                          )),
                                                          SizedBox(width: 10,),
                                                          Text(snapshot.data['patient']['gender'],style: GoogleFonts.lato(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 14
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text("Weight",style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),
                                                        SizedBox(width: 10,),
                                                        Text(snapshot.data['patient']['weight']+" KG ",style: GoogleFonts.lato(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),
                                                      ],
                                                    ),
                                                  ),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ) ,SizedBox(height: height/45,),
                                        Padding(
                                          padding: const EdgeInsets.only(left:18.0,right: 25),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text("Reason For Visit",style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),
                                                        SizedBox(width: 10,),
                                                        Flexible(
                                                          child: Text(snapshot.data['given_problem'],style: GoogleFonts.lato(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 14
                                                          )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  ],
                                                ),
                                                SizedBox(height: height/45,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text("Investigation: ",style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),
                                                        SizedBox(width: 10,),
                                                        Text(snapshot.data['investigation'],style: GoogleFonts.lato(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14
                                                        )),
                                                      ],
                                                    ),
                                                  ),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: height/30,),

                                        Padding(
                                          padding: const EdgeInsets.only(left:18.0,right: 25),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text("PX",style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 18
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                       has_medicine==true? FutureBuilder<List<medicine>>(
                                          future:    prescriptionf
                                          ,
                                          builder: (ctx, snapshot) {
                                            if (snapshot.hasData) {
                                              print(snapshot.data);
                                              List<medicine> data = snapshot.data;
                                              print(data);
                                              // print(data);
                                              return SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[


                                                    Padding(
                                                      padding: EdgeInsets.only(top:10.0
                                                      ),
                                                      child: Center(
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Column(
                                                            children: [
                                                              DataTable(
                                                                dataRowHeight: 20,
                                                                columnSpacing: 15.0,

                                                                headingRowColor:
                                                                MaterialStateColor.resolveWith((states) => Colors.grey),                                     sortColumnIndex: 0,
                                                                sortAscending: true,
                                                                columns: [

                                                                  DataColumn(
                                                                    label: Text(
                                                                      'Medicine Name',
                                                                      style: TextStyle(fontWeight: FontWeight.w900),
                                                                    ),
                                                                  ), DataColumn(
                                                                    label: Text(
                                                                      'Day Units',
                                                                      style: TextStyle(fontWeight: FontWeight.w900),
                                                                    ),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text(
                                                                      'Days',
                                                                      style: TextStyle(fontWeight: FontWeight.w900),
                                                                    ),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text(
                                                                      'When Eats',
                                                                      style: TextStyle(fontWeight: FontWeight.w900),
                                                                    ),
                                                                  ),



                                                                ],
                                                                rows: data
                                                                    .map(
                                                                      (country) => DataRow(
                                                                    cells: [

                                                                      DataCell(
                                                                        Container(
                                                                          width: 60.0,
                                                                          child: Center(
                                                                            child: Text(
                                                                              country.medicine_name,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Center(
                                                                          child: Text(
                                                                            country.days_units,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.normal),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Center(
                                                                          child: Text(
                                                                            country.days,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.normal),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      DataCell(
                                                                        Center(
                                                                          child: Text(
                                                                            country.eats_time,
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.normal),
                                                                          ),
                                                                        ),
                                                                      ),


                                                                    ],
                                                                  ),
                                                                )
                                                                    .toList(),
                                                              ),
                                                              Divider(
                                                                color: Colors.indigoAccent,
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // SizedBox(height: 500),
                                                  ],
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return AlertDialog(
                                                title: Text(
                                                  'An Error Occured!',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                                content: Text(
                                                  "${snapshot.error}",
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text(
                                                      'Go Back',
                                                      style: TextStyle(
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  )
                                                ],
                                              );
                                            }
                                            // By default, show a loading spinner.
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: 20),
                                                  Text('This may take some time..')
                                                ],
                                              ),
                                            );
                                          },
                                        ):Container(),

                                        Padding(
                                          padding: const EdgeInsets.only(left:18.0,right: 25),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    children: [
                                                      Text("Diagnostic : ",style: GoogleFonts.lato(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14
                                                      )), Text(snapshot.data['diagnostic'],style: GoogleFonts.lato(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14
                                                      )),
                                                      SizedBox(height: height/30,),

                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),  Padding(
                                          padding: const EdgeInsets.only(left:18.0,right: 25),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    children: [
                                                      Text("Advice : ",style: GoogleFonts.lato(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14
                                                      )), Text(snapshot.data['advice'],style: GoogleFonts.lato(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14
                                                      )),
                                                      SizedBox(height: height/30,),

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
                              ):Center(child: Column(
                                children: [
                                  Image.asset('images/no.gif'),
                                  Text("Prescription Uploaded Soon !!",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.indigoAccent,fontSize: 20),),
                                  ElevatedButton.icon(onPressed: (){

                                    Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));
                                  }, icon: Icon(Icons.arrow_back), label: Text("Go Back"))
                                ],
                              ))



                                  : Center(child: Column(
                                children: [
                                  Image.asset('images/no.gif'),
                                  Text("Prescription Uploaded Soon !!",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.indigoAccent,fontSize: 20),),
                                  ElevatedButton.icon(onPressed: (){

                                    Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));
                                  }, icon: Icon(Icons.arrow_back), label: Text("Go Back"))
                                ],
                              ));
                            }
                        }
                        return Center(child: Column(
                          children: [
                            Image.asset('images/no.gif'),
                            Text("No Prescription Has been Given",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.indigoAccent,fontSize: 20),),
                          ],
                        ));
                      }))

            ],
          )
      ),

    ));
  }


}
