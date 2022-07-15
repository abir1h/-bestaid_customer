import 'package:avatar_letter/avatar_letter.dart';
import 'package:best_aid_customer/Screens/doctor_profile/dotor_profile.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../MainHome.dart';
class doctor_list extends StatefulWidget {
  final String id;
  const doctor_list({Key key,this.id}) : super(key: key);
  @override
  _doctor_listState createState() => _doctor_listState();
}

class _doctor_listState extends State<doctor_list> {

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
                Text("Search a Doctor",style: GoogleFonts.lato(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18
                )),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: AvatarLetter(
                    size: 25,
                    backgroundColor: Colors.indigoAccent,
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
            padding: const EdgeInsets.only(left:28.0,right: 28),
            child: Container(
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,color: Colors.grey,),
                  border:OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: "Search by doctor's name,code/speciality",
                  hintStyle: GoogleFonts.lato(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 14
                  )

                ),
              ),
            ),
          ),          SizedBox(height: MediaQuery.of(context).size.height/40,),

            Container(
              margin: EdgeInsets.only(left: 40),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("492 doctor's found in",style: GoogleFonts.lato(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 14
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: height/1.4,
                child: ListView.builder(

                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (_,index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                  height:height/3.2,

                                  decoration:
                                BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius
                                      .circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(
                                          0.2),

                                      spreadRadius: 2,

                                      blurRadius: 7,

                                      offset: Offset(2,
                                          1), // changes position of shadow
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 40),
                                            child: Column(
                                              children: [
                                                CircularProfileAvatar(
                                                  null,
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                    'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) => CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) => Icon(Icons.person),
                                                  ),
                                                  elevation: 5,
                                                  radius: 30,
                                                ),
                                                SizedBox(height: 5,),
                                                Text("ENT Specialist"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment:Alignment.topLeft,
                                              child: Text("Doctor Mahbubur Rahman",style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16
                                        )
                                              ),
                                            ),Align(
                                              alignment:Alignment.topLeft,
                                              child: Text("MBBS",style: GoogleFonts.lato(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14
                                        ),
                                              ),
                                            ),Align(
                                              alignment:Alignment.topLeft,
                                              child: Text("6+ years",style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                              )
                                              ),
                                            ),
                                            Align(
                                              alignment:Alignment.topLeft,
                                              child: Text("Total Experience",style: GoogleFonts.lato(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12
                                              ),)),
                                            Align(
                                              alignment:Alignment.topLeft,
                                              child: Text("Sheikh Mujib Medical Collage",style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                              )
                                              ),
                                            ),
                                            Align(
                                                alignment:Alignment.topLeft,
                                                child: Text("Working on",style: GoogleFonts.lato(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12
                                                ),)),

                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.black,),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: Row(
                                              children: [
                                                Text("৳ 256",style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18
                                                )),
                                                SizedBox(width: 10,),
                                                Text("per consultation",style: GoogleFonts.lato(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14
                                                )),
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child:  InkWell(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (_)=>doctor_profile()));

                                              },
                                              child: Container(

                                                height: 35,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(40.0),
                                                    bottomLeft: Radius.circular(40.0),
                                                  ),
                                                  color: Color(0xff0E6B50),

                                                ),
                                                child: IconButton(
                                                  icon: Icon(Icons.arrow_forward,color: Colors.white,),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),



                                  ],
                                )
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
