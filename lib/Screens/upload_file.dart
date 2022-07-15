import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:best_aid_customer/Screens/url/App_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart'as http;
import 'package:http/http.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


// class upload_section extends StatefulWidget {
//   @override
//   _upload_sectionState createState() => _upload_sectionState();
// }
//
// class _upload_sectionState extends State<upload_section> {
//   List<Asset> images = <Asset>[];
//   String _error = 'No Error Dectected';
//   // Future login(String email,String password)async {
//   //   Map<String, String> requestHeaders = {
//   //
//   //     'Accept': 'application/json',
//   //   };
//   //   var request = await http.MultipartRequest('POST',
//   //     Uri.parse(AppUrl.login),
//   //
//   //   );
//   //   request.fields.addAll({
//   //     'phone_number': email,
//   //     'password': password,
//   //   });
//   //
//   //   request.headers.addAll(requestHeaders);
//   //
//   //   request.send().then((result) async {
//   //     http.Response.fromStream(result)
//   //         .then((response) {
//   //       if (response.statusCode == 200) {
//   //         var data = jsonDecode(response.body);
//   //         print(data['status_code']);
//   //         print('response.body ' + data.toString());
//   //         if(data['status_code']==200){
//   //           print(data['token']['plainTextToken']);
//   //           print(data['data']['first_name']);
//   //           saveprefs(data['token']['plainTextToken'], data['data']['first_name'],data['data']['last_name'],data['data']['phone_number'],);
//   //           print("Success! ");
//   //           Fluttertoast.showToast(
//   //
//   //               msg: "Login Successfully",
//   //               toastLength: Toast.LENGTH_LONG,
//   //               gravity: ToastGravity.BOTTOM,
//   //               timeInSecForIosWeb: 1,
//   //               backgroundColor: Colors.black54,
//   //               textColor: Colors.white,
//   //               fontSize: 16.0);
//   //
//   //
//   //           Navigator.push(context, MaterialPageRoute(builder: (_)=>login_laoder()));
//   //
//   //
//   //         }else{
//   //           print("Fail! ");
//   //           Fluttertoast.showToast(
//   //
//   //               msg: "Unauthorized",
//   //               toastLength: Toast.LENGTH_LONG,
//   //               gravity: ToastGravity.BOTTOM,
//   //               timeInSecForIosWeb: 1,
//   //               backgroundColor: Colors.black54,
//   //               textColor: Colors.white,
//   //               fontSize: 16.0);
//   //         }
//   //       }else{
//   //         print("Fail! ");
//   //
//   //         return response.body;
//   //
//   //       }
//   //
//   //     });
//   //   });
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Widget buildGridView() {
//     return GridView.count(
//       crossAxisCount: 3,
//       shrinkWrap: true,
//       children: List.generate(images.length, (index) {
//         Asset asset = images[index];
//         return Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: AssetThumb(
//                 asset: asset,
//                 width: 300,
//                 height: 300,
//               ),
//             ),
//             Positioned(
//                 left: MediaQuery.of(context).size.width/5,
//                 child:             IconButton(icon:Icon(Icons.close,color: Colors.red,),onPressed: (){
// setState(() {
//   images.removeAt(index);
//
// });
//                 },)
//             )
//           ],
//         );
//       }),
//     );
//   }
//
//   Future<void> loadAssets() async {
//     List<Asset> resultList = <Asset>[];
//     String error = 'No Error Detected';
//
//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 300,
//         enableCamera: true,
//         selectedAssets: images,
//         cupertinoOptions: CupertinoOptions(
//           takePhotoIcon: "chat",
//           doneButtonTitle: "Fatto",
//         ),
//         materialOptions: MaterialOptions(
//           actionBarColor: "#abcdef",
//           actionBarTitle: "Example App",
//           allViewTitle: "All Photos",
//           useDetailsView: false,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );
//     } on Exception catch (e) {
//       error = e.toString();
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       images = resultList;
//       _error = error;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar:    AppBar(
//
//         backgroundColor: Colors.white,
//         title: Text(
//           'Upload Images ',style: GoogleFonts.lato(
//             color: Colors.black,
//             fontWeight: FontWeight.w700,
//             fontSize: 18),
//         ),
//         leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
//         },)
//         ,),
//
//       body: Column(
//           children: <Widget>[
//
//             Expanded(
//               child: buildGridView(),
//             ),
//             ElevatedButton(
//               child: Text("Pick images"),
//               onPressed: loadAssets,
//             ),
//             ElevatedButton(
//               child: Text("Send"),
//               onPressed: ()async{
//                 print(images);
//                 Map<String, String> requestHeaders = {
//
//                   'Accept': 'application/json',
//                 };
//                 var request = await http.MultipartRequest('POST',
//                   Uri.parse(AppUrl.dhr),
//
//                 );
//     // if(images!=null){ request.files
//     //     .add(await http.MultipartFile.fromPath('profile_image', _image.path));
//
//                 List<MultipartFile> multipart = [];
//                 for (int i = 0; i < images.length; i++) {
//                   var path = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
//                   multipart.add(await MultipartFile.fromFile(path, filename: 'myfile.jpg'));
//                 }
//                 request.headers.addAll(requestHeaders);
//
//                 request.send().then((result) async {
//                   http.Response.fromStream(result)
//                       .then((response) {
//                     if (response.statusCode == 200) {
//                       var data = jsonDecode(response.body);
//                       print(data['status_code']);
//                       print('response.body ' + data.toString());
//                       if(data['status_code']==200){
//                         print(response.body);
//
//
//
//
//
//                       }else{
//                         print("Fail! ");
//                         print(response.body);
//
//
//                       }
//                     }else{
//                       print("Fail! ");
//                       print(response.body);
//
//
//                       return response.body;
//
//                     }
//
//                   });
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class AddNewPostScreen extends StatefulWidget {
  final String type;
  AddNewPostScreen({this.type});


  @override
  _AddNewPostScreenState createState() => _AddNewPostScreenState();
}

class _AddNewPostScreenState extends State<AddNewPostScreen> {
  @override
  void initState() {
    super.initState();
    print("add new post");
    type_doc.text= widget.type;
  }
  var list=[];
  bool uploading=false;
   Future<String> uploadMultipleImage({List<File> files}) async {
// string to uri
    var uri = Uri.parse('https://bestaid.com.bd/api/customer/dhr/image/post');
    print("image upload URL - $uri");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
// create multipart request
    var request = new http.MultipartRequest("POST", uri);
    List<MultipartFile> newList = [];

    for (var file in files) {
      String fileName = file.path.split("/").last;
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));

      // get file length

      var length = await file.length(); //imageFile is your image file
      print("File lenght - $length");
      print("fileName - $fileName");
      // multipart that takes file
      var multipartFileSign = new http.MultipartFile('image[]', stream, length,
          filename: fileName,
      );
      newList.add(multipartFileSign);
      print(newList);


    }

  //   for(int i =0;i<files.length;i++){
  //     var file;
  //     String fileName = files[i].path.split("/").last;
  //     var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  //
  //       // get file length
  //
  //       var length = await file.length(); //imageFile is your image file
  //       print("File lenght - $length");
  //       print("fileName - $fileName");
  // var multipartFileSign = new http.MultipartFile('image', stream, length,
  //           filename: fileName);
  //
  //     newList.add(multipartFileSign);
  //   }


    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Bearer $token"
    };
    // ignore this headers if there is no authentication
    print("headers - $requestHeaders}");
//add headers
     request.fields.addAll({
       'title': type_doc.text,
     });    request.headers.addAll(requestHeaders);
    request.files.addAll(newList);



// send
    var response = await request.send();

    print(response.statusCode);

    var res = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      print("Item form is statuscode 200");
      print(res.body);

      var responseDecode = json.decode(res.body);
      setState(() {
uploading=false;
      });
      Fluttertoast.showToast(

          msg: "Uplaoded Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);

      if (responseDecode['status'] == 200) {
        print(res.body);

        return res.body;
      } else {
        print(res.body);

        return res.body;
      }
    }else{
      print(res.body);

    }

  }
  List<Asset> images = [];
  String _error = "";
//   Future uploadmultipleimage(List images) async {
//     var uri = Uri.parse(AppUrl.dhr);
//     http.MultipartRequest request = new http.MultipartRequest('POST', uri);
//
//     //multipartFile = new http.MultipartFile("imagefile", stream, length, filename: basename(imageFile.path));
//     List<MultipartFile> newList = new List<MultipartFile>();
//     for (int i = 0; i < images.length; i++) {
//       File imageFile = File(images[i].toString());
//       print(images.length);
//       var stream =
//       new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//       var length = await imageFile.length();
//             String fileName = images[i].path.split("/").last;
//
//       var multipartFile = new http.MultipartFile("image", stream, length,
//           filename: imageFile.path);
//       newList.add(multipartFile);
//     }
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString('token');
//
//     Map<String, String> requestHeaders = {
//       'Accept': 'application/json',
//       'authorization': "Bearer $token"
//     };
//     // ignore this headers if there is no authentication
//     print("headers - $requestHeaders}");
// //add headers
//     request.headers.addAll(requestHeaders);
//     request.files.addAll(newList);
//     var response = await request.send();
//     if (response.statusCode == 200) {
//       print("Image Uploaded");
//     } else {
//       print("Upload Failed");
//     }
//     response.stream.transform(utf8.decoder).listen((value) {
//       print(value);
//     });
//   }
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AssetThumb(
                asset: asset,
                width: 300,
                height: 300,
              ),
            ),
            Positioned(
                left: MediaQuery.of(context).size.width/5,
                child:             IconButton(icon:Icon(Icons.close,color: Colors.red,),onPressed: (){
setState(() {
  images.removeAt(index);

});
                },)
            )
          ],
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;

      if (error == null) _error = 'Selected images';
    });
  }

  /*
      Usage

       final dir = await path_provider.getTemporaryDirectory();

                    final targetPath = dir.absolute.path + "/temp.jpg";
                    File imgFile = await testCompressAndGetFile(
                        File(_capturedImage.path), targetPath);

      * */

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    print("testCompressAndGetFile");
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 30,
      minWidth: 1024,
      minHeight: 1024,
      // rotate: 90,
    );
    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  _uploadImageFun() async {
    print("Note - _getImagePaths called");
    List<File> fileImageArray = [];
    images.forEach((imageAsset) async {
      final filePath =
      await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);
      print(filePath);
      print("filePath.length  - ${filePath.length}");
      print(tempFile);
      print("tempFile.length() - ${tempFile.lengthSync()}");

      if (tempFile.existsSync()) {

        DateTime now = DateTime.now();

        final dir = await getTemporaryDirectory();
        final targetPath =
            dir.absolute.path + "/lookaptPostImage${now.microsecond}.jpg";

        File imgFile =
        await testCompressAndGetFile(File(tempFile.path), targetPath);

        print("Compressed image");
        print(imgFile.lengthSync());
        fileImageArray.add(imgFile); //with image compress
      }
      if (fileImageArray.length == images.length) {
        await  uploadMultipleImage(files: fileImageArray);
      }
    });
    print("Test Prints");
    print(fileImageArray.length);

    return fileImageArray;
  }

TextEditingController type_doc=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:    AppBar(

        backgroundColor: Colors.white,
        title: Text(
          'Upload Images ',style: GoogleFonts.lato(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
          Navigator.pop(context);
        },)
        ,),
        body: _body(),
    );
  }


  Widget _body() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: ListView(
          children: [
            TextField(controller: type_doc,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon:                              Icon(Icons.book_outlined,color: Colors.blue,size: 25,),

            ),
            ),
            SizedBox(height: 10,),
            uploading==false?
Container(
  child: Column(
    children: [

      InkWell(
        onTap: loadAssets,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.grey.shade400,
            child: ListTile(
                leading: Icon(
                  Icons.add_box_outlined,
                  size: 30,
                  color: Colors.black,
                ),
                trailing:Text("Pick Images")
            ),
          ),
        ),

      ),
      SizedBox(height: 20,),
      Container(
        child: buildGridView(),
        width: MediaQuery.of(context).size.width ,
      ),
      images.length>0?ElevatedButton(onPressed: (){
        print('tapp');
        setState(() {
          uploading=true;
        });
        _uploadImageFun();
      }, child: Text(
          'Upload'
      )):Container()
    ],
  ),
):Center(child: Column(
  children: [
    SizedBox(height: MediaQuery.of(context).size.height/2,),
        Text('Please wait while Uploading'),
    LinearProgressIndicator()
  ],
),)

    ],
    ),
    );
  }


}