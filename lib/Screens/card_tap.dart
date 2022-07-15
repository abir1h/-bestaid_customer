import 'package:avatar_letter/avatar_letter.dart';
import 'package:best_aid_customer/Screens/lifestyle_pop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../MainHome.dart';
class card_tap extends StatefulWidget {
  @override
  _card_tapState createState() => _card_tapState();
}

class _card_tapState extends State<card_tap> {
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
  }
  @override
  Widget build(BuildContext context) {var height=MediaQuery.of(context).size.height;
  var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_sharp,color: Colors.black,),
      //     onPressed: (){
      //       Navigator.pop(context);
      //     },
      //   ),
      //   centerTitle: true,
      //     title:  Text("LifeStyle Card",style: GoogleFonts.lato(
      //         color: Colors.black,
      //         fontWeight: FontWeight.w700,
      //         fontSize: 18
      //     )),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [SizedBox(height: MediaQuery.of(context).size.height/50,),
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
                Text("LifeStyle Card",style: GoogleFonts.lato(
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
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8),
              child: Container(
                height: 45,
                child: TextFormField(
                  onChanged: (String text) {
                    // if (_debounce?.isActive ?? false) _debounce.cancel();
                    // _debounce = Timer(const Duration(milliseconds: 1000), () {
                    //   _search();
                    // });
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,color: Colors.grey,),
                      border:OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: "Search here",
                      hintStyle: GoogleFonts.lato(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 14
                      )

                  ),
                ),
              ),
            ),
            Text('or',style: TextStyle(color: Colors.black,),),
            SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: () {
                scanQRCode();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Container(
                  height: height / 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xff0E6B50)),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.qr_code,
                          color: Color(0xff0E6B50),
                        ),
                      ),
                      Text(
                        " Tap to scan QR code",
                        style: TextStyle(
                            color:Color(0xff0E6B50),
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 10,

                itemBuilder: (_,index){

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: (){
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        elevation: 10,
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (context, setState) {
                                return SingleChildScrollView(
                                  child:                     Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(

                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close,color: Color(0x9f167940),))
                                            ],
                                          ),
                                          Column(
                                            children: [

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(

                                                      child: Center(child: Text('S',style: TextStyle(color: Colors.white),),),
                                                      backgroundColor: Colors.teal,
                                                      radius: 25,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Star Pharmacy',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                                          Text('Delpara bazar ,Naraynganj',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                          color: Color(0x9f167940)
                                                      ),child: Padding(
                                                      padding: const EdgeInsets.only(left: 5.0,right: 5,top: 2,bottom: 2),
                                                      child: Center(child: Text('UP TO 13 %',style: TextStyle(color: Colors.white),),),
                                                    ),
                                                    ),
                                                  )
                                                ],),
                                            ],
                                          ),
                                          Container(
                                            width: width,
                                            color: Colors.white,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "More Information",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 18),
                                                  ),
                                                ),

                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 8.0),
                                                        child: Text(
                                                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ",
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 15,),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap:(){
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return LifeStyle_pop();
                                                              });
                                                        },
                                                        child: Container(
                                                            width: width / 4,
                                                            height: height / 25,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(0x9f167940)),
                                                                borderRadius:
                                                                BorderRadius.circular(8)),
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets.all(4.0),
                                                              child: Center(
                                                                  child: Text(
                                                                    "Book Now",
                                                                    style: TextStyle(
                                                                        color: Color(0x9f167940),
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: 14),
                                                                  )),
                                                            )),
                                                      ),
                                                      // SizedBox(width: 15,),
                                                      // Container(
                                                      //     width: width / 4,
                                                      //     height: height / 25,
                                                      //     decoration: BoxDecoration(
                                                      //         color: Colors.pinkAccent,
                                                      //         borderRadius:
                                                      //         BorderRadius.circular(8)),
                                                      //     child: Padding(
                                                      //       padding:
                                                      //       const EdgeInsets.all(4.0),
                                                      //       child: Center(
                                                      //           child: Text(
                                                      //             "Details",
                                                      //             style: TextStyle(
                                                      //                 color: Colors.white,
                                                      //                 fontWeight: FontWeight.w600,
                                                      //                 fontSize: 14),
                                                      //           )),
                                                      //     )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                );
                              });
                        });
                  },
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color:Colors.grey
                              .withOpacity(
                              0.3),

                          spreadRadius: 5,

                          blurRadius: 7,

                          offset: Offset(2,
                              2), // changes position of shadow
                        )
                      ],
                    ),
                    child: Column(
                      children: [

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(

                                child: Center(child: Text('S',style: TextStyle(color: Colors.white),),),
                                backgroundColor: Colors.teal,
                                radius: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Star Pharmacy',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    Text('Delpara bazar ,Naraynganj',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment:MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0x9f167940)
                                ),child: Padding(
                                padding: const EdgeInsets.only(left: 5.0,right: 5,top: 2,bottom: 2),
                                child: Center(child: Text('UP TO 13 %',style: TextStyle(color: Colors.white),),),
                              ),
                              ),
                            )
                          ],),
                      ],
                    ),
                  ),
                ),
              );
            })

          ],
        ),
      ),
    ));
  }  Future<void> scanQRCode() async {
    try {
      final qrCode_ = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      // setState(() {
      //   this.qrCode = qrCode_;
      // });
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('school', this.qrCode);
      // Navigator.push(context, MaterialPageRoute(builder: (_) => register()));
    } on PlatformException {
      // qrCode = 'Failed to get platform version.';
    }
  }
}
