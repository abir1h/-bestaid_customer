import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:http/http.dart'as http;

import 'Screens/url/App_url.dart';
import 'login_screen.dart';
class password_popup extends StatefulWidget {

  @override
  _password_popupState createState() => _password_popupState();
}

class _password_popupState extends State<password_popup> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  Future logoutApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    return await http.post(
      Uri.parse(AppUrl.change_pass),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'authorization': "Bearer $token",
      },
    );
  }
  final _formKey = GlobalKey<FormState>();
  bool issave=false;
  TextEditingController email_ = TextEditingController();
  TextEditingController password_ = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor:Color(0xff0E6B50),
      child: Wrap(
        children: [
          contentBox(context),
        ],
      ),
    );

  }

  contentBox(context){
    String _chosenValue;
    return
      Center(
        child: Container(
          margin: EdgeInsets.only(top:20,bottom: 30),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: IconButton(icon: Icon(Icons.close,color: Colors.white,), onPressed: (){
                    Navigator.pop(context);
                  })),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                    padding: const EdgeInsets.only(left:28.0,right: 28),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          TextFormField(

                            validator: (val)=>val.isEmpty?"Field can not be empty":null,
                            controller: email_,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontSize: 20
                            ),

                            decoration: InputDecoration(
                              hintStyle:  GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18
                            ),
                              hintText: "Old Password",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white
                                    )
                                ),
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.white,
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:28.0,right: 28),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            TextFormField(

                              controller: password_,
                              validator: (val)=>val.isEmpty?"Please Enter your password":null,

                              obscureText: true,
                              style: TextStyle(
                                  fontSize: 20
                              ),
                              decoration: InputDecoration(
                                  hintText: "New Password",
                                  hintStyle:  GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.white,
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),],
                ),
              ),
SizedBox(height: 10,),

              FlatButton(
                  onPressed: ()async{
                    if(_formKey.currentState.validate()){
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                      Map mapData = {
                        'password':email_.text,
                        'new_password':password_.text,


                      };
                      String token = prefs.getString('token');
                      // ignore: unnecessary_brace_in_string_interps
                      print("JsonData ${mapData}");

                      Map<String, String> requestHeaders = {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                        'authorization': "Bearer $token"

                      };

                      try {
                        var res = await http.post(
                            Uri.parse(
                                AppUrl.change_pass),
                            headers: requestHeaders,
                            body: jsonEncode(mapData));
                        print(mapData);
                        var data = jsonDecode(res.body);
                        print(data);
                        print(data['success']);

                        if (res.statusCode==200) {
                          Fluttertoast.showToast(

                              msg: "Password has been changed",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          logoutApi();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>login_screen()));

                        } else {
                          Fluttertoast.showToast(
                              msg: "error",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: "Invalid Entry",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }

                    }else{
                      Fluttertoast.showToast(
                          msg: "Invalid Entry",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                  },
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(child: Text("Submit",style: TextStyle(fontSize: 18,color: Colors.black),)),
                  ))
            ],
          ),
        ),
      );
  }
}
