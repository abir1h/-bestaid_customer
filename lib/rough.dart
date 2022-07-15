import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class rough extends StatefulWidget {
  @override
  _roughState createState() => _roughState();
}

class _roughState extends State<rough> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Align(alignment:Alignment.center,child: Column(
              children: [
                Image.asset('images/Rotate_Logo.gif',height: 200,width: 200,),
              ],
            )))
            ,SizedBox(height: 30,),
            Center(child: Shimmer.fromColors(

                baseColor: Color(0xff0E6B50),
                highlightColor: Colors.red,
                child: Text("Please Wait...",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w900,),)))
          ],
        ),
      ),
    );
  }
}
