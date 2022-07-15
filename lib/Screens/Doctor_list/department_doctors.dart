import 'dart:async';
import 'dart:convert';

import 'package:avatar_letter/avatar_letter.dart';
import 'package:best_aid_customer/Screens/doctor_profile/dotor_profile.dart';
import 'package:best_aid_customer/Screens/url/App_url.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import'package:http/http.dart'as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../MainHome.dart';
class department_doctors extends StatefulWidget {
  final String id;
  const department_doctors({Key key,this.id}) : super(key: key);
  @override
  _department_doctorsState createState() => _department_doctorsState();
}

class _department_doctorsState extends State<department_doctors> {
  Future myfuture;
  Future<List<dynamic>> getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var id=widget.id;

    String url = "https://bestaid.com.bd/api/customer/show/department/doctor/$id";
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
  TextEditingController _controller = TextEditingController();


  StreamController _streamController;
  Stream _stream;

  Timer _debounce;

  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Map<String, String> requestHeaders = {'authorization': "Bearer $token"};

    String controller = _controller.text.trim();
    _streamController.add("waiting");
    var id=widget.id;
    Response response =
    await get(Uri.parse("https://bestaid.com.bd/api/customer/search/result/department/$id/" + controller), headers: requestHeaders);
    _streamController.add(json.decode(response.body)['data']);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfuture=getpost();
    _streamController = StreamController();
    _stream = _streamController.stream;
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
                  controller: _controller,
                  onChanged: (String text) {
                    if (_debounce?.isActive ?? false) _debounce.cancel();
                    _debounce = Timer(const Duration(milliseconds: 1000), () {
                      _search();
                    });
                  },
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
              margin: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _stream,
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return                  Container(
                        constraints: BoxConstraints(),
                        child: FutureBuilder<List<dynamic>>(
                            future: myfuture,
                            builder: (_, AsyncSnapshot snapshot) {
                              print(snapshot.data);
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return  Column(
                                    children: [
                                      SizedBox(height: height/2,),
                                      Center(child:SpinKitRotatingCircle(
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
                                        ?                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: height/1.4,
                                        child: ListView.builder(

                                            shrinkWrap: true,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (_,index){
                                              var imagelink=snapshot.data[index]['profile_image']!=null?snapshot.data[index]['profile_image']:'link';

                                              return Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: InkWell(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (_)=>doctor_profile(id: snapshot.data[index]['id'].toString(),)));

                                                  },
                                                  child: Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            height:height/3,

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
                                                                        width: width/3,
                                                                        margin: EdgeInsets.only(bottom: 40),
                                                                        child: Column(
                                                                          children: [
                                                                            CircularProfileAvatar(
                                                                              null,
                                                                              child: CachedNetworkImage(
                                                                                imageUrl:
                                                                                AppUrl.pic_url1+imagelink,
                                                                                fit: BoxFit.cover,
                                                                                placeholder: (context, url) => CircularProgressIndicator(),
                                                                                errorWidget: (context, url, error) => Icon(Icons.person),
                                                                              ),
                                                                              elevation: 5,
                                                                              radius: 30,
                                                                            ),
                                                                            SizedBox(height: 5,),
                                                                            Text(snapshot.data[index]['degree_obtained']),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Align(
                                                                            alignment:Alignment.topLeft,
                                                                            child: Text(snapshot.data[index]['name'],style: GoogleFonts.lato(
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 16
                                                                            )
                                                                            ),
                                                                          ),Align(
                                                                            alignment:Alignment.topLeft,
                                                                            child: Text(snapshot.data[index]['degree_obtained'],style: GoogleFonts.lato(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 14
                                                                            ),
                                                                            ),
                                                                          ),Align(
                                                                            alignment:Alignment.topLeft,
                                                                            child: Text(snapshot.data[index]['experience'],style: GoogleFonts.lato(
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
                                                                            child: Text(snapshot.data[index]['medical']['name']+"("+snapshot.data[index]['department']['name']+')',style: GoogleFonts.lato(
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
                                                                            Text(snapshot.data[index]['pay_amount'],style: GoogleFonts.lato(
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
                                                ),
                                              );
                                            }),
                                      ),
                                    )



                                        : Text('No data');
                                  }
                              }
                              return CircularProgressIndicator();
                            }))
                    ;
                  }

                  if (snapshot.data == "waiting") {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
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
                  }

                  return     Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      height: height/1.2,
                      child: ListView.builder(

                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (_,index){
                            var imagelink=snapshot.data[index]['profile_image']!=null?snapshot.data[index]['profile_image']:'link';

                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>doctor_profile(id: snapshot.data[index]['id'].toString(),)));

                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                          height:height/3,

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
                                                      width: width/3,
                                                      margin: EdgeInsets.only(bottom: 40),
                                                      child: Column(
                                                        children: [
                                                          CircularProfileAvatar(
                                                            null,
                                                            child: CachedNetworkImage(
                                                              imageUrl:
                                                              AppUrl.pic_url1+imagelink,
                                                              fit: BoxFit.cover,
                                                              placeholder: (context, url) => CircularProgressIndicator(),
                                                              errorWidget: (context, url, error) => Icon(Icons.person),
                                                            ),
                                                            elevation: 5,
                                                            radius: 30,
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Text(snapshot.data[index]['degree_obtained']),
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
                                                        child: Text(snapshot.data[index]['name'],style: GoogleFonts.lato(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 16
                                                        )
                                                        ),
                                                      ),Align(
                                                        alignment:Alignment.topLeft,
                                                        child: Text(snapshot.data[index]['degree_obtained'],style: GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 14
                                                        ),
                                                        ),
                                                      ),Align(
                                                        alignment:Alignment.topLeft,
                                                        child: Text(snapshot.data[index]['experience'],style: GoogleFonts.lato(
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
                                                        child: Text(snapshot.data[index]['medical']['name']+"("+snapshot.data[index]['department']['name']+')',style: GoogleFonts.lato(
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
                                                          Text(snapshot.data[index]['pay_amount'],style: GoogleFonts.lato(
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
                              ),
                            );
                          }),
                    ),
                  );
                },
              ),
            ),



          ],
        ),
      ),
    ));
  }
}
