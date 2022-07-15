

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import'package:http/http.dart' as http;
import 'Login_screen.dart';
import 'Otp_Screen.dart';
import 'Screens/url/App_url.dart';

class register_screen extends StatefulWidget {
  @override
  _register_screenState createState() => _register_screenState();
}

class _register_screenState extends State<register_screen> {
  TextEditingController first_name=TextEditingController();
  TextEditingController last=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController Password=TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future registerApi_(String fname,String lname,String phone,String password_ )async {
    Map<String, String> requestHeaders = {

      'Accept': 'application/json',
    };
    var request = await http.MultipartRequest('POST',
      Uri.parse(AppUrl.reg),

    );
    request.fields.addAll({
      'first_name': fname,
      'last_name': lname,

      'phone_number': phone,
      'password': password_,
    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result)
          .then((response) {
        if (response.statusCode == 201) {

          var data = jsonDecode(response.body)['data'];
          print('response.body ' + data.toString());
          print(data);

          Fluttertoast.showToast(

              msg: "OTP sent Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.push(context, MaterialPageRoute(builder: (_)=>OtpVerificationScreen(phone: phone,customer_id: data.toString(),)));

        }else{
          print("Fail! ");
          var data = jsonDecode(response.body);
          print(data);

          Fluttertoast.showToast(

              msg: data['message'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          return response.body;

        }

      });
    });
  }



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff0E6B50),
      appBar: AppBar(
        backgroundColor:Color(0xff0E6B50),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => login_screen()));
          },
        ),
        title: Text("Create Account",
            style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height / 10,
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: height / 1.1,
                    width: width * 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(height: height/20,),

                                  Text("Welcome to BestAid".toUpperCase(),style: GoogleFonts.lato(
                                      color:Color(0xff0E6B50),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18
                                  )),
                                  SizedBox(height: height/15,),
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: first_name, style: TextStyle(
                                              color: Colors.black
                                          ),
                                            validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                                hintText: "First Name",

                                                hintStyle: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: last, style: TextStyle(
                                              color: Colors.black
                                          ),
                                            validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                                hintText: "Last Name",

                                                hintStyle: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14
                                                )
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: phone, style: TextStyle(
                                              color: Colors.black
                                          ),
                                            validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                                hintText: "Phone",

                                                hintStyle: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14
                                                )
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            obscureText: true,
                                            controller: Password, style: TextStyle(
                                              color: Colors.black
                                          ),
                                            validator: (value)=>value.isEmpty?"Field Can't be empty":null,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.black, width: 1.0),),
                                                hintText: "Password",

                                                hintStyle: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14
                                                )
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: height/12,),

                                  InkWell(
                                    onTap: (){
                                      if(_formKey.currentState.validate()){
                                        registerApi_(first_name.text, last.text, phone.text, Password.text,);

                                      }
                                    },
                                    child: Container(
                                      height: height/15,
                                      width: width/2,
                                      decoration: BoxDecoration(
                                        color: Color(0xff0E6B50),
                                        borderRadius: BorderRadius.circular(20),

                                      ),
                                      child: Center(
                                        child: Text("Register",style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20
                                        )),
                                      ),

                                    ),
                                  ),
                                  SizedBox(height:  MediaQuery.of(context).size.height/50,),

                                  Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Already have an account ?",style: GoogleFonts.lato(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16
                                        )),InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (_)=>login_screen()));

                                          },
                                          child: Text(" Sign In",style: GoogleFonts.lato(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16
                                          )),
                                        ),
                                      ],
                                    ),
                                  )


                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   top: height / 5000,
                //   left: width / 2.8,
                //   child: CircularProfileAvatar(
                //       null,
                //       borderColor: Colors.black,
                //       borderWidth: 3,
                //       child: CachedNetworkImage(
                //         imageUrl:
                //         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUkIq9DjIgYbGgIenjkjA-tkr3mN1_bBnsEw&usqp=CAU',
                //         fit: BoxFit.cover,
                //         placeholder: (context, url) =>
                //             CircularProgressIndicator(),
                //         errorWidget: (context, url, error) => Icon(Icons.person),
                //       ),
                //       elevation: 5,
                //       radius: 50
                //
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
