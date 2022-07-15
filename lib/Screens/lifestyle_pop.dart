import 'package:flutter/material.dart';


class LifeStyle_pop extends StatefulWidget {


  @override
  _LifeStyle_popState createState() => _LifeStyle_popState();
}

class _LifeStyle_popState extends State<LifeStyle_pop> {
  var c_name;
  var val;
  List shots = [];
  var _myJson;
  var class_id;
  List<String> countries = ["Nepal", "India", "USA"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var active;

  final _formKey = GlobalKey<FormState>();
  bool issave = false;
  TextEditingController class_name = TextEditingController();
  TextEditingController class_fee = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Wrap(
        children: [
          contentBox(context),
        ],
      ),
    );
  }

  contentBox(context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 20, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Payment",
                  style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Star Pharmacy',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    Text('Delpara bazar ,Naraynganj',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: height/15,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Amount'
                    ),
                  ),
                ),
              ),      Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0x9f167940)
                  ),child: Padding(
                  padding: const EdgeInsets.only(left: 5.0,right: 5,top: 2,bottom: 2),
                  child: Center(child: Text('Tap Here',style: TextStyle(color: Colors.white),),),
                ),
                ),
              )


            ],
          ),
        ),
        Positioned(
          top: 25,
          width: MediaQuery.of(context).size.width / .7,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Color(0x9f167940),
              radius: 15,
              child: Icon(Icons.clear),
            ),
          ),
        )
      ],
    );
  }
}
