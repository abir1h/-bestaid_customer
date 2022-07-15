import 'dart:convert';

import 'package:avatar_letter/avatar_letter.dart';
import 'package:best_aid_customer/Screens/loaders/emergancy_doctor.dart';
import 'package:best_aid_customer/Screens/psyco_loader.dart';
import 'package:best_aid_customer/Screens/url/App_url.dart';
import 'package:best_aid_customer/online_doctors/online_payment.dart';
import 'package:flutter/cupertino.dart';


import'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:http/http.dart'as http;
import 'package:flutter/services.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../MainHome.dart';
class psyco_booking extends StatefulWidget {


  @override
  _psyco_bookingState createState() => _psyco_bookingState();
}

class _psyco_bookingState extends State<psyco_booking>with TickerProviderStateMixin {
  bool isloading=false;
  Future myfuture;
  // Future getpost() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token');
  //   String url = "https://bestaid.com.bd/api/customer/show/doctor/$id";
  //   Map<String, String> requestHeaders = {
  //     'Accept': 'application/json',
  //     'authorization': "Bearer $token"
  //   };
  //
  //   var response = await http.get(Uri.parse(url), headers: requestHeaders);
  //   if (response.statusCode == 200) {
  //     print('Get post collected' + response.body);
  //     var userData1 = jsonDecode(response.body)['data'];
  //     print(userData1);
  //     return userData1;
  //   } else {
  //     print("post have no Data${response.body}");
  //   }
  // }
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController problem = TextEditingController();
  final TextEditingController bp = TextEditingController();
  final TextEditingController diabetes = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController drug_license_no = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController chalanges = TextEditingController();
  final TextEditingController institution = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }  String _mySelection='Mental Health',gender_drop,diabetics,relation,family_status;
  Future submit(String patient_name,String Address_f,String gender,String problem_f,var age,var weight,String phone,String relationship,String family,String chalanges,String institution)async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    String url = "https://bestaid.com.bd/api/customer/make/appointment";
    Map<String, String> requestHeaders = {

      'authorization': "Bearer $token"
    };
    var request =await http.MultipartRequest('POST',
      Uri.parse(AppUrl.psyco),

    );
    request.fields.addAll({
      'name':patient_name,
      'address':Address_f,
      'gender':gender,
      'reason_for_visit':problem_f,

      'age':age,
      'weight':weight,
      'doctor_id':'0',
      'phone':phone,
      'relationship_status':relation,
      'family_status':family_status,
      'challenges':chalanges,
      'institution':institution,
      'type_consultation':'psyco',


    });

    request.headers.addAll(requestHeaders);

    request.send().then((result) async {
      http.Response.fromStream(result)
          .then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)['data'];

          print(data['patient_id']);
          setState(() {
            isloading=false;
          });
          Fluttertoast.showToast(

              msg: "Please wait while redirecting",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 6,

              backgroundColor: Color(0xff0E6B50),
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.push(context, MaterialPageRoute(builder: (_)=>psyco_loader(patient_id: data['id'].toString(),)));


        }else{

          print("Fail! ");
          print(response.body);
          return response.body;

        }

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(

      body: SingleChildScrollView(

        child: Form(
          key: _formKey,
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
                  InkWell(
                    onTap: (){
                    },
                    child: Text("Reason For Visit",style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: AvatarLetter(
                      size: 25,
                      backgroundColor: Colors.transparent,
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
              Form(child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(


                      controller: name,
                      validator: (value)=>value.isEmpty?"Field Can not be empty":null,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                          ),

                          labelText:  "Patient Name*",

                          labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(


                      controller: phone,
                      keyboardType: TextInputType.number,
                      validator: (value)=>value.isEmpty?"Field Can not be empty":null,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                          ),

                          labelText:  "Phone *",

                          labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(


                      controller: address,
                      validator: (value)=>value.isEmpty?"Field Can not be empty":null,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                          ),

                          labelText:  "Address *",

                          labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: width,

                      child: Align(
                          alignment: Alignment.topLeft,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Select Gender*",style: TextStyle(fontWeight: FontWeight.bold),),
                              Container(
                                child: new DropdownButton<String>(
                                  isExpanded: true, //Add this property

                                  hint:gender_drop==null?Text("Select Gender ",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey)):Text(gender_drop,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey)),

                                  items:  <String>[
                                    "Male","Female",

                                  ]
                                      .map<DropdownMenuItem<String>>((value) =>
                                  new DropdownMenuItem<String>(

                                    value: value,
                                    child: new Text(value),
                                  )
                                  ).toList(),

                                  onChanged: (value) {

                                    setState(() {
                                      gender_drop= value;


                                    });


                                  },
                                  underline: DropdownButtonHideUnderline(child: Container()),

                                ),
                              ),
                            ],
                          )

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: width,

                      child: Align(
                          alignment: Alignment.topLeft,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Relationship Status*",style: TextStyle(fontWeight: FontWeight.bold),),
                              Container(
                                child: new DropdownButton<String>(
                                  isExpanded: true, //Add this property

                                  hint:relation==null?Text("Select Relationship Status ",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey)):Text(relation,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey)),

                                  items:  <String>[
                                    "Single","Married",

                                  ]
                                      .map<DropdownMenuItem<String>>((value) =>
                                  new DropdownMenuItem<String>(

                                    value: value,
                                    child: new Text(value),
                                  )
                                  ).toList(),

                                  onChanged: (value) {

                                    setState(() {
                                      relation= value;


                                    });


                                  },
                                  underline: DropdownButtonHideUnderline(child: Container()),

                                ),
                              ),
                            ],
                          )

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: width,

                      child: Align(
                          alignment: Alignment.topLeft,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Family Status*",style: TextStyle(fontWeight: FontWeight.bold),),
                              Container(
                                child: new DropdownButton<String>(
                                  isExpanded: true, //Add this property

                                  hint:family_status==null?Text("Select Family Status ",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey)):Text(family_status,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey)),

                                  items:  <String>[
                                    "Join","Single",

                                  ]
                                      .map<DropdownMenuItem<String>>((value) =>
                                  new DropdownMenuItem<String>(

                                    value: value,
                                    child: new Text(value),
                                  )
                                  ).toList(),

                                  onChanged: (value) {

                                    setState(() {
                                      family_status= value;


                                    });


                                  },
                                  underline: DropdownButtonHideUnderline(child: Container()),

                                ),
                              ),
                            ],
                          )

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: width,

                      child: Align(
                          alignment: Alignment.topLeft,
                          child:  Column(                          crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text("Select problem*",style: TextStyle(fontWeight: FontWeight.bold),),
                              Container(
                                child: new DropdownButton<String>(
                                  isExpanded: true, //Add this property

                                  hint:_mySelection==null?Text("Mental Health",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey)):Text(_mySelection,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey)),

                                  items:  <String>["Mental Health"

                                  ]
                                      .map<DropdownMenuItem<String>>((value) =>
                                  new DropdownMenuItem<String>(

                                    value: value,
                                    child: new Text(value),
                                  )
                                  ).toList(),

                                  onChanged: (value) {

                                    setState(() {
                                      _mySelection= value;


                                    });


                                  },
                                  underline: DropdownButtonHideUnderline(child: Container()),

                                ),
                              ),
                            ],
                          )

                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: TextFormField(
                  //
                  //
                  //     controller: problem,
                  //     validator: (value)=>value.isEmpty?"Field Can not be empty":null,
                  //     decoration: InputDecoration(
                  //         border: UnderlineInputBorder(
                  //         ),
                  //
                  //         labelText:  "Describe Problem*",
                  //
                  //         labelStyle: TextStyle(
                  //             fontWeight: FontWeight.normal,
                  //             fontSize: 16,
                  //             color: Colors.black)),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: TextFormField(
                  //
                  //     keyboardType: TextInputType.number,
                  //     controller: bp,
                  //     validator: (value)=>value.isEmpty?"Field Can not be empty":null,
                  //     decoration: InputDecoration(
                  //
                  //         border: UnderlineInputBorder(
                  //         ),
                  //
                  //         labelText:  "Blood Pleasure*",
                  //
                  //         labelStyle: TextStyle(
                  //             fontWeight: FontWeight.normal,
                  //             fontSize: 16,
                  //             color: Colors.black)),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: TextFormField(
                  //
                  //
                  //     controller: diabetes,
                  //     validator: (value)=>value.isEmpty?"Field Can not be empty":null,
                  //     decoration: InputDecoration(
                  //         border: UnderlineInputBorder(
                  //         ),
                  //
                  //         labelText:  "Diabetes*",
                  //
                  //         labelStyle: TextStyle(
                  //             fontWeight: FontWeight.normal,
                  //             fontSize: 16,
                  //             color: Colors.black)),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: Container(
                  //     width: width,
                  //
                  //     child: Align(
                  //         alignment: Alignment.topLeft,
                  //         child:  Column(
                  //           children: [
                  //             Text("Diabetics"),
                  //             Container(
                  //               child: new DropdownButton<String>(
                  //                 isExpanded: true, //Add this property
                  //
                  //                 hint:diabetics==null?Text("Select yes /No ",style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     fontSize: 14,
                  //                     color: Colors.grey)):Text(diabetics,style: TextStyle(
                  //                     fontWeight: FontWeight.bold,
                  //                     fontSize: 14,
                  //                     color: Colors.grey)),
                  //
                  //                 items:  <String>[
                  //                   "Yes","No",
                  //
                  //                 ]
                  //                     .map<DropdownMenuItem<String>>((value) =>
                  //                 new DropdownMenuItem<String>(
                  //
                  //                   value: value,
                  //                   child: new Text(value),
                  //                 )
                  //                 ).toList(),
                  //
                  //                 onChanged: (value) {
                  //
                  //                   setState(() {
                  //                     diabetics= value;
                  //
                  //
                  //                   });
                  //
                  //
                  //                 },
                  //                 underline: DropdownButtonHideUnderline(child: Container()),
                  //
                  //               ),
                  //             ),
                  //           ],
                  //         )
                  //
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(


                      controller: chalanges,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                          ),

                          labelText:  "Shortly describe your running challenges",

                          labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(


                      controller:institution,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                          ),

                          labelText:  "Institution",

                          labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(

                      keyboardType: TextInputType.number,

                      controller: age,
                      validator: (value)=>value.isEmpty?"Field Can not be empty":null,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                          ),

                          labelText:  "Age*",

                          labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(

                      keyboardType: TextInputType.number,

                      controller: weight,
                      validator: (value)=>value.isEmpty?"Field Can not be empty":null,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                          ),

                          labelText:  "Weight*",

                          labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black)),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: ()async{
                          if(_formKey.currentState.validate()){
                           if(relation!=null && family_status !=null && gender_drop!=null){
                             setState(() {
                               isloading=true;
                             });
                             submit(name.text,address.text,gender_drop,_mySelection,age.text,weight.text,phone.text,relation,family_status,chalanges.text,institution.text);
                           }else{
                             Fluttertoast.showToast(

                                 msg: "Select all the required fields",
                                 toastLength: Toast.LENGTH_LONG,
                                 gravity: ToastGravity.CENTER,
                                 timeInSecForIosWeb: 6,

                                 backgroundColor: Colors.black54,
                                 textColor: Colors.white,
                                 fontSize: 16.0);
                           }
                          }


                          // sslCommerzGeneralCall();
                          // sslCommerzCustomizedCall(name.text,address.text,gender_drop,_mySelection,problem.text,bp.text,diabetics,age.text,weight.text);
                          // Fluttertoast.showToast(
                          //
                          //     msg: "Please wait while Contacting dotor...",
                          //     toastLength: Toast.LENGTH_LONG,
                          //     gravity: ToastGravity.CENTER,
                          //     timeInSecForIosWeb: 6,
                          //
                          //     backgroundColor: Colors.black54,
                          //     textColor: Colors.white,
                          //     fontSize: 16.0);
                          //
                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                          // String token = prefs.getString('token');
                          //
                          // String url = "https://bestaid.com.bd/api/customer/make/appointment";
                          // Map<String, String> requestHeaders = {
                          //
                          //   'authorization': "Bearer $token"
                          // };
                          // var request =await http.MultipartRequest('POST',
                          //   Uri.parse(url),
                          //
                          // );
                          // request.fields.addAll({
                          //   'name':name.text,
                          //   'address':address.text,
                          //   'gender':gender_drop,
                          //   'reason_for_visit':_mySelection,
                          //   'problem':problem.text,
                          //   'bp':bp.text,
                          //   'diabetes':diabetes.text,
                          //   'age':age.text,
                          //   'weight':weight.text,
                          //   'doctor_id':widget.id!=null?widget.id:0.toString()
                          // });
                          //
                          // request.headers.addAll(requestHeaders);
                          //
                          // request.send().then((result) async {
                          //   http.Response.fromStream(result)
                          //       .then((response) {
                          //     if (response.statusCode == 200) {
                          //       var data = jsonDecode(response.body)['data'];
                          //
                          //       print(data['patient_id']);
                          //       setState(() {
                          //         isloading=false;
                          //       });
                          //       Fluttertoast.showToast(
                          //
                          //           msg: "Please wait while redirecting",
                          //           toastLength: Toast.LENGTH_LONG,
                          //           gravity: ToastGravity.CENTER,
                          //           timeInSecForIosWeb: 6,
                          //
                          //           backgroundColor: Color(0xff0E6B50),
                          //           textColor: Colors.white,
                          //           fontSize: 16.0);
                          //       // Navigator.push(context, MaterialPageRoute(builder: (_)=>emergency_doctor_loader(patient_id: data['id'].toString(),)));
                          //  Navigator.push(context, MaterialPageRoute(builder: (_)=>online_payment()));
                          //
                          //     }else{
                          //       setState(() {
                          //         isloading=false;
                          //       });
                          //       print("Fail! ");
                          //       print(response.body);
                          //       return response.body;
                          //
                          //     }
                          //
                          //   });
                          // });


                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height/20,
                          width: MediaQuery.of(context).size.width/2,
                          child: Center(child: Text("Submit",style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                          ),),),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff01B090)
                          ),
                        ),
                      )
                  ),


                ],
              ))


            ],
          ),
        ),
      ),
    ));
  }
  Future<void> sslCommerzGeneralCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //Use the ipn if you have valid one, or it will fail the transaction.
            ipn_url: "www.ipnurl.com",
            multi_card_name: "bkash",
            currency: SSLCurrencyType.BDT,
            product_category: "Telemedicine",
            sdkType: SSLCSdkType.TESTBOX,
            store_id: "243545",
            store_passwd:"100",
            total_amount: double.parse('100'),
            tran_id: "1231321321321312"));
    sslcommerz.payNow();
  }

  Future<void> sslCommerzCustomizedCall(
      String patient_name,String Address_f,String gender,String problem_f,String des_problem,var bp,var db,var age,var weight
      ) async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //Use the ipn if you have valid one, or it will fail the transaction.
            ipn_url: "www.ipnurl.com",
            multi_card_name: "45434",
            currency: SSLCurrencyType.BDT,
            product_category: "Telemedicine",
            sdkType: SSLCSdkType.TESTBOX,
            store_id: "testbox",
            store_passwd:"qwerty",
            total_amount: double.parse('100'),
            tran_id: "1231321321321312"));
    sslcommerz
        .addEMITransactionInitializer(
        sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
            emi_options: 1, emi_max_list_options: 3, emi_selected_inst: 2))
        .addShipmentInfoInitializer(
        sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
            shipmentMethod: "yes",
            numOfItems: 5,
            shipmentDetails: ShipmentDetails(
                shipAddress1: "Ship address 1",
                shipCity: "Faridpur",
                shipCountry: "Bangladesh",
                shipName: "Ship name 1",
                shipPostCode: "7860")))
        .addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: "Chattogram",
            customerName: "Abu Sayed Chowdhury",
            customerEmail: "sayem227@gmail.com",
            customerAddress1: "Anderkilla",
            customerCity: "Chattogram",
            customerPostCode: "200",
            customerCountry: "Bangladesh",
            customerPhone: "01676772959"))
        .addProductInitializer(
        sslcProductInitializer:
        // ***** ssl product initializer for general product STARTS*****
        SSLCProductInitializer(
            productName: "Water Filter",
            productCategory: "Widgets",
            general: General(
                general: "General Purpose",
                productProfile: "Product Profile"))
      // ***** ssl product initializer for general product ENDS*****

      // ***** ssl product initializer for non physical goods STARTS *****
      // SSLCProductInitializer.WithNonPhysicalGoodsProfile(
      //     productName:
      //   "productName",
      //   productCategory:
      //   "productCategory",
      //   nonPhysicalGoods:
      //   NonPhysicalGoods(
      //      productProfile:
      //       "Product profile",
      //     nonPhysicalGoods:
      //     "non physical good"
      //       ))
      // ***** ssl product initializer for non physical goods ENDS *****

      // ***** ssl product initialization for travel vertices STARTS *****
      //       SSLCProductInitializer.WithTravelVerticalProfile(
      //          productName:
      //         "productName",
      //         productCategory:
      //         "productCategory",
      //         travelVertical:
      //         TravelVertical(
      //               productProfile: "productProfile",
      //               hotelName: "hotelName",
      //               lengthOfStay: "lengthOfStay",
      //               checkInTime: "checkInTime",
      //               hotelCity: "hotelCity"
      //             )
      //       )
      // ***** ssl product initialization for travel vertices ENDS *****

      // ***** ssl product initialization for physical goods STARTS *****

      // SSLCProductInitializer.WithPhysicalGoodsProfile(
      //     productName: "productName",
      //     productCategory: "productCategory",
      //     physicalGoods: PhysicalGoods(
      //         productProfile: "Product profile",
      //         physicalGoods: "non physical good"))

      // ***** ssl product initialization for physical goods ENDS *****

      // ***** ssl product initialization for telecom vertice STARTS *****
      // SSLCProductInitializer.WithTelecomVerticalProfile(
      //     productName: "productName",
      //     productCategory: "productCategory",
      //     telecomVertical: TelecomVertical(
      //         productProfile: "productProfile",
      //         productType: "productType",
      //         topUpNumber: "topUpNumber",
      //         countryTopUp: "countryTopUp"))
      // ***** ssl product initialization for telecom vertice ENDS *****
    )
        .addAdditionalInitializer(
        sslcAdditionalInitializer: SSLCAdditionalInitializer(
            valueA: "value a",
            valueB: "value b",
            valueC: "value c",
            valueD: "value d"));
    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("the response is: " +
          result.message.toString() +
          " code: " +
          result.code);
    } else {


      SSLCTransactionInfoModel model = result;
      Fluttertoast.showToast(
          msg: "Transaction successful: Amount ${model.amount} TK",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }
  }
}
