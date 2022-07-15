import 'dart:async';
import 'dart:convert';

import 'package:best_aid_customer/online_doctors/vedio_call.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
class emergency_doctor_loader extends StatefulWidget {
  final String patient_id;
  const emergency_doctor_loader({Key key,this.patient_id}) : super(key: key);
  @override
  _emergency_doctor_loaderState createState() => _emergency_doctor_loaderState();
}

class _emergency_doctor_loaderState extends State<emergency_doctor_loader> {
  Future myfuture;
  var link;
  Future getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var id=widget.patient_id;

    String url = "https://bestaid.com.bd/api/customer/show/video/doctor/$id";
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    if (response.statusCode == 200) {

      print('Get post collected' + response.body);
      var userData1 = jsonDecode(response.body);
      print(userData1);
      print(userData1['message']);
      if(userData1['message']=='Medical Show SuccessFully!'){
        setState(() {
          isloaded=false;
          link=userData1['data'];
        });
      }
      return userData1;
    } else {
      print("post have no Data${response.body}");
    }
  }  Timer notification_timer;

  bool isloaded=true;
  @override
  void dispose() {
    // TODO: implement dispose
    notification_timer.cancel();


    super.dispose();

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture= getpost();
    notification_timer=Timer.periodic(Duration(seconds: 10), (_) => getpost());

    print(widget.patient_id);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: Scaffold(
        body:isloaded==true? Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height: MediaQuery.of(context).size.height/3.5,),
            Center(child: Align(alignment:Alignment.center,child: Column(
              children: [
                SpinKitWave(
                  color: Colors.green,
                  size: 30,
                ),          SizedBox(height: MediaQuery.of(context).size.height/15,),

                Text("Please wait for doctor responseu",style: GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16
                ))
              ],
            ))),

          ],
        ):Container(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/10,),
              Image.asset('images/f.gif'),
              SizedBox(height: MediaQuery.of(context).size.height/10,),

              Text("Your meeting with doctor has been arranged,",
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16)),
              SizedBox(height: 10,),
              Text("Click Below To Join The Meeting!!",
                  style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              Icon(Icons.arrow_circle_down,color: Colors.blue,size: 20,),
              Center(child: ElevatedButton(onPressed: (){
                print(link);
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Meeting(roomid: link,)));


              }, child: Text('Click here to join!'))),
            ],
          ),
        ),
      ),
    );
  }
}
