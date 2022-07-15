
import 'package:best_aid_customer/Screens/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class upload_pop extends StatefulWidget {

  const upload_pop({Key key,}) : super(key: key);

  @override
  _upload_popState createState() => _upload_popState();
}

class _upload_popState extends State<upload_pop> {

  @override
  Widget build(BuildContext context) {
   var height= MediaQuery.of(context).size.height/10;
   var width= MediaQuery.of(context).size.width/3;
    return  Dialog(
      insetPadding: EdgeInsets.all(20),

      clipBehavior: Clip.antiAliasWithSaveLayer,      shape: RoundedRectangleBorder(
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

  contentBox(context){
    String _chosenValue;
    var height= MediaQuery.of(context).size.height/10;
    var width= MediaQuery.of(context).size.width/3;
    return
      Container(
        height: 300,

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Center(
                child: Text(
                  'Upload',style: GoogleFonts.lato(
                    color:  Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
                ),
              ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: InkWell(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (_)=>AddNewPostScreen(type: "Prescription",)));
                     },
                     child: Container(                     margin: EdgeInsets.only(left: 20),

                       height: MediaQuery.of(context).size.height/5,
                       width: MediaQuery.of(context).size.width/3,
                       decoration: BoxDecoration(
                         color: Colors.indigoAccent,
                         borderRadius: BorderRadius.circular(20)
                       ),
                       child:  Center(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.document_scanner,color: Colors.white,size: 40,),
                             Text(
                               'Prescription',style: GoogleFonts.lato(
                                 color:  Colors.white,
                                 fontWeight: FontWeight.w700,
                                 fontSize: 20),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ), Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: InkWell(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (_)=>AddNewPostScreen(type: "Report",)));

                     },
                     child: Container(
                       margin: EdgeInsets.only(right: 20),
                       height: MediaQuery.of(context).size.height/5,
                       width: MediaQuery.of(context).size.width/3,
                       decoration: BoxDecoration(
                         color: Colors.blue,
                         borderRadius: BorderRadius.circular(20)
                       ),
                       child: Center(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.book_outlined,color: Colors.white,size: 40,),
                             Text(
                               'Report',style: GoogleFonts.lato(
                                 color:  Colors.white,
                                 fontWeight: FontWeight.w700,
                                 fontSize: 20),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 )
               ],
             )
            ],
          ),
        ),
      ); }
}