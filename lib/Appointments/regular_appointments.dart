import 'dart:async';
import 'dart:convert';

import 'package:avatar_letter/avatar_letter.dart';
import 'package:best_aid_customer/online_doctors/Show_details.dart';
import 'package:best_aid_customer/online_doctors/pres.dart';



import'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import'package:http/http.dart'as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
class regular_appointments extends StatefulWidget {

  @override
  _regular_appointmentsState createState() => _regular_appointmentsState();
}

class _regular_appointmentsState extends State<regular_appointments> {
  Future myfuture;
  Future<List<dynamic>> getpost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/api/customer/show/appointment/complete";
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
  String _url = "https://bestaid.com.bd/api/customer/search/result/complete/0/";

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
    Response response =
    await get(Uri.parse(_url + controller), headers: requestHeaders);
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
                      hintText: "Search by Patients Name/ID",
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
                    return                    Container(
                        constraints: BoxConstraints(),
                        child: FutureBuilder<List<dynamic>>(
                            future: myfuture,
                            builder: (_, AsyncSnapshot snapshot) {
                              print(snapshot.data);
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return  Column(
                                    children: [
                                      SizedBox(height: height/4,),
                                      Center(child:SpinKitThreeInOut(
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
                                      padding: const EdgeInsets.all(10.0),
                                      child:             Container(
                                        height: height/1.5,
                                        child: ListView.builder(

                                            shrinkWrap: true,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (_,index){

                                              return Column(
                                                children: [
                                                  ListTile(

                                                    leading:  AvatarLetter(
                                              size: 25,
                                                backgroundColor: Color(0xff0E6B50),
                                                textColor: Colors.white,
                                                fontSize: 20,
                                                upperCase: true,
                                                numberLetters: 2,
                                                letterType: LetterType.Circular,
                                                text: 'Completefg',
                                              ),
                                                    title:Text(snapshot.data[index]['patient_id'],style: GoogleFonts.lato(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16
                                                    )),

                                                    subtitle: Column(
                                                      crossAxisAlignment:CrossAxisAlignment.start,
                                                      children: [
                                                        Text(snapshot.data[index]['reason_for_visit'],style: GoogleFonts.lato(
                                                            color: Colors.blue,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 12
                                                        )
                                                        ),
                                                      ],
                                                    ),
                                                    trailing:

                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        IconButton(icon: Icon(Icons.remove_red_eye_outlined,color: Colors.green,), onPressed: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (_)=>show_details(id:snapshot.data[index]['id'].toString(),type: 'c',)));
                                                        }),
                                                        IconButton(icon: Icon(Icons.sticky_note_2,color: Colors.blue,), onPressed: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (_)=>pres(id:snapshot.data[index]['id'].toString(),)));
                                                        }),

                                                      ],
                                                    ),
                                                  ),
                                                ],
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

                  return    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:             Container(
                      height: height/1.5,
                      child: ListView.builder(

                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (_,index){

                            return Column(
                              children: [
                                ListTile(

                                  leading: AvatarLetter(
                            size: 25,
                              backgroundColor: Color(0xff0E6B50),
                              textColor: Colors.white,
                              fontSize: 20,
                              upperCase: true,
                              numberLetters: 2,
                              letterType: LetterType.Circular,
                              text: 'Completefg',
                            ),
                                  title:Text(snapshot.data[index]['patient_id'],style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16
                                  )),

                                  subtitle: Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data[index]['reason_for_visit'],style: GoogleFonts.lato(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12
                                      )
                                      ),
                                    ],
                                  ),
                                  trailing:

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(icon: Icon(Icons.remove_red_eye_outlined,color: Colors.green,), onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (_)=>show_details(id:snapshot.data[index]['id'].toString(),)));
                                      }),
                                      IconButton(icon: Icon(Icons.sticky_note_2,color: Colors.blue,), onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (_)=>pres(id:snapshot.data[index]['id'].toString(),)));
                                      })

                                    ],
                                  ),
                                ),
                              ],
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
