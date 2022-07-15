
import 'package:best_aid_customer/Screens/url/App_url.dart';
import'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:http/http.dart'as http;

import '../MainHome.dart';
import '../login_screen.dart';
import '../passchange_popup.dart';
class menu extends StatefulWidget {
  @override
  _menuState createState() => _menuState();
}

class _menuState extends State<menu> {
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
  } var name,phone,profile_image;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.push(context, MaterialPageRoute(builder: (_)=>MainHome()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.transparent,),onPressed: (){

          },),
          backgroundColor:  Color(0xff0E6B50),

          title: Text("Menu",style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20
          )),
        ),
        body: Column(
          children: [
            ListTile(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (context) {
                      return password_popup();
                    });
              },
              leading: Icon(Icons.vpn_key,color: Color(0xff0E6B50)),
              title: Text("Change Password",style: GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              )
              ),
            ),
            ListTile(
              onTap: ()async{
                logoutApi();
                SharedPreferences preferences = await SharedPreferences. getInstance(); await preferences. clear();
                Navigator.push(context, MaterialPageRoute(builder: (_)=>login_screen()));
              },
              leading: Icon(Icons.logout,color: Color(0xff0E6B50)),
              title: Text("Log Out",style: GoogleFonts.lato(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18
              )
              ),
            )
          ],
        ),
      ),
    );
  }
}
