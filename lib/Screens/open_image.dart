import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class open_image extends StatefulWidget {
  String info;
  open_image({this.info});
  @override
  _open_imageState createState() => _open_imageState();
}

class _open_imageState extends State<open_image> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pop(context);

        },
        child: Icon(Icons.close,color:Colors.white),
      ),
      appBar:

    AppBar(

      backgroundColor: Colors.black,
      leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.transparent,),onPressed: (){
},)
      ,),
      body: PhotoView(
        imageProvider: NetworkImage(widget.info) ,
        enableRotation: true,
      ),
    );
  }
}