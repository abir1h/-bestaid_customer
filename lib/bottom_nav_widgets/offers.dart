
import 'package:avatar_letter/avatar_letter.dart';
import 'package:best_aid_customer/Appointments/emergency.dart';
import 'package:best_aid_customer/Appointments/future_appointments.dart';
import 'package:best_aid_customer/Appointments/ready_to_call.dart';
import 'package:best_aid_customer/Appointments/regular_appointments.dart';


import'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainHome.dart';

class Appointments extends StatefulWidget {

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments>with TickerProviderStateMixin {

  TabController _controllertab;

  var name,phone,profile_image;
  getdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var picture_= prefs.getString('profile_image');
    var name_= prefs.getString('first_name');
    var phone_= prefs.getString('phone');

    setState(() {
      name=name_;
      phone=phone_;
      profile_image=picture_;

    });



  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    _controllertab = new TabController(length: 4, vsync: this);

  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
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
                Text("Appointments",style: GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18
                )),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: AvatarLetter(
                    size: 25,
                    backgroundColor: Color(0xff0E6B50),
                    textColor: Colors.white,
                    fontSize: 20,
                    upperCase: true,
                    numberLetters: 2,
                    letterType: LetterType.Circular,
                    text: name,
                  ),
                ),

              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/50,),

            TabBar(
              controller: _controllertab,
              isScrollable: true,
              indicatorColor: Colors.indigoAccent,
              tabs: [
                // Tab(icon: Icon(Icons.flight,color: Colors.black,)),
                Tab(child: Text("Complete",style:  GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16
                ),),),
                Tab(child: Text('Emergency ',style:  GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16
                ),),), Tab(child: Text('Schedule ',style:  GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16
                ),),),
Tab(child: Text('Ready To Call ',style:  GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16
                ),),),

              ],

            ),
            Container(
              height: 500,
              child: TabBarView(

                controller: _controllertab,
                children: [

                  regular_appointments(),
                  emergency_appointments(),
                  Future_appointments(),
                  ready_to()

                ],
              ),
            ),




          ],
        ),
      ),
    ));
  }
}
